/**
 * file:        BundleIndexC.nc
 * description: BundleIndex object implementation
 *
 * author:      Gaurav Mathur, UMass Computer Science Dept.
 * author:      Jacob Sorber, UMass Computer Science Dept.
 * $Id$
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 *
 **/

/*
 * BundleIndex implementation
 */

includes app_header;
includes common_header;
includes SingleStream;

module BundleIndexC {
	provides interface Index[uint8_t id];
	provides interface Serialize[uint8_t id];
	provides interface Compaction[uint8_t id];
	provides interface BundleIndex[uint8_t id];
	
	uses {
		interface ChunkStorage;
		interface Array;
		interface Leds;
		interface Console;
		interface SingleCompaction;
	}
}

implementation 
{
	enum
	{
		SETTING, 
		GETTING, 
		SAVING, 
		LOADING, 
		DELETING
	};
	flashptr_t *Tsave_ptr;
	unsigned int Tarrindex, Tindex;
	void *Tdata;
	datalen_t Tlen, *Tlen_;
#ifdef INDEX_DEBUG
    datalen_t *Tlen__;
#endif
	datalen_t Blen;
    uint8_t indexif_id;
	uint8_t state, state2;
	bool compacting;
	struct _data
	{
		flashptr_t head; // back this up
		bool doEcc;
		index_header buffer;
		//bool written;	// keeps track of Saved Status
		pageptr_t old_indexptr;
		int16_t headidx; //need to save this
		int16_t tailidx; //this too
		int16_t traverse_idx;
		
	}local[NUM_BUNDLE_INDEXES];
	bool indexbusy;

	/* Compaction data */
	datalen_t clen;
	uint16_t compactptr;
	uint8_t buff[LEN];
	bool buffModify = FALSE;

	task void loadData();
	task void saveData();
	task void compact_get();
	task void compact_set();
	task void compact_stream();
	task void compact_finish();
	task void deleteData();
	task void loadArrPage();
    /*********************************************
	************** Lock / Unlock ****************
	*********************************************/
	result_t lock()
	{
		bool localBusy;

		atomic 
		{
			localBusy = indexbusy;
			indexbusy = TRUE;
		}

		if (TRUE != localBusy)
		{
			return (SUCCESS);
		}
		else
		{
			return (FAIL);
		}
	}

	void unlock()
	{
		indexbusy = FALSE;
	}

	task void SuccessRespond()
	{
		unlock();
        //call Leds.redOn();

		if (state == SAVING)
		{
			signal Index.saveDone[indexif_id](SUCCESS);
		} else 
		{
			if(state == LOADING)
			{
				signal Index.loadDone[indexif_id](SUCCESS);
				//signal BundleIndex.loadDone[indexif_id](SUCCESS);
			}
		}
	}

	task void FailRespond()
	{
		unlock();
        //call Leds.redOn();

		if (state2 == SETTING)
			signal Index.setDone[indexif_id](FAIL);
		else if (state2 == GETTING)
			signal Index.getDone[indexif_id](FAIL);
		else
			signal Index.saveDone[indexif_id](FAIL);
	}

	task void FailRespond2()
	{
		unlock();

		if (state == SAVING)
			signal Index.saveDone[indexif_id](FAIL);
		else if (state == LOADING)
			signal Index.loadDone[indexif_id](FAIL);
	}


	task void loadTask()
	{
		uint8_t ecc;
		flashptr_t temp;
		
		memset(&temp, 0xFF, sizeof(flashptr_t));
			
		if (memcmp(&local[indexif_id].head, &temp, sizeof(flashptr_t)) != 0)
		{
#ifdef INDEX_DEBUG
                call Console.string("Abt 2 rd th ndx\n");
                TOSH_uwait(30000L);
#endif
			
            if (SUCCESS != call ChunkStorage.read(&local[indexif_id].head, 
				NULL, 0,
				&local[indexif_id].buffer, NULL,
				FALSE, &ecc))
{
#ifdef INDEX_DEBUG
                call Console.string("RR! nbl 2 rd n th ndx\n");
                TOSH_uwait(30000L);
#endif
                post FailRespond2();
}
		}
		else
{
#ifdef INDEX_DEBUG
                call Console.string("memsetng\n");
                TOSH_uwait(30000L);
#endif
            memset(&local[indexif_id].buffer, 0xFF, sizeof(index_header));
            post SuccessRespond();
}

	}

    /***********
	* This loads the index from flash to memory
	***********/
	command result_t Index.load[uint8_t id](bool ecc)
{
	if (lock() != SUCCESS)
	{
#ifdef LOCK_DEBUG
            call Console.string("ERROR ! Unable to acquire index load lock\n");
            TOSH_uwait(30000L);
#endif
            return (FAIL);
	}
#ifdef LOCK_DEBUG
        call Console.string("Acquired index load lock\n");
        TOSH_uwait(30000L);
#endif

        local[id].doEcc = ecc;        
        state = LOADING;
		indexif_id = id;

		post loadTask();

		return (SUCCESS);
}

    task void saveTask()
{
	if (SUCCESS != call ChunkStorage.write(NULL, 0,
		&local[indexif_id].buffer, 
		sizeof(index_header), 
		FALSE, &local[indexif_id].head))
	{
#ifdef INDEX_DEBUG
            call Console.string("Fld 2 sv ndx 2 flsh\n");
            TOSH_uwait(30000L);
#endif
            post FailRespond2();
	}
}

    /***********
     * This saves the index from memory to flash
	***********/
    task void save_l1_index()
{
 
	/* Save the current page */
	if (buffModify == TRUE)
	{
#ifdef INDEX_DEBUG
			call Console.string("Sv crrnt l1 ndx (old ");
			call Console.decimal(local[indexif_id].old_indexptr);
			call Console.string(" if:  ");
			call Console.decimal(indexif_id);
			call Console.string(")\n");
			TOSH_uwait(30000L);
#endif

            if (SUCCESS != call Array.save(&local[indexif_id].buffer.ptr[local[indexif_id].old_indexptr]))
			{
#ifdef INDEX_DEBUG
                call Console.string("Svng crrnt lvl1 ndx fld\n");
                TOSH_uwait(30000L);
#endif
                post FailRespond();
			}
	}
	else if (state == SAVING)
	{
		post saveTask();
	}
	else
	{
		post loadArrPage();
	}
}


    command result_t Index.save[uint8_t id](flashptr_t *save_ptr)
{
	if (lock() != SUCCESS)
	{
#ifdef LOCK_DEBUG
            call Console.string("ERROR ! Unable to acquire index save lock\n");
            TOSH_uwait(30000L);
#endif
            return (FAIL);
	}
#ifdef LOCK_DEBUG
        call Console.string("Acquired index save lock\n");
        TOSH_uwait(30000L);
#endif

        Tsave_ptr = save_ptr;
        indexif_id = id;

		state2 = state = SAVING;

		post save_l1_index();

		return (SUCCESS);
}
    
    /***********
     * This sets a (key, value) pair into the Index
	***********/
    command result_t Index.set[uint8_t id](unsigned int arr_index, void *data, 
										   datalen_t len, flashptr_t *save_ptr)
{
	if (lock() != SUCCESS)
	{
#ifdef LOCK_DEBUG
		call Console.string("ERROR! Unable to acquire index set lock\n");
		TOSH_uwait(30000L);
#endif
		return (FAIL);
	}
#ifdef LOCK_DEBUG
		call Console.string("Acqrd ndx st lck\n");
		TOSH_uwait(30000L);
#endif
#ifdef INDEX_DEBUG
		call Console.string("St idx: ");
		call Console.decimal(arr_index);
		call Console.string("\n");
		TOSH_uwait(30000L);
#endif

		/* Calculate data storage location */
		Tindex = arr_index / ARRAY_ELEMENTS_PER_CHUNK;
		Tarrindex = arr_index % ARRAY_ELEMENTS_PER_CHUNK;
	
		Tdata = data;
		Tlen = len;
		Tsave_ptr = save_ptr;
		indexif_id = id;
        
#ifdef INDEX_DEBUG
		call Console.string("Tindex:");
		call Console.decimal(Tindex);
		call Console.string(" Tarrindex: ");
		call Console.decimal(Tarrindex);
		call Console.string("\n");
		TOSH_uwait(30000L);
#endif

		
		/* If new page being accessed is different -> 
				save currently loaded page and load relevant page */
		if(local[id].old_indexptr != Tindex)
		{
#ifdef INDEX_DEBUG
			call Console.string("Wll hv 2 ld pg...\n");
			TOSH_uwait(30000L);
#endif
			state2 = state = SETTING;
			post save_l1_index();
		}
		
		else if (local[id].old_indexptr == 0xFFFF)
		{
			post loadArrPage();
		}
        else
		{
#ifdef INDEX_DEBUG
			call Console.string("Pg lrdy ldd. svng data\n");
			TOSH_uwait(30000L);
#endif
			/* Relevant page is already loaded */
			post saveData();
		}

        return (SUCCESS);
}


    task void loadArrPage()
{
	/* Check if the lower level array page exists */
	if ((local[indexif_id].buffer.ptr[Tindex].page == 0xFFFF) && 
			(local[indexif_id].buffer.ptr[Tindex].offset == 0xFF))
	{
		/* Lower level array page does not exist -> load a new one */
		if (SUCCESS != call Array.load(NULL, TRUE, local[indexif_id].doEcc))
		{
#ifdef LOCK_DEBUG
                call Console.string("Level 1 index load failed\n");
                TOSH_uwait(30000L);
#endif
                post FailRespond();
		}
	}
	else
	{
#ifdef INDEX_DEBUG
            call Console.string("Ldng lvl1 idx pg :");
            call Console.decimal(Tindex);
			call Console.string(" if: ");
			call Console.decimal(&indexif_id);
			call Console.string(" from pg: ");
			call Console.decimal(local[indexif_id].buffer.ptr[Tindex].page);
			call Console.string(" off: ");
			call Console.decimal(local[indexif_id].buffer.ptr[Tindex].offset);
			call Console.string("\n");
			TOSH_uwait(40000L);
#endif

            /* Load level 1 index */
            if (SUCCESS != call Array.load(&local[indexif_id].buffer.ptr[Tindex],
				FALSE, FALSE))
{
#ifdef INDEX_DEBUG
                call Console.string("Ldng lvl1 idx fld\n");
                TOSH_uwait(30000L);
#endif
                post FailRespond();
}
	}
}

    event void Array.saveDone(result_t res)
{
	if (res == SUCCESS)
	{
            //local[indexif_id].written = TRUE;
		buffModify = FALSE;

		if (state == SAVING)
			post saveTask();
		else
			post loadArrPage();

#ifdef INDEX_DEBUG
		call Console.string("Svd lvl1 ndx pg :idx ");
		call Console.decimal(local[indexif_id].old_indexptr);
		call Console.string(" if: ");
		call Console.decimal(&indexif_id);
		call Console.string(" to pg: ");
		call Console.decimal(local[indexif_id].buffer.ptr[local[indexif_id].old_indexptr].page);
		call Console.string(" off: ");
		call Console.decimal(local[indexif_id].buffer.ptr[local[indexif_id].old_indexptr].offset);
		call Console.string("\n");
		TOSH_uwait(40000L);

		{
			int i;

			for (i=0; i < INDEX_ELEMENTS_PER_CHUNK; i++)
			{
				call Console.string("IDX:Elmnt:");
				call Console.decimal(i);
				call Console.string(" pge: ");
				call Console.decimal(local[indexif_id].buffer.ptr[i].page);
				call Console.string(" off: ");
				call Console.decimal(local[indexif_id].buffer.ptr[i].offset);
				call Console.string("\n");
				TOSH_uwait(40000L);
			}
		}
#endif
	}
	else
	{
#ifdef INDEX_DEBUG
		call Console.string("Svng lvl 1 ndx fld\n");
		TOSH_uwait(40000L);
#endif
		post FailRespond();
	}
}

	task void saveData()
	{
#ifdef INDEX_DEBUG
        
		call Console.string("Index.savedata : Tarrindex ");
        call Console.decimal(Tarrindex);
		call Console.string(" Tdata ");
		call Console.decimal(Tdata);
		call Console.string(" Tlen ");
		call Console.decimal(Tlen);
		call Console.string(" indexif_id ");
		call Console.decimal(indexif_id);
		call Console.string(" Tindex ");
		call Console.decimal(Tindex);
		call Console.string("\n");
		TOSH_uwait(40000L);
		
#endif
        buffModify = TRUE;

        /* Write the data */
        if(SUCCESS != call Array.set(Tarrindex, Tdata, Tlen, 
		   &local[indexif_id].buffer.ptr[Tindex]))
		//if(SUCCESS != call Array.set(Tarrindex, Tdata, Tlen, 
        //                             Tsave_ptr))
		{
#ifdef INDEX_DEBUG
            call Console.string("Set'g idx dt fld\n");
            TOSH_uwait(30000L);
#endif
            post FailRespond();
		}
	}

    event void Array.setDone(result_t res)
{
#ifdef INDEX_DEBUG
        if (res == SUCCESS)
		{	
			call Console.string("St'g arr suc idx:");  
			call Console.decimal(Tindex);
			call Console.string(" pg: ");  
			call Console.decimal(local[indexif_id].buffer.ptr[Tindex].page);
			call Console.string(" off: ");  
			call Console.decimal(local[indexif_id].buffer.ptr[Tindex].offset);
			call Console.string("\n");  
		}	
        else
			call Console.string("Set'g arr fld\n");
		
		TOSH_uwait(30000L);
		TOSH_uwait(30000L);
#endif

        if ((res == SUCCESS) && (Tsave_ptr != NULL))
            memcpy (Tsave_ptr, &local[indexif_id].buffer.ptr[Tindex], sizeof(flashptr_t));
        
        unlock();
#ifdef LOCK_DEBUG
        call Console.string("Released index set lock\n");
        TOSH_uwait(30000L);
#endif
        if (!compacting)
            signal Index.setDone[indexif_id](res);
        else
{
	post compact_stream();
            
}
}

    /***********
     * This gets the value associated with a key
	***********/
    command result_t Index.get[uint8_t id](unsigned int arr_index, void *data, 
										   datalen_t *len)
{
	if (lock() != SUCCESS)
	{
#ifdef LOCK_DEBUG
            call Console.string("ERROR ! Unable to acquire index get lock: ");
            call Console.decimal(indexbusy);
			call Console.string("\n");
			TOSH_uwait(30000L);
#endif
            return (FAIL);
	}
#ifdef LOCK_DEBUG
        call Console.string("Acquired index get lock\n");
#endif
#ifdef INDEX_DEBUG
        call Console.string("Gt ndx: ");
        call Console.decimal(arr_index);
		call Console.string("\n");
		TOSH_uwait(30000L);
#endif

        /* Calculate data storage location */
        Tindex = arr_index / ARRAY_ELEMENTS_PER_CHUNK;
        Tarrindex = arr_index % ARRAY_ELEMENTS_PER_CHUNK;
		Tdata = data;
		Tlen_ = len;
		indexif_id = id;
       
		state2 = state = GETTING;
        
#ifdef INDEX_DEBUG
        call Console.string("Tindex: ");
        call Console.decimal(Tindex);
		call Console.string("\n");
		TOSH_uwait(30000L);
		call Console.string("old_indexptr: ");
		call Console.decimal(local[indexif_id].old_indexptr);
		call Console.string("\n");
		TOSH_uwait(30000L);

#endif
		if (Tindex == local[indexif_id].old_indexptr)
{
	/* Level 1 index is already loaded */
	post loadData();
}
		else if (local[indexif_id].old_indexptr == 0xFFFF)
{
	post loadArrPage();
}
        else
{
	/* Save the current page */
            //if (SUCCESS != call Array.save(&local[id].buffer.ptr[Tindex]))
	if (SUCCESS != call Array.save(&local[id].buffer.ptr[local[id].old_indexptr]))
	{
#ifdef INDEX_DEBUG
                call Console.string("Svng crrnt lvl1 ndx fld\n");
                TOSH_uwait(30000L);
#endif
                unlock();
                return (FAIL);
	}
}
        
        return (SUCCESS);
}

	
	
    /*event void Array.loadDone(result_t res)
{
        if (res == SUCCESS)
{
            local[indexif_id].old_indexptr = Tindex;
            buffModify = FALSE;

            if (state == SETTING)
{
                post saveData();
}
            else if (state == GETTING)
{
                post loadData();
}
}
        else
{
#ifdef INDEX_DEBUG
            call Console.string("Loading level 1 index failure\n");
            TOSH_uwait(30000L);
#endif
            post FailRespond();
}
}*/
	
	event void Array.loadDone(result_t res)
{
	if (res == SUCCESS)
	{
#ifdef INDEX_DEBUG
            call Console.string("LoadDone: Tindex=");
            call Console.decimal(Tindex);
			call Console.string("\n");
			TOSH_uwait(30000L);
#endif
            local[indexif_id].old_indexptr = Tindex;
            buffModify = FALSE;

			if (state == SETTING)
			{
				post saveData();
			}
			else if (state == GETTING)
			{
#ifdef INDEX_DEBUG
            call Console.string("loadDone: indexif_id ");
            call Console.decimal(&indexif_id);
			call Console.string("\n");
			TOSH_uwait(30000L);
#endif
				post loadData();
			}
			else if (state == DELETING)
			{
				post deleteData();
			}

	}
	else
	{
#ifdef INDEX_DEBUG
            call Console.string("Ldng lvl1 ndx fld\n");
            TOSH_uwait(30000L);
#endif
            post FailRespond();
	}
}


    task void deleteData()
{
#ifdef INDEX_DEBUG
        call Console.string("Index.deletedata : Tarrindex ");
        call Console.decimal(Tarrindex);
		call Console.string(" indexif_id ");
		call Console.decimal(&indexif_id);
		call Console.string(" Tindex ");
		call Console.decimal(Tindex);
		call Console.string("\n");
		TOSH_uwait(5000);
#endif

        buffModify = TRUE;

        /* Write the data */
        if(SUCCESS != call Array.delete(Tarrindex))
		{
#ifdef INDEX_DEBUG
            call Console.string("Dltng ndx dt fld\n");
            TOSH_uwait(30000L);
#endif
            post FailRespond();
		}

		unlock();
		signal Index.deleteDone[indexif_id](SUCCESS);
}
	

    task void loadData()
{
	/* Now get the data */
#ifdef INDEX_DEBUG
        Tlen__ = Tlen_;
        
        call Console.string("loadData : Tarrindex ");
		call Console.decimal(Tarrindex);
		call Console.string("\n");
        
#endif
        if (SUCCESS != call Array.get(Tarrindex, Tdata, Tlen_))
{
#ifdef INDEX_DEBUG
            call Console.string("Lvl 1 ndx ldng fld\n");
            TOSH_uwait(30000L);
#endif
            post FailRespond();
}

}

    event void Array.getDone(result_t res)
{
#ifdef INDEX_DEBUG
        call Console.string("In Array.getDone : Tarrindex ");
        call Console.decimal(Tarrindex);
		call Console.string(" Tlen_ ");
		call Console.decimal(*Tlen_);
		call Console.string(" Data len:");
		call Console.decimal(*Tlen__);
		call Console.string(" indexif_id ");
		call Console.decimal(&indexif_id);
		call Console.string("\n");
		TOSH_uwait(30000L);
#endif

        unlock();
#ifdef LOCK_DEBUG
        call Console.string("Released index get lock\n");
        TOSH_uwait(30000L);
#endif

        if (!compacting)
            signal Index.getDone[indexif_id](res);
        else
			post compact_set();
}

    event void ChunkStorage.writeDone(result_t result)
{
	/* Just saved the index page */
	if (result == SUCCESS)
	{
		if(Tsave_ptr != NULL)
			memcpy(Tsave_ptr, &local[indexif_id].head, sizeof(flashptr_t));
      
#ifdef INDEX_DEBUG
            call Console.string("Saved level 2 index page : \n");
            TOSH_uwait(30000L);
#endif
	}
	else
	{
#ifdef INDEX_DEBUG
            call Console.string("ERROR ! While saving level 2 index page : \n");
            TOSH_uwait(30000L);
#endif
	}

	unlock();

	signal Index.saveDone[indexif_id](result);
}

    event void ChunkStorage.readDone(result_t result)
{
	/* Just read in the index page */
	if (result == SUCCESS)
	{
#ifdef INDEX_DEBUG
            call Console.string("Loaded level 2 index page : \n");
            TOSH_uwait(30000L);
			{
				int i;

				for (i=0; i < INDEX_ELEMENTS_PER_CHUNK; i++)
				{
					call Console.string("IDX Element:");
					call Console.decimal(i);
					call Console.string(" page: ");
					call Console.decimal(local[indexif_id].buffer.ptr[i].page);
					call Console.string(" off: ");
					call Console.decimal(local[indexif_id].buffer.ptr[i].offset);
					call Console.string("\n");
					TOSH_uwait(40000L);
				}
			}
#endif
	}
	else
	{
#ifdef INDEX_DEBUG
            call Console.string("ERROR ! While loading level 2 index page : \n");
            TOSH_uwait(30000L);
#endif
	}

	unlock();

	signal Index.loadDone[indexif_id](result);
		
}

    event void ChunkStorage.flushDone(result_t result)
{
}

    /*
     * Checkpoint / restore
	*/
    command result_t Serialize.checkpoint[uint8_t id](uint8_t *buffer, datalen_t *len)
{


	memcpy (&buffer[*len], &local[id].head, sizeof(flashptr_t));
	*len += sizeof(flashptr_t);
		
	memcpy (&buffer[*len], &local[id].headidx, sizeof(int16_t));
	*len += sizeof(int16_t);
	memcpy (&buffer[*len], &local[id].tailidx, sizeof(int16_t));
	*len += sizeof(int16_t);
		
#ifdef CHECKPOINT_DEBUG
        call Console.string("Checkpointing BundleIndex, id=");
        call Console.decimal(id);
		call Console.string(" len: ");
		call Console.decimal(*len);
		call Console.string("\n");
		call Console.string(" page: ");
		call Console.decimal(local[id].head.page);
		call Console.string(" offset: ");
		call Console.decimal(local[id].head.offset);
		call Console.string("\n");
		TOSH_uwait(30000L);
#endif
		
        return (SUCCESS);
}

    command result_t Serialize.restore[uint8_t id](uint8_t *buffer, datalen_t *len)
{

	memcpy (&local[id].head, &buffer[*len], sizeof(flashptr_t));
	*len += sizeof(flashptr_t);
		
	memcpy (&local[id].headidx, &buffer[*len], sizeof(int16_t));
	*len += sizeof(int16_t);
	memcpy (&local[id].tailidx, &buffer[*len], sizeof(int16_t));
	*len += sizeof(int16_t);
		
#ifdef CHECKPOINT_DEBUG
        call Console.string("Restoring BundleIndex, id=");
        call Console.decimal(id);
		call Console.string(" len: ");
		call Console.decimal(*len);
		call Console.string("\n");
		call Console.string(" page: ");
		call Console.decimal(local[id].head.page);
		call Console.string(" offset: ");
		call Console.decimal(local[id].head.offset);
		call Console.string("\n");
		TOSH_uwait(30000L);
#endif
		
        return (SUCCESS);
}

    task void compact_get()
{
	if (SUCCESS != call Index.get[indexif_id](compactptr, buff, &clen))
	{
#ifdef COMPACT_DEBUG
            call Console.string("ERROR ! Unable to get index data\n");
            TOSH_uwait(30000L);
#endif
	}
}

    task void compact_set()
{
	if (SUCCESS != call Index.set[indexif_id](compactptr, buff, clen, NULL))
	{
#ifdef COMPACT_DEBUG
            call Console.string("ERROR ! Unable to get index data\n");
            TOSH_uwait(30000L);
#endif
	} 
	else 
	{
#ifdef COMPACT_DEBUG
            call Console.string("Index.set -> SUCCESS\n");
            TOSH_uwait(30000L);
#endif
	}
}
	
	task void compact_finish()
{
		//compactptr++;
	compactptr = (compactptr + 1) % (INDEX_ELEMENTS_PER_CHUNK * ARRAY_ELEMENTS_PER_CHUNK);

	if (compactptr != local[indexif_id].tailidx)
	{
		post compact_get();
	} else {
		compacting = FALSE;
		signal Compaction.compactionDone[indexif_id](SUCCESS);
	}
}
	
	task void compact_stream()
{
	stream_t *str_ptr;
		

		
	if (clen < sizeof(stream_t))
	{
		post compact_finish();
		return;
	}
		
	str_ptr = (stream_t*)buff;
	if (str_ptr->tail.page == 0xFFFF && str_ptr->tail.offset == 0xFF) // check if the stream is null
	{
#ifdef COMPACT_DEBUG
            call Console.string("compact_stream: The stream is NULL\n");
            TOSH_uwait(30000L);
#endif
			post compact_finish();
			return;
	}
#ifdef COMPACT_DEBUG
            call Console.string("str_ptr->tail.page: ");
            call Console.decimal(str_ptr->tail.page);
			call Console.string("\noffset: ");
			call Console.decimal(str_ptr->tail.offset);
			call Console.string("\n");
			TOSH_uwait(30000L);
#endif
		
		//call SingleCompaction...blah
		if (FAIL == call SingleCompaction.compact(str_ptr, 0))
{
#ifdef COMPACT_DEBUG
            call Console.string("compact_stream: ERROR ! Unable to compact substream data\n");
            TOSH_uwait(30000L);
#endif
}
		else
{
#ifdef COMPACT_DEBUG
            call Console.string("call SingleCompaction.compact SUCCESS\n");
            TOSH_uwait(30000L);
#endif
		
}
}
	
	command result_t Index.init[uint8_t id]()
{
	memset (&local[id].head, 0xFF, sizeof(flashptr_t));
	memset(&local[id].buffer, 0xFF, sizeof(index_header));
	return SUCCESS;
}
	
	command result_t Index.delete[uint8_t id](unsigned int arr_index)
{
	if (lock() != SUCCESS)
	{
#ifdef LOCK_DEBUG
            call Console.string("ERROR ! Unable to acquire index delete lock\n");
            TOSH_uwait(30000L);
#endif
            return (FAIL);
	}
#ifdef LOCK_DEBUG
        call Console.string("Acquired index delete lock\n");
        TOSH_uwait(30000L);
#endif
#ifdef INDEX_DEBUG
        call Console.string("Delete index: ");
        call Console.decimal(arr_index);
		call Console.string("\n");
		TOSH_uwait(30000L);
#endif

        /* Calculate data storage location */
        Tindex = arr_index / ARRAY_ELEMENTS_PER_CHUNK;
        Tarrindex = arr_index % ARRAY_ELEMENTS_PER_CHUNK;

		indexif_id = id;
        
        /* If new page being accessed is different -> 
		save currently loaded page and load relevant page */
		if(local[id].old_indexptr != Tindex)
		{
#ifdef INDEX_DEBUG
            call Console.string("Will have to load page...\n");
            TOSH_uwait(30000L);
#endif
            state2 = state = DELETING;
            post save_l1_index();
		}
		else
		{
#ifdef INDEX_DEBUG
            call Console.string("Page already loaded. saving data...\n");
            TOSH_uwait(30000L);
#endif
       
            /* Relevant page is already loaded */
            post deleteData();
		}

		return (SUCCESS);
}
	
	
	event void SingleCompaction.compactionDone(stream_t * stream_ptr, result_t res)
{

#ifdef COMPACT_DEBUG
            call Console.string("compactionDone: ");
            call Console.decimal(res);
			call Console.string("\n");
			TOSH_uwait(30000L);
#endif

		
		if (stream_ptr == (stream_t*)buff)
{
	post compact_finish();
}
		else
{
#ifdef COMPACT_DEBUG
            call Console.string("Not Mine: \n");
			TOSH_uwait(30000L);
#endif
}
}

    command result_t Compaction.compact[uint8_t id](uint8_t againgHint)
{
	indexif_id = id;
	compacting = TRUE;
		
		//Waiting to hear from Gaurav about this
	compactptr = local[id].headidx;
        
	post compact_get();

	return (SUCCESS);
}

    event void Console.input(char *s)
{
}

    default event void Index.setDone[uint8_t id](result_t res)
{
	result_t save_res;
		/*
	int16_t nextidx;
	nextidx = (local[id].tailidx + 1) % 
	(INDEX_ELEMENTS_PER_CHUNK * ARRAY_ELEMENTS_PER_CHUNK);
					
	if (res == SUCCESS)
	{
	local[id].tailidx = nextidx;
}
		*/
		// command result_t Index.save[uint8_t id](flashptr_t *save_ptr)
		
	int16_t nextidx;
	if (res != SUCCESS)
	{
#ifdef INDEX_DEBUG
            call Console.string("Index.setDone FAILED\n");
            TOSH_uwait(30000L);
#endif
			signal BundleIndex.AppendDone[id](FAIL);
			return;
	}
	/*
	save_res = call Index.save[id](NULL);
	if (save_res != SUCCESS)
	{
#ifdef INDEX_DEBUG
		call Console.string("Index.setDone: Index.save call FAILED\n");
		TOSH_uwait(30000L);
#endif
		signal BundleIndex.AppendDone[id](FAIL);
		return;
	}
	*/
	
	nextidx = (local[id].tailidx + 1) % (INDEX_ELEMENTS_PER_CHUNK * ARRAY_ELEMENTS_PER_CHUNK);
					
	local[id].tailidx = nextidx;
	
	signal BundleIndex.AppendDone[id](SUCCESS);

}

    default event void Index.getDone[uint8_t id](result_t res)
{
#ifdef INDEX_DEBUG
			call Console.string("Index.getDone (dflt)...\n");
			call Console.string("res: ");
			call Console.decimal(res);
			call Console.string(" Blen: ");
			call Console.decimal(res);
			call Console.string("\n");
			TOSH_uwait(30000L);
			
#endif
		
		if (Blen == 0)
		{
		// if traverse idx is equal to the head, you want to move it over by one
			if (local[id].traverse_idx == local[id].headidx)
			{
				local[id].headidx = (local[id].headidx + 1) % (INDEX_ELEMENTS_PER_CHUNK * ARRAY_ELEMENTS_PER_CHUNK);
			}
					
			signal BundleIndex.GetBundleDone[id](res, FALSE);
		} 
		else 
		{
#ifdef INDEX_DEBUG
			call Console.string("Sgn BundleIndex id:");
			call Console.decimal(id);
			call Console.string("\n");
			TOSH_uwait(30000L);
#endif
			signal BundleIndex.GetBundleDone[id](res, TRUE);
		}
}
    
	default event void BundleIndex.loadDone[uint8_t id](result_t res)
{
	
}
	
    default event void Index.loadDone[uint8_t id](result_t res)
{
	signal BundleIndex.loadDone[id](res);
}

    default event void Index.saveDone[uint8_t id](result_t res)
{
	signal BundleIndex.saveDone[id](res);
	/*
	int16_t nextidx;
	if (res != SUCCESS)
	{
		signal BundleIndex.AppendDone[id](FAIL);
		return;
	}
		
	nextidx = (local[id].tailidx + 1) % 
			(INDEX_ELEMENTS_PER_CHUNK * ARRAY_ELEMENTS_PER_CHUNK);
					
	local[id].tailidx = nextidx;
	*/
	
	//signal BundleIndex.AppendDone[id](SUCCESS);
}

    default event void Compaction.compactionDone[uint8_t id](result_t res)
{}
	
	default event void Index.deleteDone[uint8_t id](result_t res)
	{
		if (res == SUCCESS && local[id].traverse_idx == local[id].headidx)
		{
			local[id].headidx = (local[id].headidx + 1) % (INDEX_ELEMENTS_PER_CHUNK * ARRAY_ELEMENTS_PER_CHUNK);
		}
		signal BundleIndex.DeleteBundleDone[id](res);
	}
	
	
/*****************************************
	BundleIndex commands
*/
	
	command result_t BundleIndex.init[uint8_t id]()
	{
		result_t ret;
		
		local[id].old_indexptr = 0xFFFF;
		local[id].headidx = 0;
		local[id].tailidx = 0;
		
		ret = call Index.init[id]();
		
		return ret;
	}
	
	command result_t BundleIndex.load[uint8_t id](bool ecc)
	{
		result_t ret;
	
		ret  = call Index.load [id] (ecc);
		
		local[id].old_indexptr = 0xFFFF;
		
#ifdef INDEX_DEBUG
            call Console.string("init: ");
            call Console.decimal(id);
			call Console.string(" ret: ");
			call Console.decimal(ret);
			call Console.string("\n");
			TOSH_uwait(30000L);
#endif
		return ret;
	}
	
	command result_t BundleIndex.BeginTraversal[uint8_t id]()
	{
		
		local[id].traverse_idx = local[id].headidx;
		if (local[id].headidx == local[id].tailidx)
		{
			//queue is empty
			return FAIL;
		}
		return SUCCESS;
	}
	
	command result_t BundleIndex.GetBundleByOffset[uint8_t id](int16_t offset, Bundle_t* bundle, bool *isvalid)
	{
		uint16_t the_idx;
		bool valid = FALSE;
		
		atomic {
			the_idx = (local[id].headidx + offset) % (INDEX_ELEMENTS_PER_CHUNK * ARRAY_ELEMENTS_PER_CHUNK);
		
			if (local[id].tailidx == local[id].headidx)
			{
				valid = FALSE;
			}
			else if (local[id].headidx < local[id].tailidx)
			{
				valid = (the_idx >= local[id].headidx && the_idx < local[id].tailidx);
			}
			else 
			{
				valid = (the_idx >= local[id].headidx || the_idx < local[id].tailidx);
			}
		}
			
		if (valid)
		{
			*isvalid = TRUE;
			return call Index.get[id](the_idx, bundle, &Blen);
		}
		bundle->turtle_num = local[id].headidx;
		bundle->bundle_num = local[id].tailidx;

		*isvalid = FALSE;
		return FAIL;
	}
	
	command result_t BundleIndex.GetBundle[uint8_t id](Bundle_t* bundle)
	{
		// make sure the Traverse Index is not equal to the tail
		if (local[id].traverse_idx != local[id].tailidx)
			return call Index.get[id](local[id].traverse_idx, bundle, &Blen);
		
		return FAIL;
	}
	
	default event void BundleIndex.GetBundleDone[uint8_t id](result_t res, bool valid)
	{}
	
	
	command result_t BundleIndex.save[uint8_t id](flashptr_t *save_ptr)
	{
		return call Index.save [id](save_ptr);
	}
	
	default event void BundleIndex.saveDone[uint8_t id](result_t res)
	{
	
	}
	
	command result_t BundleIndex.GoNext[uint8_t id]()
	{
		if (local[id].traverse_idx == local[id].tailidx)
		{
			return FAIL;
		}
		
		local[id].traverse_idx = (local[id].traverse_idx + 1) % 
				(INDEX_ELEMENTS_PER_CHUNK * ARRAY_ELEMENTS_PER_CHUNK);
		if (local[id].traverse_idx == local[id].tailidx)
		{
			return FAIL;
		} else {
			return SUCCESS;
		}
	}
	

	
	command result_t BundleIndex.DeleteBundleByOffset[uint8_t id](int16_t offset, bool *isvalid)
	{
		result_t res;
		uint16_t the_idx;
		bool valid = FALSE;
		
		atomic {
			the_idx = (local[id].headidx + offset) % (INDEX_ELEMENTS_PER_CHUNK * ARRAY_ELEMENTS_PER_CHUNK);
		
			if (local[id].tailidx != local[id].headidx)
			{
				valid = FALSE;
			}
			else if (local[id].headidx < local[id].tailidx)
			{
				valid = (the_idx >= local[id].headidx && the_idx < local[id].tailidx);
			}
			else 
			{
				valid = (the_idx >= local[id].headidx || the_idx < local[id].tailidx);
			}
		}
			
		if (valid)
		{
			*isvalid = TRUE;
			return call Index.delete[id](the_idx);
		}
		*isvalid = FALSE;
		return FAIL;
	}
	
	command result_t BundleIndex.DeleteBundle[uint8_t id]()
	{
		
		result_t res;
		
		res = call Index.delete[id](local[id].traverse_idx);
		return SUCCESS;
	}
	
	default event void BundleIndex.DeleteBundleDone[uint8_t id](result_t res)
	{}
	
	command result_t BundleIndex.AppendBundle[uint8_t id](Bundle_t* bundle)
	{
		int16_t nextidx;
		nextidx = (local[id].tailidx + 1) % 
				(INDEX_ELEMENTS_PER_CHUNK * ARRAY_ELEMENTS_PER_CHUNK);
		if (nextidx == local[id].headidx) 
		{
			//we're full
			return FAIL;
		}
		return call Index.set[id](local[id].tailidx, bundle, sizeof(Bundle_t), NULL);
	}
	default event void BundleIndex.AppendDone[uint8_t id](result_t res)
	{
	}
}
