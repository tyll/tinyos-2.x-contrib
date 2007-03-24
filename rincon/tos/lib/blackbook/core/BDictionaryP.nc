/*
 * Copyright (c) 2005-2006 Rincon Research Corporation
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * - Redistributions of source code must retain the above copyright
 *   notice, this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright
 *   notice, this list of conditions and the following disclaimer in the
 *   documentation and/or other materials provided with the
 *   distribution.
 * - Neither the name of the Rincon Research Corporation nor the names of
 *   its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE
 * ARCHED ROCK OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE
 */


/**
 * Blackbook BDictionary Module
 * Allows an application to store and retrieve key-value pairs on flash.
 *
 * This component uses 4 layers of states:
 *   1. At the top layer, this can connect to components outside 
 *      of Blackbook, so it uses the BlackbookState to make sure
 *      operations are done atomically inside of Blackbook.
 *      
 *   2. On the second layer, we keep track of which command is
 *      being performed.  This is CommandState.
 *
 *   2. On the third layer, the DictionaryState takes care of
 *      maintaining individual operations to achieve the goal
 *      the second layer's state reflects.  It is used mainly
 *      for file_t writing and manipulating purposes with flash.
 *
 *   3. On the bottom layer, a SearchState takes care of performing
 *      key searches on flash.  This functionality can technically be
 *      placed in a separate interface, but keeping it altogether
 *      inside this component is a bit easier.  The state of the
 *      SearchState will tell the searching loop when to stop.
 *
 * @author David Moss
 * @author Mark Kranz
 */
    
#include "Blackbook.h"
#include "BDictionary.h"

module BDictionaryP {
  provides {
    interface Init;
    interface BDictionary[uint8_t id];
    interface InternalDictionary[uint8_t id];
  }
  
  uses {
    interface State as BlackbookState;
    interface State as CommandState;
    interface State as DictionaryState;
    interface State as SearchState;
    interface WriteAlloc;
    interface NodeMap;
    interface NodeShop;
    interface GenericCrc;
    interface Fileio;
    interface BlackbookUtil;
    ////interface JDebug;
  }
}

implementation {
  
  
  /**
   * Each client can have an open dictionary
   * simultaneously.  This structure keeps
   * track of the client's dictionary information
   * and state 
   */
  typedef struct client_dictionary_t {

    /** Pointer to the node containing this client's dictionary */
    struct file_t *dictionaryFile;
  
    /** The name of the client's dictionary file_t to store in RAM */
    struct filename_t filename;
  
    /** The data offset to the location of the next key write address */
    uint32_t writeOffset;

    /** The latest written keys in the file_t */
    keycache_t recent[MAX_KEY_CACHE];

  } client_dictionary_t;

  /** Information about each client's dictionary */
  static client_dictionary_t clients[uniqueCount("BDictionary")];
  
  
  /** A buffer for the key metadata to read from flash */
  keymeta_t keyBuffer;
  
  /** The client that made the last request */
  uint8_t currentClient;
  
  /** The current file_t we're working with */
  file_t *currentFile;
  
  /** The current key we're interacting with */
  uint32_t currentKey;
  
  /** The current value's size */
  uint16_t currentValueSize;
  
  /** The current value's crc */
  uint16_t currentValueCrc;
  
  /** A pointer to the current lookup value buffer */
  void *currentValuePtr;
  
  /** The offset in the file_t for our current search */
  uint32_t currentSearchOffset;
  
  /** Marker to locate a key offset to delete after a new key is inserted */
  uint32_t marker;
  
  /** The oldest valid index in the currentClient's cache */
  uint8_t oldestValidCacheIndex;
  
  /** The offset in the file_t for our current search */
  uint32_t currentSearchOffset;
  
  /** The magic number header at the top of each dictionary file_t */
  uint16_t dictionaryHeader;
  
  /** Magic number to hold the value while it's being written from a task */
  uint16_t magicNumber;
  
  /** Copy: Current file_t to copy to */
  file_t *currentFile;
  
  /** Copy: Current offset to write to */
  uint32_t currentWriteOffset;
  
  /** Copy: The total amount of data copied for the current value */
  uint16_t totalAmountCopied;
  
  /** Copy: The amount of data to currently copy from the current value */
  uint8_t currentCopyAmount;
  
  /** Copy: The buffer to copy values from one file_t to another */
  uint8_t valueBuffer[VALUE_COPY_BUFFER_LENGTH];
  
  /** getTotalKeys: The total valid keys in this open dictionary file_t */
  uint16_t totalKeys;
  
  /**
   * CommandState states
   * This is what the overall goal is to accomplish at the moment
   */
  enum {
    S_IDLE_COMMAND = 0,
    
    /** Open command received */
    S_COMMAND_OPEN,
    
    /** Close command received */
    S_COMMAND_CLOSE,
    
    /** Insert command received */
    S_COMMAND_INSERT,
    
    /** Retrieve command received */
    S_COMMAND_RETRIEVE,
    
    /** Remove command received */
    S_COMMAND_REMOVE,
    
    /** NextKey command received */
    S_COMMAND_NEXTKEY,
    
    /** getTotalKey command received */
    S_COMMAND_TOTALKEYS,
    
  };
    
    
  /** 
   * DictionaryState states
   * This is what the individual tasks are doing at the moment
   */
  enum {
    S_IDLE_DICTIONARY = 0,
    
    
    /** Insert: Insert the new keymeta_t */
    S_INSERT_KEY,
    
    /** Insert: Insert the new value */
    S_INSERT_VALUE,
    
    /** Insert: Deleted the old existing key */
    S_INSERT_CLEANUP,
    
    /** Insert: Copy a valid key from the original file_t to a new file_t */
    S_INSERT_KEYCOPY,
    
    /** Insert: Copy a valid value from the original file_t to a new file_t */
    S_INSERT_VALUECOPY,
    
    /** Insert: Change the client's file_t from the old to the new */
    S_INSERT_CHANGEFILES,
    
    /** Remove: Remove the given key */
    S_REMOVE_KEY,

    /** Retrieve: Retrieve a value from flash */
    S_RETRIEVE_VALUE,
   
    /** Open: Search for a duplicate entry for the last key */
    S_INIT_DUPLICATE, 

  };
  
  /**
   * SearchState states
   * This is what type of information the component
   * is searching for in the currentClient's file.
   */
  enum {
    S_IDLE_SEARCH = 0,
    
    /** Stop when the search finds a valid key */
    S_FIND_VALIDKEY,
    
    /** Stop when the search finds a key matching the currentKey */
    S_FIND_CURRENTKEY,
    
    /** Stop when an invalid key is encountered */
    S_FIND_INVALIDKEY,
    
    /** Do not stop until all keys are recorded for initialization */
    S_INIT_ALLKEYS,
    
  };
  
  /***************** Prototypes ****************/
  /** Traverse a newly opened file_t and pull out cache information */
  task void keySearchLoop();

  /** Append a new key entry at the writeOffset of the currentClient's file_t */
  task void appendNewKey();
  
  /** Search for the first key in the current client's open file_t */
  task void getFirstKey();
  
  /** Search for the next key based on the current */
  task void getNextKey();
  
  /** Read a value from the original file_t to copy into the new file_t */
  task void readCopyValue();

  
  /** If the currentClient is not the Checkpoint, reset BlackbookState.toIdle */
  void resetStates();
  
  /** Close out any open file_t in the currentClient */
  void closeCurrentClient();
  
  /** Insert a keycache_t entry into the given client's cache */
  void insertCacheKey(uint8_t client, uint32_t key, uint16_t keyOffset, 
      uint16_t valueCrc, uint16_t valueLength);
  
  /** Remove and fill in the given cache cacheIndex from the client's cache */
  void removeCacheKey(uint8_t client, uint8_t cacheIndex);
  
  /** Remove all entries from the given client's cache */
  void clearCache(uint8_t client);
  
  /** Search the cache for a given key */
  keycache_t *searchCache(uint32_t searchKey, uint8_t startingIndex, 
      uint8_t *indexHolder);
  
  /** Write a magic number to the given offset */  
  void writeMagicNumber(uint32_t offset, uint16_t magic);
 
  /** Adjust the currentSearchOffset and keep searching for a valid key */
  void continueSearch();
  
  /** Stop the current search on flash with the given error */
  void stopSearch(error_t error);
  

  /** Search for the currentKey in the currentClient's file_t on flash */
  void searchForCurrentKey();
  
  /** Search for a valid key in the currentClient's file_t on flash */
  void searchForValidKey();
  
  /** Search for an invalid key in the currentClient's file_t on flash */
  void searchForInvalidKey();
  
  /** Search and initialize the currentClient by traversing through all keys */
  void searchForAllKeys();
  
  /** Process the newly read keymeta_t based on the current states */
  void processKeyBuffer();
  
  
  /** Search is over for a key matching the currentKey */
  void currentKeyFound(uint32_t offset, error_t error);
  
  /** Search is over for a valid key */
  void validKeyFound(uint32_t offset, error_t error);
  
  /** Search is over for an invalid key */
  void invalidKeyFound(uint32_t offset, error_t error);
  
  /** All keys have been traversed in the current file_t for initialization */
  void allKeysFound(uint32_t finalOffset);
  
  /***************** Init Commands ****************/
  command error_t Init.init() {
    int i;
    for(i = 0; i < uniqueCount(UQ_BDICTIONARY); i++) {
      clearCache(i);
      clients[i].dictionaryFile = NULL;
    }
    return SUCCESS;
  }
  
  
  /***************** BDictionary Commands ****************/
  /**
   * Open a BDictionary file.  If the file_t does not exist on flash, the
   * minimumSize will be used to set the length of the file.
   * @param fileName - name of the BDictionary file_t to open
   * @param minimumSize - the minimum reserved size for the file_t on flash.
   * @return SUCCESS if the file_t will be opened
   */
  command error_t BDictionary.open[uint8_t id](char *fileName, 
      uint32_t minimumSize) {
    if(id != INTERNAL_DICTIONARY) {
      if(call BlackbookState.requestState(S_DICTIONARY_BUSY) != SUCCESS) {
        ////call JDebug.jdbg("Dict: blackbookState blocked", 0, 0, 0);
        return FAIL;
      }
    }
    call CommandState.forceState(S_COMMAND_OPEN);
    
    currentClient = id;
    ////call JDebug.jdbg("Dict: %i client", 0, id, 0);
    if(clients[currentClient].dictionaryFile != NULL) {
      // There's already a file open
      
      ////call JDebug.jdbg("Dict: already open", 0, 0, 0);
      resetStates();
      if(call BlackbookUtil.filenameCrc((filename_t *) fileName) == 
          clients[currentClient].dictionaryFile->filenameCrc) {
        // .. and it's the same file.
        //////call JDebug.jdbg("BDP.open: signaling success\n", 0, 0, 0);
        signal BDictionary.opened[currentClient](
            call NodeMap.getReserveLength(clients[currentClient].dictionaryFile), 
                call NodeMap.getReserveLength(
                    clients[currentClient].dictionaryFile) 
                        - clients[currentClient].writeOffset, SUCCESS);
        return SUCCESS;
      }
      
      // The open file is different, we can't open a new one.
      return FAIL;
    }
    
    ////call JDebug.jdbg("Dict: opening...", 0, currentClient, 0);
    call BlackbookUtil.filenameCpy(&clients[currentClient].filename, fileName);
    return call WriteAlloc.openForWriting(fileName, minimumSize, FALSE, TRUE);
  }
  
  /**
   * @return TRUE if the given parameterized interface has a file_t open
   */
  command bool BDictionary.isOpen[uint8_t id]() {
    return (clients[id].dictionaryFile != NULL);
  }
  
  /**
   * Because Dictionary files are special, and NodeMap does not give an
   * accurate reflection of what's going on with Dictionary file_t sizes,
   * this command will return the size of the Dictionary file_t up to the
   * point where valid data ends.
   * @return the size of the valid data in the open dictionary file
   */
  command uint32_t BDictionary.getFileLength[uint8_t id]() {
    if(clients[id].dictionaryFile != NULL) {
      return clients[id].writeOffset;
    }
    
    return 0;
  }
  
  
  /**
   * @return the total valid keys in the open dictionary file
   */
  command error_t BDictionary.getTotalKeys[uint8_t id]() {
    if(id != INTERNAL_DICTIONARY) {
      if(call BlackbookState.requestState(S_DICTIONARY_BUSY) != SUCCESS) {
        return FAIL;
      }
    }
    
    call CommandState.forceState(S_COMMAND_TOTALKEYS);
    currentClient = id;
    totalKeys = 0;
    currentSearchOffset = 0x2;
  
    ////call JDebug.jdbg("Dict: %i getTotalKeys client", 0, id, 0);
    if(clients[currentClient].dictionaryFile != NULL) {
      searchForValidKey();
      return SUCCESS;
    }
    
    resetStates();
    return FAIL;
  }
  
  /**
   * Close any opened BDictionary files
   * @return SUCCESS if the open BDictionary file_t was closed.
   */
  command error_t BDictionary.close[uint8_t id]() {
    currentClient = id;
    ////call JDebug.jdbg("Dict: %i close client", 0, id, 0);
    closeCurrentClient();
    signal BDictionary.closed[id](SUCCESS);
    return SUCCESS;
  }
  
  /**
   * Insert a key-value pair into the opened BDictionary file.
   * This will invalidate any old key-value pairs using the
   * associated key.
   *
   * The process of inserting a key can get tricky when space is running
   * low:
   *
   *   Check to see if the remaining write space in the
   *   client's open flashnode_t is less than the size of the key + value.
   *      
   *      If there isn't enough space:
   *        A. First evaluate the flashnode_t to see if we can solve the 
   *           problem by creating a new node.  If enough space would
   *           exist in the file_t by removing the invalid keys, then continue:
   *        B. Virtually delete the original file_t from flash, but keep its
   *           memory information local.
   *        C. WriteAlloc a new file_t with the original name and size
   *           (or potentially increase its size here).
   *        D. Insert all valid key-value pairs from the original
   *           flash space into to the new file.  Any previous valid
   *           key matching the new key to insert is replaced by the
   *           new key-value pair.
   *        E. Re-initialize the client's file_t into RAM.
   *
   *      If there is enough space:
   *        A. Locate any old valid key and invalidate it.
   *        B. Insert the new key-value pair at the end of the file.
   *
   *       
   * @param key - the key to use
   * @param value - pointer to a buffer containing the value to insert.
   * @param valueSize - the amount of bytes to copy from the buffer
   * @return SUCCESS if the key-value pair will be inserted
   */
  command error_t BDictionary.insert[uint8_t id](uint32_t key, void *value, 
      uint16_t valueSize) {
    keycache_t *cacheEntry;
    uint8_t cacheIndex;
    //trace(1011);
    if(id != INTERNAL_DICTIONARY) {
      if(call BlackbookState.requestState(S_DICTIONARY_BUSY) != SUCCESS) {
        //trace(1012);
        return FAIL;
      }
    }
    //trace(1013);
    //////call JDebug.jdbg("BDP.insert HERE\n", 0, 0, 0);
    
    call CommandState.forceState(S_COMMAND_INSERT);
    
    currentClient = id;
    currentKey = key;
    currentValuePtr = value;
    currentValueSize = valueSize;
    marker = ENTRY_INVALID;
    ////call JDebug.jdbg("Dict: %i insert client", 0, id, 0);
    //////call JDebug.jdbg("BDP.insert: ln 507 key = %xl\n", key, 0, 0);  
    if(clients[currentClient].dictionaryFile == NULL) {
      // No open file
      ////call JDebug.jdbg("FAIL", 0, 0, 0);
      //trace(1014);
      resetStates();
      return FAIL;
    }
    ////call JDebug.jdbg("BDP.insert: ln 513 key = %xl\n", key, 0, 0);  
    
    if(call NodeMap.getReserveLength(clients[currentClient].dictionaryFile) 
        - clients[currentClient].writeOffset 
            < sizeof(keymeta_t) + currentValueSize) {
      /*
       * No more room in this file
       * We need to allocate a new file_t if there is at least one
       * invalid key in the current file.
       */
       ////call JDebug.jdbg("Dict Full", 0, 0, 0);
      //trace(1015);
      searchForInvalidKey();
    
    } else {
      if((cacheEntry = searchCache(currentKey, 0, &cacheIndex)) != NULL) {
        marker = cacheEntry->keyOffset;
        removeCacheKey(currentClient, cacheIndex);
        ////call JDebug.jdbg("BDP.insert: ln 529 key = %xl\n", key, 0, 0);  
        //trace(1016);
        post appendNewKey();
        
      } else {
        //trace(1017);
        ////call JDebug.jdbg("BDP.insert: ln 533 key = %xl\n", key, 0, 0);  
        searchForCurrentKey();
      }
    }
    
    //trace(1019);
    ////call JDebug.jdbg("BDP.insert: ln 537 key = %xl\n", key, 0, 0);  
    
    return SUCCESS;
  }
  
  /**
   * Retrieve a key from the opened BDictionary file.
   *
   * Retrieving a key is done through this process:
   *  1. Look the key up in the cache. If it is found in the
   *     cache, read and retrieve the value from flash.
   *  2. If the key is not found in cache, read each key
   *     from the file_t starting at the beginning looking
   *     for a valid keymeta_t that matches the given key.
   *  3. If no key is found, then no key exists.
   * 
   * @param key - the key to find
   * @param valueHolder - pointer to the memory location to store the value
   * @param maxValueSize - used to prevent buffer overflows incase the
   *     recorded size of the value does not match the space allocated to
   *     the valueHolder
   * @return SUCCESS if the key will be retrieved.
   */
  command error_t BDictionary.retrieve[uint8_t id](uint32_t key, 
      void *valueHolder, uint16_t maxValueSize) {
    keycache_t *cacheEntry;
    uint8_t cacheIndex;
    
    if(id != INTERNAL_DICTIONARY) {
      if(call BlackbookState.requestState(S_DICTIONARY_BUSY) != SUCCESS) {
        return FAIL;
      }
    }
    //////call JDebug.jdbg("BDP.retrieve ln 564 retrieveing key: %xl\n", key, 0, 0);
    call CommandState.forceState(S_COMMAND_RETRIEVE);
    
    currentClient = id;
    currentKey = key;
    currentValuePtr = valueHolder;
    currentValueSize = maxValueSize;
    
    ////call JDebug.jdbg("Dict: %i retrieve client", 0, id, 0);
    if(clients[currentClient].dictionaryFile == NULL) {
      // No open file
      resetStates();
      return FAIL;
    }
    //////call JDebug.jdbg("BDP.retrieve ln 577 retrieveing key: %xl\n", key, 0, 0);
    
    if((cacheEntry = searchCache(currentKey, 0, &cacheIndex)) != NULL) {
      /*
       * Fast-forward our search offset to the location of the key
       * Then continue as if it were found on flash in the search loop.
       */
      currentSearchOffset = cacheEntry->keyOffset;
      call SearchState.forceState(S_FIND_CURRENTKEY);
      post keySearchLoop();
      return SUCCESS;
    }

    if(clients[currentClient].recent[MAX_KEY_CACHE-1].keyOffset 
        == ENTRY_INVALID) {
      // If the cache is not full, then we know
      // the key is not going to exist on flash. So don't bother.
      resetStates();
      //////call JDebug.jdbg("BDP.retrieve ln 595 retrieveing key: %xl\n", key, 0, 0);
      signal BDictionary.retrieved[currentClient](currentKey, currentValuePtr, 
          0, FAIL);
      return SUCCESS;
    }
    
    // No key was found in cache and the cache is full, search the file.
    searchForCurrentKey();
    return SUCCESS;
  }
  
  /**
   * Get the last key inserted into the file.
   * @return the last key, or 0xFFFFFFFF (-1) if it doesn't exist
   */
  command uint32_t BDictionary.getLastKey[uint8_t id]() {
    currentClient = id;
    ////call JDebug.jdbg("Dict: %i getLastKey client", 0, id, 0);
    if(clients[currentClient].dictionaryFile != NULL 
        && clients[currentClient].recent[0].keyOffset != ENTRY_INVALID) {
      return clients[currentClient].recent[0].key;
    }
    
    return -1;
  }
  
  /**
   * Remove a key from the opened dictionary file
   * @param key - the key for the key-value pair to remove
   * @return SUCCESS if the attempt to remove the key will proceed
   */
  command error_t BDictionary.remove[uint8_t id](uint32_t key) {
    keycache_t *cacheEntry;
    uint8_t cacheIndex;
    
    if(id != INTERNAL_DICTIONARY) {
      if(call BlackbookState.requestState(S_DICTIONARY_BUSY) != SUCCESS) {
        return FAIL;
      }
    }
    
    call CommandState.forceState(S_COMMAND_REMOVE);
    call DictionaryState.forceState(S_REMOVE_KEY);
    
    currentClient = id;
    currentKey = key;
    ////call JDebug.jdbg("Dict: %i remove client", 0, id, 0);
    if(clients[currentClient].dictionaryFile == NULL) {
      // No open file
      resetStates();
      return FAIL;
    }
    
    // First try to find the key in cache:
    if((cacheEntry = searchCache(currentKey, 0, &cacheIndex)) != NULL) {
      marker = clients[currentClient].recent[cacheIndex].keyOffset;
      removeCacheKey(currentClient, cacheIndex);
      writeMagicNumber(marker, KEY_INVALID);
      return SUCCESS;
    }

    // The key was not found in cache. Attempt to find it on flash.
    searchForCurrentKey();
    return SUCCESS;
  }
  
  
  /**
   * This command will signal event nextKey
   * when the first key is found.
   * @return SUCCESS if the command will be processed.
   */
  command error_t BDictionary.getFirstKey[uint8_t id]() {
    if(call BlackbookState.requestState(S_DICTIONARY_BUSY) != SUCCESS) {
      return FAIL;
    }
    
    currentClient = id;
    
    ////call JDebug.jdbg("Dict: %i getFirstKey client", 0, id, 0);
    if(clients[currentClient].dictionaryFile == NULL) {
      // No open file
      resetStates();
      return FAIL;
    }
    
    call CommandState.forceState(S_COMMAND_NEXTKEY);
    
    post getFirstKey();
    return SUCCESS;
  }
    
  
  /**
   * Get the next recorded key in the file, based on the current
   * key being passed in.  The current key will be located first,
   * and then the next valid key after it will be returned.
   *
   * When there are no more keys after the present key, or
   * the present key is not valid, the BDictionary will signal FAIL.
   *
   * This way, you can loop through the keys of the file_t at your 
   * leisure, starting at the beginning (and knowing it) or reaching
   * the end (and knowing it).
   *
   * @param presentKey - get the next valid key after this present key
   * @return SUCCESS if the command will be processed
   */
  command error_t BDictionary.getNextKey[uint8_t id](uint32_t presentKey) {
    if(id != INTERNAL_DICTIONARY) {
      if(call BlackbookState.requestState(S_DICTIONARY_BUSY) != SUCCESS) {
        return FAIL; 
      }
    }
    
    currentClient = id;
    currentKey = presentKey;
    ////call JDebug.jdbg("Dict: %i getNextKey client", 0, id, 0);
    if(clients[currentClient].dictionaryFile == NULL) {
      // No open file
      resetStates();
      return FAIL;
    }
    
    call CommandState.forceState(S_COMMAND_NEXTKEY);
    
    post getNextKey();
    return SUCCESS;
  }
  
  /**
   * Find out if a given file_t is a dictionary file
   * @param fileName - the name of the file
   * @return SUCCESS if the command will go through
   */
  command error_t BDictionary.isFileDictionary[uint8_t id](char *fileName) {
    filename_t focusedFilename;
    file_t *focusedFile;
    
    /*
    if(id != INTERNAL_DICTIONARY) {
      if(call BlackbookState.requestState(S_DICTIONARY_BUSY) != SUCCESS) {
        return FAIL;
      }
    }
    */
    
    call BlackbookUtil.filenameCpy(&focusedFilename, fileName);
    
    if((focusedFile = call NodeMap.getFile(&focusedFilename)) != NULL) {
      signal BDictionary.fileIsDictionary[id](focusedFile->firstNode->nodeflags & DICTIONARY, SUCCESS);
      return SUCCESS;
    }
    
    resetStates();
    return FAIL;
  }
  
  
  /***************** Internal Dictionary Commands ****************/
  /**
   * Internal method of checking to see whether a file_t is a dictionary file
   * @param focusedFile - the file_t to check
   * @return SUCCESS if the check will be made
   */
  command error_t InternalDictionary.isFileDictionary[uint8_t id](
      file_t *focusedFile) {
      
    signal BDictionary.fileIsDictionary[id](focusedFile->firstNode->nodeflags & DICTIONARY, SUCCESS);
    return SUCCESS;
  }
  
  /***************** WriteAlloc Events ***************/
  /**
   * The write open process completed
   * @param openFile - the file_t that was opened for writing 
   * @param writeNode - the flashnode_t to write to
   * @param error - SUCCESS if the file_t was correctly opened
   */
  event void WriteAlloc.openedForWriting(file_t *openFile, 
      flashnode_t *writeNode, uint32_t totalSize, error_t error) {
    if(call CommandState.getState() == S_COMMAND_OPEN) {
      if(!error) {
        ////call JDebug.jdbg("Dict: openedForWriting", writeNode->flashAddress, 0, 0);
        currentSearchOffset = sizeof(dictionaryHeader);
        writeNode->nodestate = NODE_VALID;
        clients[currentClient].dictionaryFile = openFile;
        clients[currentClient].writeOffset = sizeof(dictionaryHeader);
        searchForAllKeys();
        //////call JDebug.jdbg("BD:finish: finished open", 0, 0, 0);
        //////call JDebug.jdbg("BD:finish: dataAddr: %xl\n", (uint32_t)&(writeNode->dataLength), 0, 0);
        //////call JDebug.jdbg("BD:finish: dataVal: %xl\n", (uint32_t)(writeNode->dataLength), 0, 0);
    
        return;

      } else {
        clients[currentClient].dictionaryFile = NULL;
        resetStates();
        signal BDictionary.opened[currentClient](0, 0, FAIL);
      }
      
    } else if(call CommandState.getState() == S_COMMAND_INSERT) {
      if(error) {
        resetStates();
        signal BDictionary.inserted[currentClient](currentKey, currentValuePtr, 
            currentValueSize, FAIL);
        return;
      }
      
      clearCache(currentClient);
      currentFile = openFile;
      currentSearchOffset = sizeof(dictionaryHeader);
      currentWriteOffset = sizeof(dictionaryHeader);
      //////call JDebug.jdbg("BD:finish: finished insert\n", 0, 0, 0);
      searchForValidKey();
    }
  }
  
  
  /***************** Fileio Events ****************/
  /**
   * Data was appended to the flashnode_t in the flash.
   * @param writeBuffer - pointer to the buffer containing the data written
   * @param amountWritten - the amount of data appended to the node.
   * @param error - SUCCESS if the data was successfully written
   */
  event void Fileio.writeDone(void *writeBuffer, uint32_t amountWritten, 
      error_t error) {
    
    ////call JDebug.jdbg("BDP.writedone ln 837\n", 0, 0, 0);
    if(call DictionaryState.getState() == S_INSERT_CHANGEFILES){
      post appendNewKey();
      return;
    } 
    //////call JDebug.jdbg("BDP.writedone ln 842\n", 0, 0, 0);
    clients[currentClient].dictionaryFile->firstNode->dataLength -= amountWritten;  
    if(call DictionaryState.getState() == S_INSERT_KEY) {
    
      insertCacheKey(currentClient, keyBuffer.key, 
          clients[currentClient].writeOffset, keyBuffer.valueCrc, 
              keyBuffer.valueLength); 
              
      clients[currentClient].writeOffset += sizeof(keymeta_t);
      
      call DictionaryState.forceState(S_INSERT_VALUE);
      
      call Fileio.writeData(clients[currentClient].dictionaryFile, 
          clients[currentClient].writeOffset, currentValuePtr, 
              currentValueSize);
    //////call JDebug.jdbg("BDP.writedone ln 857\n", 0, 0, 0);
    
    } else if(call DictionaryState.getState() == S_INSERT_VALUE) {
      clients[currentClient].writeOffset += currentValueSize;
      
      //////call JDebug.jdbg("BDP.writedone ln 862\n", 0, 0, 0);
      if(marker != ENTRY_INVALID) {
        // There's an existing key that needs to be invalidated
        call DictionaryState.forceState(S_INSERT_CLEANUP);
        writeMagicNumber(marker, KEY_INVALID);

      } else {
        ////call JDebug.jdbg("Dict: insert flush 887", 0, 0, 0);
        call Fileio.flushData();
      }
 
    } else if(call DictionaryState.getState() == S_INSERT_KEYCOPY) {
      /*
       * The valid key was copied from 
       * clients[currentClient].dictionaryFile->firstNode
       * to currentFile->firstNode at the currentWriteOffset.
       * Now copy the value over in pieces, however big it is.
       * The currentCopyAmount will hold the length of each piece
       * being copied, and the currentWriteOffset will contain
       * the offset in the new file_t to place the new chunk of data.
       */
      //////call JDebug.jdbg("BDP.writedone ln 882\n", 0, 0, 0);
      insertCacheKey(currentClient, keyBuffer.key, currentWriteOffset, 
          keyBuffer.valueCrc, keyBuffer.valueLength);
      currentWriteOffset += sizeof(keymeta_t);
      totalAmountCopied = 0;
      post readCopyValue();
         
    } else if(call DictionaryState.getState() == S_INSERT_VALUECOPY) {
      currentWriteOffset += currentCopyAmount;
      totalAmountCopied += currentCopyAmount;
      
      //////call JDebug.jdbg("BDP.writedone ln 893\n", 0, 0, 0);
      if(totalAmountCopied < keyBuffer.valueLength) {
        post readCopyValue();
        
      } else {
        call DictionaryState.toIdle();
        call SearchState.forceState(S_FIND_VALIDKEY);
        continueSearch();
      }
        
    } else if(call DictionaryState.getState() != S_IDLE_DICTIONARY) {
      call Fileio.flushData();
      //////call JDebug.jdbg("BDP.writedone ln 905\n", 0, 0, 0);
    
    }
  }
  
  /**
   * Data was read from the file
   * @param *readBuffer - pointer to the location where the data was stored
   * @param amountRead - the amount of data actually read
   * @param error - SUCCESS if the data was successfully read
   */
  event void Fileio.readDone(void *readBuffer, uint32_t amountRead, 
      error_t error) {
    
    ////call JDebug.jdbg("BDP.readDone: ReadDone fired ln 919\n", 0, 0, 0);  
    if(call DictionaryState.getState() == S_IDLE_DICTIONARY 
        && call SearchState.getState() == S_IDLE_SEARCH) {
      // Not for me
      return;
    }
    
    if(call DictionaryState.getState() == S_RETRIEVE_VALUE) {
      error &= (call GenericCrc.crc16(0, currentValuePtr, amountRead) 
          == currentValueCrc);
          
      resetStates();
      //////call JDebug.jdbg("BDP.retrieved: error %xs\n", 0, 0, error);
      signal BDictionary.retrieved[currentClient](currentKey, currentValuePtr,
          amountRead, error);
      return;
      
    } else if(call DictionaryState.getState() == S_INSERT_VALUECOPY) {
      //////call JDebug.jdbg("BDP.retrieved writing to file\n", 0, 0, 0);
      call Fileio.writeData(currentFile, currentWriteOffset, &valueBuffer, 
          currentCopyAmount);
      return;
   
    }
    
    //////call JDebug.jdbg("BDP:readDone, ln 949\n", 0, 0, 0);
    if(keyBuffer.magicNumber == KEY_VALID) {
      if(call SearchState.getState() == S_INIT_ALLKEYS) {
        insertCacheKey(currentClient, keyBuffer.key, currentSearchOffset, 
            keyBuffer.valueCrc, keyBuffer.valueLength);
        ////call JDebug.jdbg("BDP:readDone, ln 954\n",0,0,0);
        
        continueSearch();
      
      } else if(call SearchState.getState() == S_FIND_CURRENTKEY) {
        if(keyBuffer.key == currentKey) {
          call SearchState.toIdle();
          //////call JDebug.jdbg("BDP:readDone, ln 961\n",0,0,0);
    
          currentKeyFound(currentSearchOffset, SUCCESS);
         
        } else {
          if(oldestValidCacheIndex != 0xFF) {
            if(clients[currentClient].recent[oldestValidCacheIndex].key 
                == keyBuffer.key) {
              /*
               * Reached the point on flash where the cache steps in.
               * There is no more left to search.
               */
              stopSearch(FAIL);
              //////call JDebug.jdbg("BDP:readDone, ln 74\n",0,0,0);
              return;
            }
          }
          //////call JDebug.jdbg("BDP:readDone, ln 978\n",0,0,0);
    
          continueSearch();
        }
        
      } else if(call SearchState.getState() == S_FIND_VALIDKEY) {
        //////call JDebug.jdbg("BDP:readDone, ln 984\n",0,0,0);
        call SearchState.toIdle();
        validKeyFound(currentSearchOffset, SUCCESS);
      
      } else if(call SearchState.getState() == S_FIND_INVALIDKEY) {
        //////call JDebug.jdbg("BDP:readDone, ln 989\n",0,0,0);
        continueSearch();
        
      }
      
    } else if(keyBuffer.magicNumber == KEY_INVALID) {
      if(call SearchState.getState() == S_FIND_INVALIDKEY) {
        //////call JDebug.jdbg("BDP.readDone: ln 996\n", 0, 0, 0);
        invalidKeyFound(currentSearchOffset, SUCCESS);
        return;
      }
      
      continueSearch();
      
    } else if(keyBuffer.magicNumber == KEY_EMPTY) {
      // Reached the end of the valid keys in the file
      ////call JDebug.jdbg("BDP.readDone: ln 1005\n", 0, 0, 0);
        stopSearch(FAIL);
      
    } else {
      // Unexpected magic number - something's probably corrupt.
      if(call CommandState.getState() == S_COMMAND_OPEN) {
        ////call JDebug.jdbg("BDP.readDone: ln 1011\n", 0, 0, 0);
        closeCurrentClient();
        resetStates();
        signal BDictionary.opened[currentClient](0, 0, FAIL);
        return;
      }
    } 
  }
  
  /**
   * Data was flushed to flash
   * @param error - SUCCESS if the data was flushed
   */
  event void Fileio.flushDone(error_t error) {
    uint8_t dictionaryState;
    dictionaryState = call DictionaryState.getState();
    if(dictionaryState == S_IDLE_DICTIONARY) {
      // Not for me
      return;
    }
    
    ////call JDebug.jdbg("flush done 1052", 0, 0, 0);
    
    if(dictionaryState == S_INSERT_VALUE 
        || dictionaryState == S_INSERT_CLEANUP) {
  
      resetStates();
      ////call JDebug.jdbg("BDP.flushdone error: %xl\n", error, 0, 0);
      signal BDictionary.inserted[currentClient](currentKey, currentValuePtr, 
          currentValueSize, error);

    } else if(dictionaryState == S_REMOVE_KEY) {
      resetStates();
      signal BDictionary.removed[currentClient](currentKey, error);
    
    } else if(dictionaryState == S_INIT_DUPLICATE) {
      ////call JDebug.jdbg("BDP.flush flash=%xl; curClient=%i\n", clients[currentClient].dictionaryFile->firstNode->flashAddress, currentClient, 0);
      resetStates();
      ////call JDebug.jdbg("BDP.opened 1069", 0, 0, 0);
      signal BDictionary.opened[currentClient](call NodeMap.getReserveLength(
          clients[currentClient].dictionaryFile), call NodeMap.getReserveLength(
              clients[currentClient].dictionaryFile) 
                - clients[currentClient].writeOffset, SUCCESS);
    }  
  }
  
  
  /***************** NodeShop Events ****************/
  /** 
   * The node's metadata was written to flash
   * @param focusedNode - the flashnode_t that metadata was written for
   * @param error - SUCCESS if it was written
   */
  event void NodeShop.metaWritten() {
    if(call DictionaryState.getState() == S_INSERT_CHANGEFILES) {
      /*
       * Done turning our constructing file_t into a valid file. Now delete
       * the original.
       *
       * Note that if dictionary files ever are allowed to span more than one
       * node, we need to be deleting all the nodes in this file_t instead of 
       * one.
       */
      
           
      call NodeShop.deleteNode(
          clients[currentClient].dictionaryFile->firstNode);
      
      //////call JDebug.jdbg("BDP.metawritten: need to delete\n", 0, 0, 0);
    }
  }
  
  /**
   * The filename_t was retrieved from flash
   * @param focusedFile - the file_t that we obtained the filename_t for
   * @param *name - pointer to where the filename_t was stored
   * @param error - SUCCESS if the filename_t was retrieved
   */
  event void NodeShop.filenameRetrieved(filename_t *name) {
  }
  
  /**
   * A flashnode_t was deleted from flash by marking its magic number
   * invalid in the metadata.
   * @param focusedNode - the flashnode_t that was deleted.
   * @param error - SUCCESS if the flashnode_t was deleted successfully.
   */
  event void NodeShop.metaDeleted(flashnode_t *focusedNode) {
    if(call DictionaryState.getState() == S_INSERT_CHANGEFILES) {
      focusedNode->nodestate = NODE_EMPTY;
      clients[currentClient].dictionaryFile->filestate = FILE_EMPTY;
      clients[currentClient].dictionaryFile = currentFile;
      clients[currentClient].writeOffset = currentWriteOffset;
      dictionaryHeader = DICTIONARY_HEADER;
      call Fileio.writeData(clients[currentClient].dictionaryFile, 0x0, 
          &dictionaryHeader, sizeof(dictionaryHeader));
      //post appendNewKey();
    }
  }
 
  /**
   * A crc was calculated from flashnode_t data on flash
   * @param dataCrc - the crc of the data read from the flashnode_t on flash.
   * @param error - SUCCESS if the crc is valid
   */
  event void NodeShop.crcCalculated(uint16_t dataCrc) {
  }
  
  /***************** Tasks ****************/
  /**
   * Read the next entry from flash
   */
  task void keySearchLoop() {
    ////call JDebug.jdbg("BDP.keysearchloop currentseachoffset=%xl\n", currentSearchOffset, 0, 0);
    call Fileio.readData(clients[currentClient].dictionaryFile, 
        currentSearchOffset, &keyBuffer, sizeof(keymeta_t));
  }
  
  
  /** 
   * Used on key-value isertion
   * Create the keyBuffer to write from the current values and insert it
   */
  task void appendNewKey() {
    call DictionaryState.forceState(S_INSERT_KEY);
    keyBuffer.magicNumber = KEY_VALID;
    keyBuffer.key = currentKey;
    keyBuffer.valueCrc = call GenericCrc.crc16(0, currentValuePtr, 
        currentValueSize);
    keyBuffer.valueLength = currentValueSize;
    call Fileio.writeData(clients[currentClient].dictionaryFile, 
        clients[currentClient].writeOffset, &keyBuffer, sizeof(keymeta_t));
  }
  
  /**
   * Search the cache, if appropriate, for the first key.  If 
   * we can't search the cache for the first key then we'll search
   * the flash for the first valid key.
   */
  task void getFirstKey() {
    int i;
    /*
     * First try to find the first key in cache.
     * This requires, at the minimum, the last entry of 
     * cache to be empty in order to recognize the first key.
     */
    if(clients[currentClient].recent[MAX_KEY_CACHE-1].keyOffset 
        == ENTRY_INVALID) {
        
      for(i = MAX_KEY_CACHE - 2; i + 1 > 0; i--) {
        if(clients[currentClient].recent[i].keyOffset != ENTRY_INVALID) {
          // This is the first key in the file.
          ////call JDebug.jdbg("Dict: firstKey in cache", 0, 0, 0);
          resetStates();
          signal BDictionary.nextKey[currentClient](
              clients[currentClient].recent[i].key, SUCCESS);
              
          return;
        }
      }
    }
    
    // Or else, the first key must be found in flash.
    ////call JDebug.jdbg("Dict: find firstKey in flash", 0, 0, 0);
    currentSearchOffset = sizeof(dictionaryHeader);
    searchForValidKey();
    return;
  }
  
  
  /** 
   * Get the next key in the current client's file_t based on the current key
   */
  task void getNextKey() {
    int i;
    // First search the cache.
    if(clients[currentClient].recent[0].keyOffset != ENTRY_INVALID 
        && clients[currentClient].recent[0].key == currentKey) {
      // There is no next key.
      resetStates();
      signal BDictionary.nextKey[currentClient](currentKey, FAIL);
      return;
    }
    
    for(i = 1; i < MAX_KEY_CACHE; i++) {
      if(clients[currentClient].recent[i].keyOffset != ENTRY_INVALID 
          && clients[currentClient].recent[i].key == currentKey) {
        resetStates();
        signal BDictionary.nextKey[currentClient](
            clients[currentClient].recent[i-1].key, SUCCESS);
            
        return;
      }
    }
    
    // The present key is not in cache, search the flash
    searchForCurrentKey();
  }
  
  /**
   * Performs the read portion of a minimum two-part operation
   * Copy a value from clients[currentClient].dictionaryFile->firstNode
   * where the key in the original file_t is at the offset currentSearchOffset
   * and the keymeta_t is already stored in keyBuffer,
   * and the currentCopyAmount will store the amount of the value
   * copied into the valueBuffer, and the currentWriteOffset
   * contains the location in the new file_t to write the chunk of
   * data to.  The totalCopyAmount will store the total amount
   * of value copied so far.
   */
  task void readCopyValue() {
    call DictionaryState.forceState(S_INSERT_VALUECOPY);
    currentCopyAmount = keyBuffer.valueLength - totalAmountCopied;
    if(currentCopyAmount > sizeof(valueBuffer)) {
      currentCopyAmount = sizeof(valueBuffer);
    }
    
    call Fileio.readData(clients[currentClient].dictionaryFile, 
        currentSearchOffset + sizeof(keymeta_t) + totalAmountCopied, 
            &valueBuffer, currentCopyAmount);
  }
  

  /***************** Functions ****************/  
  /**
   * Close out any open file_t in the currentClient.
   */
  void closeCurrentClient() {
    if(clients[currentClient].dictionaryFile == NULL) {
      // This client has no open dictionary.
      ////call JDebug.jdbg("Dict: no open dict", 0, 0, 0);
      return;
    }
    ////call JDebug.jdbg("Dict: closing opened dict", 0, 0, 0);
    
    clients[currentClient].dictionaryFile->filestate = FILE_IDLE;
    clients[currentClient].dictionaryFile->firstNode->nodestate = NODE_VALID;    
    clients[currentClient].dictionaryFile = NULL;
    
    memset(&clients[currentClient].recent, 0xFF, 
        sizeof(clients[currentClient].recent));
    return;
  }
  
  
  /**
   * Reset all states to idle 
   */
  void resetStates() {
    call DictionaryState.toIdle();
    call CommandState.toIdle();
    call SearchState.toIdle();
    if(currentClient != INTERNAL_DICTIONARY) {
      call BlackbookState.toIdle();
    }
  }
  
  /**
   * Insert a key into the given client's key cache
   * @param client - the client to insert the keycache_t entry into
   * @param key - the key to record
   * @param keyOffset - the key's offset in the client's file
   */
  void insertCacheKey(uint8_t client, uint32_t key, uint16_t keyOffset, 
      uint16_t valueCrc, uint16_t valueLength) {
    int i;
    for(i = MAX_KEY_CACHE-1; i > 0; i--) {
      memcpy(&clients[client].recent[i], &clients[client].recent[i-1], 
          sizeof(keycache_t));
    }
    clients[client].recent[0].key = key;
    clients[client].recent[0].keyOffset = keyOffset;
  }
  
  /**
   * Remove the given zero-indexed cache element
   * from the given client's cache. This shifts
   * all the elements in to fill in the removed
   * element's spot, ensuring we don't lose any
   * cache information from the end when inserting a new key.
   * @param client - the client to remove from
   * @param cacheIndex - the zero-indexed element to remove.
   */
  void removeCacheKey(uint8_t client, uint8_t cacheIndex) {
    for( ; cacheIndex + 1 < MAX_KEY_CACHE; cacheIndex++) {
      memcpy(&clients[client].recent[cacheIndex], 
          &clients[client].recent[cacheIndex+1], sizeof(keycache_t));
    }
    clients[client].recent[MAX_KEY_CACHE-1].keyOffset = ENTRY_INVALID;
  }
  
  /** 
   * Remove all entries from the given client's cache 
   */
  void clearCache(uint8_t client) {
    memset(&clients[client].recent, 0xFF, sizeof(clients[client].recent));
  }
  
  /**
   * Search the cache for the given key
   * @param searchKey - the key to search for in the current client's cache
   * @param startingIndex - the index to start searching from, backwards
   * @param indexHolder - pointer to a uint8_t storage location for the index number
   * @return a pointer to the keycache_t if found, NULL if not
   */
  keycache_t *searchCache(uint32_t searchKey, uint8_t startingIndex,
      uint8_t *indexHolder) {
    int i; 
    for(i = startingIndex; i < MAX_KEY_CACHE; i++) {
      if(clients[currentClient].recent[i].keyOffset != ENTRY_INVALID 
          && clients[currentClient].recent[i].key == searchKey) {
        *indexHolder = i;
        return &clients[currentClient].recent[i];
      }
    }
    return NULL;
  }
  
  /**
   * Write a magic number to flash
   * Your state will need to be set before entering to catch the Fileio.writeDone
   * event.
   * @param offset - the offset into the file_t to write the magic number
   * @param magic - the magic number to write.
   */
  void writeMagicNumber(uint32_t offset, uint16_t magic) {
    magicNumber = magic;
    call Fileio.writeData(clients[currentClient].dictionaryFile, offset, 
        &magicNumber, sizeof(magic));
  }
  
  
  /**
   * Adjust the currentSearchOffset and continue the search
   * for a valid key in the currentClient's file.
   */
  void continueSearch() {
    currentSearchOffset += sizeof(keymeta_t) + keyBuffer.valueLength;
    //////call JDebug.jdbg("BDP.continueSearch: search offset = %xl\n", currentSearchOffset, 0, 0);
    if(currentSearchOffset + sizeof(keymeta_t) + 1 
        < call NodeMap.getReserveLength(clients[currentClient].dictionaryFile)) {
      post keySearchLoop();
      
    } else {
      // End of file. Stop the search.
      stopSearch(FAIL);
    }
  }
  
  /**
   * Stop the current search on flash with the given error.
   */
  void stopSearch(error_t error) {
    uint8_t searchState = call SearchState.getState();
    call SearchState.toIdle();
    
    if(searchState == S_FIND_VALIDKEY) {
      validKeyFound(currentSearchOffset, error);
      
    } else if(searchState == S_FIND_CURRENTKEY) {
      currentKeyFound(currentSearchOffset, error);
      
    } else if(searchState == S_FIND_INVALIDKEY) {
      invalidKeyFound(currentSearchOffset, error);
      
    } else if(searchState == S_INIT_ALLKEYS) {
      allKeysFound(currentSearchOffset);
    }
  }
  
  
  /**
   * Search for the currentKey in the currentClient's file_t on flash
   * This will execute currentKeyFound(..) when done
   */
  void searchForCurrentKey() {
    int i;
    currentSearchOffset = sizeof(dictionaryHeader);
    
    /*
     * Locate the oldest recent key entry in cache.
     * This does not search the cache!
     * This is used so we only read the file_t up to the point
     * of where the cache steps in.  We don't need to read
     * any values from flash after the oldest value in cache because
     * the current key won't be there, assuming we already checked the
     * cache for the key's existance.
     */
    oldestValidCacheIndex = 0xFF;
    
    for(i = MAX_KEY_CACHE - 1; i > 0; i--) {
      if(clients[currentClient].recent[i].keyOffset != ENTRY_INVALID) {
        oldestValidCacheIndex = (uint8_t) i;
      }
    }
    
    call SearchState.forceState(S_FIND_CURRENTKEY);
    post keySearchLoop();
  }
  
  /** 
   * Search for a valid key in the currentClient's file_t on flash 
   * This will execute validKeyFound(..) when done
   * The search will begin in the file_t at the currentSearchOffset,
   * which should already be defined.  You can call this 
   * function over and over the continue the search after
   * the currentSearchOffset is updated manually, or you can
   * set the SearchState to S_FIND_VALIDKEY yourself and
   * then call continueSearch to automatically update the 
   * currentSearchOffset as long as the keyBuffer data
   * from the last search is not touched.
   */
  void searchForValidKey() {
    call SearchState.forceState(S_FIND_VALIDKEY);
    post keySearchLoop();
  }
  
  /** 
   * Search for an invalid key in the currentClient's file_t on flash
   * This will execute invalidKeyFound(..) when done.
   */
  void searchForInvalidKey() {
    currentSearchOffset = sizeof(dictionaryHeader);
    call SearchState.forceState(S_FIND_INVALIDKEY);
    post keySearchLoop();
  }
  
  /** 
   * Search and initialize the currentClient by traversing 
   * through all keys
   * This will execute allKeysFound(..) when done and setup
   * the currentClient's cache and information while traversing.
   */
  void searchForAllKeys() {
    currentSearchOffset = sizeof(dictionaryHeader);
    call SearchState.forceState(S_INIT_ALLKEYS);
    post keySearchLoop();
  }
 
  
  /**
   * A valid key on flash matching the currentKey
   * was found. Do what you want with it based on the current states.
   * @param offset - data offset in the currentClient's file_t to 
   *     the keymeta_t
   * @param error - SUCCESS if the key was really found.
   */
  void currentKeyFound(uint32_t offset, error_t error) {
    if(call CommandState.getState() == S_COMMAND_NEXTKEY) {
      if(!error) {
        // Present key found, get the valid key after it:
        call SearchState.forceState(S_FIND_VALIDKEY);
        continueSearch();
        
      } else {
        // The present key was not found in the file.
        resetStates();
        signal BDictionary.nextKey[currentClient](currentKey, FAIL);
      }
      return;
    
    } else if(call CommandState.getState() == S_COMMAND_INSERT) {
      if(!error) {
        // Key found, mark it for deletion after insertion is complete
        marker = offset;
      }
      
      post appendNewKey();
      return;
    
    } else if(call CommandState.getState() == S_COMMAND_OPEN) {
      if(!error) {
        if(offset != marker) {
          // This is a duplicate entry. Delete the last entry, which is
          // located at the marker.
          writeMagicNumber(marker, KEY_INVALID);
          return;
        }   
      }
      
      // No duplicate keys found, signal file_t opened correctly
      call Fileio.flushData();
      
    } else if(call CommandState.getState() == S_COMMAND_REMOVE) {
      if(!error) {
        writeMagicNumber(offset, KEY_INVALID);
        return;
      }
      
      // Key not found - consider it removed.
      call Fileio.flushData();
        
    } else if(call CommandState.getState() == S_COMMAND_RETRIEVE) {
      if(!error && currentValueSize >= keyBuffer.valueLength) {
        call DictionaryState.forceState(S_RETRIEVE_VALUE);
        currentValueCrc = keyBuffer.valueCrc;
        call Fileio.readData(clients[currentClient].dictionaryFile, offset + 
            sizeof(keymeta_t), currentValuePtr, keyBuffer.valueLength);
        return;
      }
      
      // No key found on flash to retrieve or read failed.
      resetStates();
      signal BDictionary.retrieved[currentClient](currentKey, currentValuePtr, 
          0, FAIL);
    }
  }
  
  /**
   * A valid key was found for the currentClient on flash
   * Do what you want with it based on the current states.
   * @param offset - data offset to the keymeta_t
   * @param error - SUCCESS if a valid key was found after
   *     the starting currentSearchOffset
   */
  void validKeyFound(uint32_t offset, error_t error) {
    if(call CommandState.getState() == S_COMMAND_NEXTKEY) {
      resetStates();
      signal BDictionary.nextKey[currentClient](keyBuffer.key, error); 
    
    } else if(call CommandState.getState() == S_COMMAND_TOTALKEYS) {
      //////call JDebug.jdbg("BDP.validKeyFound: commState = totalKeys, error=%xs\n", 0, 0, error);
      if(!error) {
        totalKeys++;
        call SearchState.forceState(S_FIND_VALIDKEY);
        continueSearch();
        
      } else {
        resetStates();
        signal BDictionary.totalKeys[currentClient](totalKeys);
      }
      
    } else if(call CommandState.getState() == S_COMMAND_INSERT) {
      if(!error) {
        if(keyBuffer.key == currentKey) {
          // Do not copy over the key we're trying to replace
          call SearchState.forceState(S_FIND_VALIDKEY);
          continueSearch();
          return;  
        }
        
        call DictionaryState.forceState(S_INSERT_KEYCOPY);
        call Fileio.writeData(currentFile, currentWriteOffset, &keyBuffer, 
            sizeof(keymeta_t));
      
      } else {
        /* 
         * We're done finding valid keys in the old file.
         * 1. Change the state of our new file's flashnode_t to VALID
         * 2. Write the metadata to flash to reflect that flashnode_t is valid
         *    If a catastrophic failure occurs here, 2 valid files with
         *    the same name will be found on flash.  Either one can
         *    be deleted at boot.
         * 3. Delete the original node, and make its file_t EMPTY.
         * 4. Set the current client's dictionary file_t to the currentFile.
         */
        
        currentFile->firstNode->nodestate = NODE_VALID;
        currentFile->firstNode->nodeflags = DICTIONARY;
        call DictionaryState.forceState(S_INSERT_CHANGEFILES);
        call NodeShop.writeNodemeta(NULL, currentFile->firstNode, NULL);
        //These lines need to be included somewhere so the dictionary tag gets written to flash
        /*
        dictionaryHeader = DICTIONARY_HEADER;
        call Fileio.writeData(clients[currentClient].dictionaryFile, 0x0, 
          &dictionaryHeader, sizeof(dictionaryHeader));
          */
      }
    }
  }
  
  /**
   * An invalid key was found in the currentClient's file_t on flash
   * Do what you want with it based on the current states
   * @param offset - data offset to the keymeta_t
   * @param error - SUCCESS if an invalid key was found.
   */
  void invalidKeyFound(uint32_t offset, error_t error) {
    if(!error) {
      /*
       * An invalid key was found, so the valid keys from this
       * file_t can be moved to a new file.  Force a new dictionary
       * to be created and fill in its name on flash and in the NodeMap later.
       * This would be a good spot, or at least a good way to increase the 
       * size of the dictionary file, too.
       */
      //////call JDebug.jdbg("BDP.invalidFound: creating new dict file, len: %xl\n", 
        //clients[currentClient].dictionaryFile->firstNode->reserveLength, 0, 0);  
      if(SUCCESS == call WriteAlloc.openForWriting(clients[currentClient].filename.getName,
          clients[currentClient].dictionaryFile->firstNode->reserveLength, 
              TRUE, TRUE)) {
        return;
      }
    }
      
    // No invalid key found, the associated file_t wasn't found, or write failed
    resetStates();
    signal BDictionary.inserted[currentClient](currentKey, currentValuePtr, 
        currentValueSize, FAIL);
  }
  
  /**
   * All keys have been found in the currentClient's file.
   * This concludes opening a file.
   * @param finalOffset - the address we can write to next
   * @param error - SUCCESS if all keys were found
   */
  void allKeysFound(uint32_t finalOffset) {
    uint8_t cacheIndex;
 
    clients[currentClient].writeOffset = finalOffset;
          
    call DictionaryState.forceState(S_INIT_DUPLICATE);
    
    // Look for duplicates if there are at least 2 keys
    if(clients[currentClient].recent[1].keyOffset != ENTRY_INVALID) {
      /* 
       * Search for a duplicate to the last entry in the file
       * If a duplicate is found, we'll erase the latest entry.
       */
      currentKey = clients[currentClient].recent[0].key;
      marker = clients[currentClient].recent[0].keyOffset;
      
      if(searchCache(currentKey, 1, &cacheIndex) != NULL) {
        removeCacheKey(currentClient, 0);
        writeMagicNumber(marker, KEY_INVALID);
        return;
        
      } else if(clients[currentClient].recent[MAX_KEY_CACHE-1].keyOffset 
          != ENTRY_INVALID) {
        searchForCurrentKey();
        return;
      }
    }

    if(clients[currentClient].recent[0].keyOffset == ENTRY_INVALID) {
      /*
       * There are no keys in this file,
       * Write the dictionary header
       * This is picked up by the call DictionaryState.getState() != IDLE 
       * in the writeDone event:
       */
      dictionaryHeader = DICTIONARY_HEADER;
      call Fileio.writeData(clients[currentClient].dictionaryFile, 0x0, 
          &dictionaryHeader, sizeof(dictionaryHeader));
      return;
    }
    
    // Done opening the file, signal opened
    call Fileio.flushData();
  }
  
  
  /***************** Defaults ****************/
  default event void BDictionary.opened[uint8_t id](uint32_t totalSize, 
      uint32_t remainingBytes, error_t error) {
  }

  default event void BDictionary.closed[uint8_t id](error_t error) {
  }

  default event void BDictionary.inserted[uint8_t id](uint32_t key, void *value,
      uint16_t valueSize, error_t error) {
  }

  default event void BDictionary.retrieved[uint8_t id](uint32_t key, 
      void *valueHolder, uint16_t valueSize, error_t error) {
  }

  default event void BDictionary.removed[uint8_t id](uint32_t key, 
      error_t error) {
  }
  
  default event void BDictionary.nextKey[uint8_t id](uint32_t nextKey, 
      error_t error) {
  }
  
  default event void BDictionary.fileIsDictionary[uint8_t id](bool isDictionary,
      error_t error) {
  }
  
  default event void BDictionary.totalKeys[uint8_t id](uint16_t keys) {
  }
  
}

