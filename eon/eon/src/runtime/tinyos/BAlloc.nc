includes MemAlloc;

interface BAlloc
{

  command result_t allocate (HandlePtr handleptr, int16_t size);
  command int16_t free (Handle handle);
  command int16_t size (Handle handle);
  command uint16_t freeBytes ();
}
