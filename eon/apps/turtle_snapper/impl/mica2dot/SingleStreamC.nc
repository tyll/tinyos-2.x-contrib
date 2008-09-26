/*
 * file:        SingleStreamC.nc
 * description: SingleStream implementation
 *
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
 */

/*
 * SingleStream implementation
 */

includes app_header;
includes common_header;
includes sizes;
includes SingleStream;

module SingleStreamC {
    provides interface SingleStream;
    provides interface SingleCompaction;

    uses {
        interface Console;
        interface ChunkStorage;
        interface Leds;
        interface Stack;
    }
}

implementation
{
    enum{TRAVERSE, APPEND, COMPACT_TRAVERSE, COMPACT_TRAVERSE2, CCOMPACT_APPEND};
    //uint8_t streamif_id;
	
	stream_t *streamif;
    flashptr_t *Tsave_ptr;
    
	/*Need to move storage out of the component*/
	//local used to be here.....downsized
	
	
    uint8_t state;
    stream_header header;
    uint16_t compact_count = 0;

    /* Compaction */
    flashptr_t compact_ptr, ptr;
    uint8_t buff[LEN];
    datalen_t dlen;
    bool compact_first_write = TRUE;

    task void getData();
    task void writeDataStack();
    task void getDataStack();
    task void writeDataStream();

    /*
     * Stream structure:
     * 
     * a <- b <- c <- d <- tail
     * addition: a <- b <- c <- d <- e <- tail
     * deletion: not supported
     */

    command result_t SingleStream.init(stream_t *stream_ptr, bool ecc)
    {
        stream_ptr->doEcc = ecc;
        stream_ptr->traverse.page = stream_ptr->traverse.offset = 
                stream_ptr->tail.page = stream_ptr->tail.offset = ~0;
		
		stream_ptr->tail.page = 0xFFFF;
		

        return (SUCCESS);
    }

    command result_t SingleStream.append(stream_t *stream_ptr, void *data, datalen_t len, 
                                               flashptr_t *save_ptr)
    {
        /* Probably buffer some data here as well... */

        header.prev_ptr.page = stream_ptr->tail.page;
        header.prev_ptr.offset = stream_ptr->tail.offset;

        if(SUCCESS != call ChunkStorage.write(&header, 
                                              sizeof(stream_header), data, 
                                              len, stream_ptr->doEcc, 
                                              &stream_ptr->tail))
        {
#ifdef STREAM_DEBUG
            call Console.string("ERROR ! chunk write failed while trying to append to stream\n");
#endif
            //call Leds.redOn();
            return (FAIL);
        }
        else
        {
            //streamif_id = id;
            Tsave_ptr = save_ptr;
			streamif = stream_ptr;
            state = APPEND;
            
            return (SUCCESS);
        }

    }

    event void ChunkStorage.writeDone(result_t res)
    {
        if (state == APPEND)
        {
            if ((res == SUCCESS) && (Tsave_ptr != NULL))
                memcpy (Tsave_ptr, &streamif->tail, sizeof(flashptr_t));
            
            signal SingleStream.appendDone(streamif,res);
        }
        else
        {
            /* Now pop next element */
            if(res != SUCCESS)
            {
#ifdef COMPACT_DEBUG
                call Console.string("ERROR ! Stack append failed\n");
                TOSH_uwait(10000);
#endif
                //call Leds.redOn();
            }
            else
            {
                post getDataStack();
            }
        }
    }

    command result_t SingleStream.start_traversal(stream_t *stream_ptr, flashptr_t *start_ptr)
    {
        if (start_ptr == NULL)
            memcpy(&stream_ptr->traverse, &stream_ptr->tail, sizeof(flashptr_t));
        else
            memcpy(&stream_ptr->traverse, start_ptr, sizeof(flashptr_t));

        return (SUCCESS);
    }
    
    command result_t SingleStream.next(stream_t *stream_ptr, void *data, datalen_t *len)
    {
        uint8_t ecc;

		
        if((stream_ptr->traverse.page == 0xFFFF) &&
           (stream_ptr->traverse.offset == 0xFF))
        {
#ifdef STREAM_DEBUG
            call Console.string("No more data in the stream\n");
            TOSH_uwait(4000);
#endif
			*len = 1;
            return (FAIL);
        }
		

#ifdef STREAM_DEBUG
        call Console.string("Traversing stream from- page:");
        call Console.decimal(stream_ptr->traverse.page);
        call Console.string(" off:");
        call Console.decimal(stream_ptr->traverse.offset);
        call Console.string("\n");
        TOSH_uwait(4000);
#endif

        if (SUCCESS != call ChunkStorage.read(&stream_ptr->traverse, 
                                              &stream_ptr->traverse, sizeof(stream_header),
                                              data, len, stream_ptr->doEcc, &ecc))
        {
#ifdef STREAM_DEBUG
            call Console.string("ERROR ! chunk read failed while trying to get data while traversing stream\n");
#endif
            //call Leds.redOn();
			
            return (FAIL);
        }
        else
        {
            streamif = stream_ptr;
            state = TRAVERSE;
            
            return (SUCCESS);
        }
    }

    event void ChunkStorage.readDone(result_t res)
    {
		
        if (res != SUCCESS)
        {
            //call Leds.redOn();
#ifdef COMPACT_DEBUG
            call Console.string("Read call failure\n");
#endif
			
			signal SingleStream.nextDone(streamif, res);
			
			return;
        }
        else
        {
			
            if (state == TRAVERSE)
			{
				
                signal SingleStream.nextDone(streamif, res);
			}
            else if (state == COMPACT_TRAVERSE)
            {
                memcpy(&compact_ptr, &ptr, sizeof(flashptr_t));

#ifdef COMPACT_DEBUG
//                call Console.string("ReadDone ok\n");
//                TOSH_uwait(2000);
#endif

                /* Reading data headers */
                if((compact_ptr.page == 0xFFFF) &&
                   (compact_ptr.offset == 0xFF))
                {
                    /* Finished copying data pointers into the stack ->
                        Now pop it out and re-write it
                     */
#ifdef COMPACT_DEBUG
                    call Console.string("No more data to push\n");
                    TOSH_uwait(3000);
#endif
                    post getDataStack();
                }
                else
                {
                    /* write the retrieved data onto the stack */
                    post writeDataStack();
                }
            }
            else if (state == COMPACT_TRAVERSE2)
            {
                /* Reading data pointed to by the header */
#ifdef COMPACT_DEBUG
                call Console.string("Read data for element: ");
                call Console.decimal(compact_count);
                call Console.string("\n");
                TOSH_uwait(2000);
#endif
                post writeDataStream();
            }
        }
    }

    event void ChunkStorage.flushDone(result_t res)
    {}

    /*command result_t Serialize.checkpoint[uint8_t id](uint8_t *buffer, datalen_t *len)
    {
#ifdef CHECKPOINT_DEBUG
        call Console.string("Checkpointing Stream, len=");
        call Console.decimal(*len);
        call Console.string(" pg=");
        call Console.decimal(local[id].tail.page);
        call Console.string(" off=");
        call Console.decimal(local[id].tail.offset);
        call Console.string("\n");
        TOSH_uwait(50000);
#endif

        memcpy (&buffer[*len], &local[id].tail, sizeof(flashptr_t));
        *len += sizeof(flashptr_t);
        
        return (SUCCESS);
    }*/

    /*command result_t Serialize.restore[uint8_t id](uint8_t *buffer, datalen_t *len)
    {
        memcpy (&local[id].tail, &buffer[*len], sizeof(flashptr_t));
        *len += sizeof(flashptr_t);

#ifdef CHECKPOINT_DEBUG
        call Console.string("Restored Stream, id=");
        call Console.decimal(id);
        call Console.string(" pg=");
        call Console.decimal(local[id].tail.page);
        call Console.string(" off=");
        call Console.decimal(local[id].tail.offset);
        call Console.string("\n");
        TOSH_uwait(50000);
#endif
        
        return (SUCCESS);
    }*/

    default event void SingleStream.nextDone(stream_t *stream_ptr, result_t res)
    {}

    event void Console.input(char *s)
    {
    }

    task void getData()
    {
        /* Read header of the chunk */
        if (SUCCESS != call ChunkStorage.read(&compact_ptr, 
                                              &ptr, sizeof(stream_header),
                                              NULL, 0, FALSE, FALSE))
        {
#ifdef COMPACT_DEBUG
            call Console.string("ERROR ! Header read failed\n");
#endif
            //call Leds.redOn();
        }
        else
        {
            state = COMPACT_TRAVERSE;

#ifdef COMPACT_DEBUG
        call Console.string("Getting stream pointer:");
        call Console.decimal(compact_count+1);
        call Console.string("\n");
        TOSH_uwait(2000);
#endif
        }
    }

    task void writeDataStack()
    {
        if (SUCCESS != call Stack.push(&compact_ptr, sizeof(flashptr_t), NULL))
        {
#ifdef COMPACT_DEBUG
            call Console.string("ERROR ! Push onto stack failed\n");
#endif
            //call Leds.redOn();
        }
        else
        {
            compact_count++;
#ifdef COMPACT_DEBUG
            call Console.string("Pushing pointer:");
            call Console.decimal(compact_count);
            call Console.string("\n");
            TOSH_uwait(2000);
#endif
        }
    }

    event void Stack.pushDone(result_t res)
    {
        if(res != SUCCESS)
        {
#ifdef COMPACT_DEBUG
            call Console.string("ERROR ! Stack push failed\n");
#endif
            //call Leds.redOn();
        }
        else
        {
            /* Get next item of the stream */
#ifdef COMPACT_DEBUG
            call Console.string("Pushed element:");
            call Console.decimal(compact_count);
            call Console.string(" page:");
            call Console.decimal(compact_ptr.page);
            call Console.string(" off:");
            call Console.decimal(compact_ptr.offset);
            call Console.string("\n");
            TOSH_uwait(4000);
#endif

            post getData();
        }
    }

    task void getDataStack()
    {
        if (compact_count == 0)
        {
#ifdef COMPACT_DEBUG
            call Console.string("Signaling compaction done\n");
#endif
            /* XXX Check this up */
            compact_first_write = TRUE;

            signal SingleCompaction.compactionDone(streamif, SUCCESS);
        }
        else
        {
            if (SUCCESS != call Stack.pop(&compact_ptr, NULL))
            {
#ifdef COMPACT_DEBUG
                call Console.string("ERROR ! Stack pop failed\n");
#endif
                //call Leds.redOn();

            }
            else
            {
                compact_count--;
#ifdef COMPACT_DEBUG
                call Console.string("Popping stream pointer:");
                call Console.decimal(compact_count);
                call Console.string("\n");
                TOSH_uwait(2000);
#endif
            }
        }
    }

    task void getDataStack2()
    {
        /* Read the actual data */
        if (SUCCESS != call ChunkStorage.read(&compact_ptr, 
                                              &ptr, sizeof(stream_header),
                                              buff, &dlen, FALSE, FALSE))
        {
#ifdef COMPACT_DEBUG
            call Console.string("ERROR ! Data read failed\n");
#endif
            //call Leds.redOn();
        }
        else
        {
#ifdef COMPACT_DEBUG
                call Console.string("Reading element data:");
                call Console.decimal(compact_count);
                call Console.string("\n");
                TOSH_uwait(2000);
#endif
            state = COMPACT_TRAVERSE2;
        }
    }


    event void Stack.popDone(result_t res)
    {
        if(res != SUCCESS)
        {
#ifdef COMPACT_DEBUG
            call Console.string("ERROR ! Stack pop failed\n");
#endif
            //call Leds.redOn();
        }
        else
        {
            /* Now retrieve the data associated with the pointer */
#ifdef COMPACT_DEBUG
            call Console.string("Popped element:");
            call Console.decimal(compact_count);
            call Console.string(" page:");
            call Console.decimal(compact_ptr.page);
            call Console.string(" off:");
            call Console.decimal(compact_ptr.offset);
            call Console.string("\n");
            TOSH_uwait(5000);
#endif

            post getDataStack2();
        }
    }

    task void writeDataStream()
    {
#ifdef COMPACT_DEBUG
//            call Console.string("Writing data to stream\n");
//            TOSH_uwait(2000);
#endif

        if(compact_first_write == TRUE)
        {
            streamif->tail.page = ~0;
            streamif->tail.offset = ~0;
            compact_first_write = FALSE;
        }

        header.prev_ptr.page = streamif->tail.page;
        header.prev_ptr.offset = streamif->tail.offset;

        if(SUCCESS != call ChunkStorage.write(&header, sizeof(stream_header), 
                                              buff, dlen, streamif->doEcc, 
                                              &streamif->tail))
        {
#ifdef COMPACT_DEBUG
            call Console.string("ERROR ! chunk write failed while trying to append to stream\n");
#endif
            //call Leds.redOn();
        }
        else
        {
#ifdef COMPACT_DEBUG
                call Console.string("Writing new stream element:");
                call Console.decimal(compact_count);
                call Console.string("\n");
                TOSH_uwait(4000);
#endif
        }
    }

    default event void SingleStream.appendDone(stream_t *stream_ptr, result_t res)
    {
    }

    task void trivialReturn()
    {
        signal SingleCompaction.compactionDone(streamif, SUCCESS);
    }


    command result_t SingleCompaction.compact(stream_t *stream_ptr, uint8_t againgHint)
    {
#ifdef COMPACT_DEBUG
        call Console.string("Compact request on if :");
        call Console.decimal(stream_ptr);
        call Console.string("\n");
#endif

        streamif = stream_ptr;
        
        if((stream_ptr->tail.page == 0xFFFF) &&
           (stream_ptr->tail.offset == 0xFF))
        {
            /* Nothing to compact */
            post trivialReturn();
            return (SUCCESS);
        }

        /* Get start pointer */
        memcpy(&compact_ptr, &stream_ptr->tail, sizeof(flashptr_t));
        compact_count = 0;

        /* Now start the traversal */
        post writeDataStack();

        return(SUCCESS);
    }

    default event void SingleCompaction.compactionDone(stream_t * stream_ptr, result_t res)
    {}

    event void Stack.topDone(result_t res)
    {}
}
