/*
 * rr: thread-safe round robin container
 * Copyright(c) 2004 by wave++ "Yuri D'Elia" <wavexx@users.sf.net>
 * Distributed under GNU LGPL WITHOUT ANY WARRANTY.
 */

#ifndef rr_hh
#define rr_hh

// system headers
#include <pthread.h>
#include <string.h>


/*
 * Here's the general idea: we store the data in a classic round-robin buffer
 * but we support only push_back. Since we never read like a classic 'consumer'
 * we call the method copy(v) to flatten _all_ the values in a simple linear
 * buffer in at maximum two memcpy (for performance reasons the assignement
 * operator is not called). We then iterate in the linear buffer, which saves
 * us wrap-around checks.
 */
template<typename T>
  class rr
  {
  public:
    typedef ::size_t size_type;
    typedef T value_type;
    typedef T* pointer;
    typedef T& reference;
    typedef const T& const_reference;

  private:
    pthread_mutex_t mutex;
    pointer data;
    const size_type size;
    volatile size_type pos;

  public:
    explicit
    rr(size_type size)
    : size(size), pos(0)
    {
      data = new value_type[size];
      pthread_mutex_init(&mutex, NULL);
    }

    
    ~rr() throw()
    {
      pthread_mutex_destroy(&mutex);
      delete[] data;
    }


    void
    push_back(const_reference value)
    {
      pthread_mutex_lock(&mutex);
      memcpy(data + pos, &value, sizeof(value_type));
      if(++pos == size)
	pos = 0;
      pthread_mutex_unlock(&mutex);
    }


    void
    copy(pointer buf)
    {
      // try harder to reduce latency
      pthread_mutex_lock(&mutex);
      const size_type p = pos;
      const size_type res = (size - p);
      memcpy(buf, data + p, sizeof(value_type) * res);
      pthread_mutex_unlock(&mutex);
      memcpy(buf + res, data, sizeof(value_type) * p);
    }
  };

#endif
