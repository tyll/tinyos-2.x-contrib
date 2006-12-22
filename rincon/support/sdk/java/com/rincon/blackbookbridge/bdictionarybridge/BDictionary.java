package com.rincon.blackbookbridge.bdictionarybridge;

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


import java.io.IOException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import com.rincon.blackbookbridge.TinyosError;
import com.rincon.util.Util;

import net.tinyos.message.Message;
import net.tinyos.message.MessageListener;
import net.tinyos.message.MoteIF;
import net.tinyos.util.Messenger;

public class BDictionary extends Thread implements BDictionary_Commands,
		MessageListener {

	/** Communication with the mote */
	private static MoteIF comm;

	/** List of FileTransferEvents listeners */
	private static List listeners = new ArrayList();

	/** List of received messages */
	private List receivedMessages = new ArrayList();

	/** Message to send */
	private BDictionaryMsg outMsg = new BDictionaryMsg();

	/** Reply message received from the mote */
	private BDictionaryMsg replyMsg = new BDictionaryMsg();

	/** True if we sent a command and are waiting for a reply */
	private boolean waitingForReply;

	/**
	 * Constructor
	 * 
	 */
	public BDictionary() {
		if (comm == null) {
			comm = new MoteIF((Messenger) null);
			comm.registerListener(new BDictionaryMsg(), this);
			start();
		}
	}

	/**
	 * Thread to handle events
	 */
	public void run() {
		while (true) {
			if (!receivedMessages.isEmpty()) {
				BDictionaryMsg inMsg = (BDictionaryMsg) receivedMessages.get(0);

				if (inMsg != null) {

					switch (inMsg.get_short0()) {
					case BDictionary_Constants.EVENT_OPENED:
						for (Iterator it = listeners.iterator(); it.hasNext();) {
							((BDictionary_Events) it.next())
									.bDictionary_opened(inMsg.get_long0(),
											inMsg.get_long1(), new TinyosError(
													inMsg.get_short1()));
						}
						break;

					case BDictionary_Constants.EVENT_CLOSED:
						for (Iterator it = listeners.iterator(); it.hasNext();) {
							((BDictionary_Events) it.next())
									.bDictionary_closed(new TinyosError(inMsg
											.get_short1()));
						}
						break;

					case BDictionary_Constants.EVENT_INSERTED:
						for (Iterator it = listeners.iterator(); it.hasNext();) {
							((BDictionary_Events) it.next())
									.bDictionary_inserted(inMsg.get_long0(),
											inMsg.get_byteArray(), inMsg
													.get_int0(),
											new TinyosError(inMsg.get_short1()));
						}
						break;

					case BDictionary_Constants.EVENT_RETRIEVED:
						for (Iterator it = listeners.iterator(); it.hasNext();) {
							((BDictionary_Events) it.next())
									.bDictionary_retrieved(inMsg.get_long0(),
											inMsg.get_byteArray(), inMsg
													.get_int0(),
											new TinyosError(inMsg.get_short1()));
						}
						break;

					case BDictionary_Constants.EVENT_REMOVED:
						for (Iterator it = listeners.iterator(); it.hasNext();) {
							((BDictionary_Events) it.next())
									.bDictionary_removed(inMsg.get_long0(),
											new TinyosError(inMsg.get_short1()));
						}
						break;

					case BDictionary_Constants.EVENT_NEXTKEY:
						for (Iterator it = listeners.iterator(); it.hasNext();) {
							((BDictionary_Events) it.next())
									.bDictionary_nextKey(inMsg.get_long0(),
											new TinyosError(inMsg.get_short1()));
						}
						break;

					case BDictionary_Constants.EVENT_FILEISDICTIONARY:
						for (Iterator it = listeners.iterator(); it.hasNext();) {
							((BDictionary_Events) it.next())
									.bDictionary_fileIsDictionary(inMsg
											.get_bool0() == 1, new TinyosError(
											inMsg.get_short1()));
						}
						break;

					case BDictionary_Constants.EVENT_TOTALKEYS:
						for (Iterator it = listeners.iterator(); it.hasNext();) {
							((BDictionary_Events) it.next())
									.bDictionary_totalKeys(inMsg.get_int0());
						}
						break;

					default:
					}

					receivedMessages.remove(inMsg);
				}
			}
		}
	}

	/**
	 * Send a message
	 * 
	 * @param dest
	 * @param m
	 */
	private synchronized void send(int destination) {
		try {
			comm.send(destination, outMsg);
		} catch (IOException e) {
		}
	}

	/**
	 * Add a BDictionary listener
	 * 
	 * @param listener
	 */
	public void addListener(BDictionary_Events listener) {
		if (!listeners.contains(listener)) {
			listeners.add(listener);
		}
	}

	/**
	 * Remove a BDictionary listener
	 * 
	 * @param listener
	 */
	public void removeListener(BDictionary_Events listener) {
		listeners.remove(listener);
	}

	/**
	 * Message received, handle replies immediately and handle events in a
	 * thread
	 */
	public synchronized void messageReceived(int to, Message m) {
		replyMsg = (BDictionaryMsg) m;

		switch (replyMsg.get_short0()) {
		case BDictionary_Constants.REPLY_OPEN:
			waitingForReply = false;
			notify();
			break;

		case BDictionary_Constants.REPLY_ISOPEN:
			waitingForReply = false;
			notify();
			break;

		case BDictionary_Constants.REPLY_CLOSE:
			waitingForReply = false;
			notify();
			break;

		case BDictionary_Constants.REPLY_GETFILELENGTH:
			waitingForReply = false;
			notify();
			break;

		case BDictionary_Constants.REPLY_GETTOTALKEYS:
			waitingForReply = false;
			notify();
			break;

		case BDictionary_Constants.REPLY_INSERT:
			waitingForReply = false;
			notify();
			break;

		case BDictionary_Constants.REPLY_RETRIEVE:
			waitingForReply = false;
			notify();
			break;

		case BDictionary_Constants.REPLY_REMOVE:
			waitingForReply = false;
			notify();
			break;

		case BDictionary_Constants.REPLY_GETFIRSTKEY:
			waitingForReply = false;
			notify();
			break;

		case BDictionary_Constants.REPLY_GETLASTKEY:
			waitingForReply = false;
			notify();
			break;

		case BDictionary_Constants.REPLY_GETNEXTKEY:
			waitingForReply = false;
			notify();
			break;

		case BDictionary_Constants.REPLY_ISFILEDICTIONARY:
			waitingForReply = false;
			notify();
			break;

		default:
			// Events get handled by a separate thread
			receivedMessages.add(m);
		}
	}

	public synchronized TinyosError open(int destination, String fileName,
			long minimumSize) {
		waitingForReply = true;
		while (waitingForReply) {
			outMsg.set_short0(BDictionary_Constants.CMD_OPEN);
			outMsg.set_long0(minimumSize);
			outMsg.set_byteArray(Util.filenameToData(fileName, outMsg
					.get_byteArray().length));
			send(destination);
			try {
				wait(50);
			} catch (InterruptedException e) {
			}
		}
		return new TinyosError(replyMsg.get_short1());
	}

	public synchronized boolean isOpen(int destination) {
		waitingForReply = true;
		while (waitingForReply) {
			outMsg.set_short0(BDictionary_Constants.CMD_ISOPEN);
			send(destination);
			try {
				wait(50);
			} catch (InterruptedException e) {
			}
		}
		return replyMsg.get_bool0() == 1;
	}

	public synchronized TinyosError close(int destination) {
		waitingForReply = true;
		while (waitingForReply) {
			outMsg.set_short0(BDictionary_Constants.CMD_CLOSE);
			send(destination);
			try {
				wait(50);
			} catch (InterruptedException e) {
			}
		}
		return new TinyosError(replyMsg.get_short1());
	}

	public synchronized long getFileLength(int destination) {
		waitingForReply = true;
		while (waitingForReply) {
			outMsg.set_short0(BDictionary_Constants.CMD_GETFILELENGTH);
			send(destination);
			try {
				wait(50);
			} catch (InterruptedException e) {
			}
		}
		return (long) replyMsg.get_long0();
	}

	public synchronized TinyosError getTotalKeys(int destination) {
		waitingForReply = true;
		outMsg.set_short0(BDictionary_Constants.CMD_GETTOTALKEYS);
		send(destination);
		try {
			wait(500);
		} catch (InterruptedException e) {
		}
		return new TinyosError(replyMsg.get_short1());
	}

	public synchronized TinyosError insert(int destination, long key,
			short[] value, int valueSize) {
		waitingForReply = true;
		replyMsg.set_short1(TinyosError.NOTRECEIVED);
		outMsg.set_short0(BDictionary_Constants.CMD_INSERT);
		outMsg.set_long0(key);
		outMsg.set_int0(valueSize);
		outMsg.set_byteArray(Util.truncate(value, outMsg.get_byteArray().length));
		send(destination);
		try {
			wait(1000);
		} catch (InterruptedException e) {
		}
		return new TinyosError(replyMsg.get_short1());
	}

	public synchronized TinyosError retrieve(int destination, long key) {
		waitingForReply = true;
		replyMsg.set_short1(TinyosError.NOTRECEIVED);
		outMsg.set_short0(BDictionary_Constants.CMD_RETRIEVE);
		outMsg.set_long0(key);
		outMsg.set_int0(outMsg.get_byteArray().length);
		send(destination);
		try {
			wait(1000);
		} catch (InterruptedException e) {
		}
		return new TinyosError(replyMsg.get_short1());
	}

	public synchronized TinyosError remove(int destination, long key) {
		waitingForReply = true;
		outMsg.set_short0(BDictionary_Constants.CMD_REMOVE);
		outMsg.set_long0(key);
		send(destination);
		try {
			wait(1000);
		} catch (InterruptedException e) {
		}
		return new TinyosError(replyMsg.get_short1());
	}

	public synchronized TinyosError getFirstKey(int destination) {
		waitingForReply = true;
		outMsg.set_short0(BDictionary_Constants.CMD_GETFIRSTKEY);
		send(destination);
		try {
			wait(500);
		} catch (InterruptedException e) {
		}
		return new TinyosError(replyMsg.get_short1());
	}

	public synchronized long getLastKey(int destination) {
		waitingForReply = true;
		outMsg.set_short0(BDictionary_Constants.CMD_GETLASTKEY);
		send(destination);
		try {
			wait(500);
		} catch (InterruptedException e) {
		}
		return (long) replyMsg.get_long0();
	}

	public synchronized TinyosError getNextKey(int destination, long presentKey) {
		waitingForReply = true;
		outMsg.set_short0(BDictionary_Constants.CMD_GETNEXTKEY);
		outMsg.set_long0(presentKey);
		send(destination);
		try {
			wait(1000);
		} catch (InterruptedException e) {
		}
		return new TinyosError(replyMsg.get_short1());
	}

	public synchronized TinyosError isFileDictionary(int destination,
			String fileName) {
		waitingForReply = true;
		outMsg.set_short0(BDictionary_Constants.CMD_ISFILEDICTIONARY);
		outMsg.set_byteArray(Util.filenameToData(fileName, outMsg
				.get_byteArray().length));
		send(destination);
		try {
			wait(50);
		} catch (InterruptedException e) {
		}
		return new TinyosError(replyMsg.get_short1());
	}

}
