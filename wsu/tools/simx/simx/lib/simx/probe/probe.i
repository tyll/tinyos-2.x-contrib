%module SimxProbe

#include <stdio.h>
#include <string.h>

/* Provided by Tossim via SimMoteP */
static int sim_mote_get_variable_info(int mote, char* name,
                                      void** ptr, size_t* len);

%newobject get_buffer;
%newobject get_shadow_buffer;
%newobject get_dirty_list;

%inline %{

  /*
   * Returns a Read-Write backing-buffer assocoated with the given
   * Tossim-wrapped variable name and mote.
   *
   * Some possible exceptions:
   * KeyError - Variable can't be resolved/fetched
   */
  static PyObject *get_buffer(int mote, const char *varname) {
    void *memptr = NULL;
    size_t memlen = 0;
    int error = sim_mote_get_variable_info(mote, varname, &memptr, &memlen);
    if (error) {
      PyErr_Format(PyExc_KeyError,
                   "Could not resolve variable (error=%d): %s",
                   error, varname);
      return NULL;
    } else {
      PyObject *buffer = PyBuffer_FromReadWriteMemory(memptr, memlen);
      if (NULL == buffer || PyErr_Occurred())
        return NULL;
      return buffer;
    }
  }

  /*
   * Returns a shadow-buffer of the given size. This is really just to
   * get around the python limitation of not being able to create a
   * new read-write buffer with a given size in pure Python (2.5).
   *
   * If len is zero the mote/var name is used as a lookup.
   *
   * Like variable buffers above, shadow buffers should be cached and
   * shared. THE UNDERLYING MEMORY WILL NOT BE FREED. NOT CACHING WILL
   * RESULT IN SEVERE MEMORY LEAKS.
   */
  static PyObject *get_shadow_buffer(int mote, const char *varname,
                                     size_t len) {
    if (!len) {
      void *memptr = NULL;
      int error = sim_mote_get_variable_info(mote, varname, &memptr, &len);
      if (error) {
        PyErr_Format(PyExc_KeyError,
                     "Could not resolve variable (error=%d): %s",
                     error, varname);
        return NULL;
      }
    }
    {
      PyObject *buffer = PyBuffer_New(len);
      if (NULL == buffer || PyErr_Occurred())
        return NULL;
      return buffer;
    }
  }

  /* 
     Internals used to hold/apply shadow-buffer update copies.
  */
  typedef struct _shadowcpy {
    const char *src;
    char *dst;
    size_t len;
    struct _shadowcpy *next;
  } shadowcpy_t;
  // returns new -head- or NULL
  static shadowcpy_t *shadowcpy_add(shadowcpy_t *head,
                                    const char *src, char *dst, size_t len) {
    shadowcpy_t *n = PyMem_Malloc(sizeof(shadowcpy_t));
    if (NULL == n)
      return NULL;
    n->src = src;
    n->dst = dst;
    n->len = len;
    n->next = head;
    return n;
  }
  static void shadowcpy_exec(shadowcpy_t *head) {
    for (; NULL != head; head = head->next)
      memcpy(head->dst, head->src, head->len);
  }
  static void shadowcpy_free(shadowcpy_t *head) {
    while (NULL != head) {
      shadowcpy_t *last = head;
      head = head->next;
      PyMem_Free(last);
    }
  }

  /*
   * Determine which Probe objects -may- be dirty.
   *
   * Given an iterable object containing Probe items, return a new
   * list containing the Probe items which have a shadow-buffer
   * differing from the current backing-buffer contents over the
   * region of memory used by the Probe.
   *
   * After performing the check the backing-buffer contents will be
   * copied to the shadow-buffer; that is, calling get_dirty_list
   * twice in a row should always return an empty list the 2nd time
   * IFF there were was no exception the first invocation.
   *
   * If a problem occurs an exception (normally a ValueError) is
   * raised and the shadow buffers ARE NOT updated. That is, this
   * function is atomic wrt. updating the shadow-buffers.
   */
  static PyObject *get_dirty_list(PyObject *iterable) {
    static PyObject *a_buf=NULL, *a_shadow=NULL, *a_offset=NULL, *a_size=NULL;
    PyObject *iter, *item, *list;
    shadowcpy_t *scopy = NULL;

    if (NULL == a_buf) { /* build/cache attribute accessors */
      a_buf = PyString_InternFromString("buf");
      a_shadow = PyString_InternFromString("shadow_buf");
      a_offset = PyString_InternFromString("offset");
      a_size = PyString_InternFromString("size");
    }

    iter = PyObject_GetIter(iterable);
    if (NULL == iter)
      return NULL;

    list = PyList_New(0);
    if (NULL == list) {
      Py_DECREF(iter);
      return NULL;
    }

    while ((item = PyIter_Next(iter))) {
      PyObject *buf = PyObject_GetAttr(item, a_buf);
      PyObject *shadow = PyObject_GetAttr(item, a_shadow);
      PyObject *offset = PyObject_GetAttr(item, a_offset);
      PyObject *size = PyObject_GetAttr(item, a_size);

      if (NULL==buf || NULL==shadow || NULL==offset || NULL==size) {
        PyErr_SetString(PyExc_ValueError,
                        "Probe? Missing buf, shadow_buf, offset or size");
        break;
      } else {
        const void *buf_ptr;
        void *shadow_ptr;
        Py_ssize_t buf_size, shadow_size, _offset, _size;

        if (PyObject_AsReadBuffer(buf, &buf_ptr, &buf_size)) {
          if (!PyErr_Occurred()) {
            PyErr_Format(PyExc_ValueError, "Can't get buffer for reading");
          }
          break;
        }

        if (PyObject_AsWriteBuffer(shadow, &shadow_ptr, &shadow_size)) {
          if (!PyErr_Occurred()) {
            PyErr_Format(PyExc_ValueError, "Can't get buffer for writing");
          }
          break;
        }

        if (buf_size != shadow_size) {
          PyErr_Format(PyExc_ValueError,
                       "Backing/shadow size mismatch: %zd != %zd",
                       buf_size, shadow_size);
          break;
        }

        _offset = PyInt_AsSsize_t(offset);
        _size = PyInt_AsSsize_t(size);

        if (_offset < 0 || _size < 0) { /* also catches invalid convs */
          PyErr_Format(PyExc_ValueError,
                       "Invalided offset (%zd) or size (%zd)",
                       _offset, _size);
          break;
        }

        if (_offset + _size > buf_size) {
          PyErr_Format(PyExc_ValueError,
                       "Overflow detected: %zd + %zd > %zd",
                       _offset, _size, buf_size);
          break;
        }

        /* normalize */
        buf_ptr += _offset;
        shadow_ptr += _offset;

        if (memcmp(shadow_ptr, buf_ptr, _size)) { /* buffers differ */
          /* record copy operation for later. a temp variable is used
             so that, fwiw, if an error occurs, the rest can still
             cleaned up below */
          shadowcpy_t *_c = shadowcpy_add(scopy, buf_ptr, shadow_ptr, _size);
          if (NULL == _c) {
            PyErr_NoMemory();
            break;
          }
          scopy = _c;
          /* add to "dirty" list */
          if (PyList_Append(list, item)) {
            /* oh, dear! */
            break;
          }
        }
      }

      Py_DECREF(item);
      item = NULL;
    }
    Py_XDECREF(item); /* if prematurely broken from loop */
    Py_DECREF(iter);

    if (PyErr_Occurred()) {
      Py_DECREF(list);
      list = NULL;
    } else {
      shadowcpy_exec(scopy);
    }
    shadowcpy_free(scopy);
    return list;
  }

%}
