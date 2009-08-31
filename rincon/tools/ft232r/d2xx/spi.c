/***********************************************************************
 * spi.c -- umph spi module
 */

#include <Python.h>

typedef unsigned char uc;
typedef unsigned long ul;

#define QSIZE 32768

typedef struct spi_state {
  uc        spien, rst, sck, mosi, miso, val;
  ul        nQ;
  uc       *Q;
  PyObject *read, *write;
} spi_state_t;

static char c;

static void _del(void *obj, void *desc) {
  if (desc == &c) {
    spi_state_t *sp = (spi_state_t *) obj;
    Py_XDECREF(sp->read);
    Py_XDECREF(sp->write);
    PyMem_Free(sp->Q);
    PyMem_Free(obj);
  }
}

static PyObject *new(void) {
  spi_state_t *sp;
  PyObject    *o;

  if ((sp = PyMem_Malloc(sizeof(spi_state_t))) == NULL)
    return PyErr_NoMemory();
  memset(sp, 0, sizeof(spi_state_t));
  if ((sp->Q = PyMem_Malloc(QSIZE * sizeof(uc))) == NULL) {
    PyMem_Free(sp);
    return PyErr_NoMemory();
  }
  if ((o = PyCObject_FromVoidPtrAndDesc(sp, &c, _del)) == NULL) {
    PyMem_Free(sp->Q);
    PyMem_Free(sp);
    return NULL;
  }
  return o;
}

static spi_state_t *get(PyObject *o) {
  if (!PyCObject_Check(o)) {
    PyErr_SetString(PyExc_TypeError, "spi_state_t expected");
    return NULL;
  }
  if (PyCObject_GetDesc(o) != &c) {
    PyErr_SetString(PyExc_TypeError, "spi_state_t expected");
    return NULL;
  }
  return (spi_state_t *) PyCObject_AsVoidPtr(o);
}

static PyObject *alloc(PyObject *self, PyObject *args) {
  PyObject    *so, *read, *write;
  spi_state_t *sp;
  int          spien, rst, sck, mosi, miso, tmp;

  if (!PyArg_ParseTuple(args, "iiiiiOO",
			&spien, &rst, &sck, &mosi, &miso,
			&read, &write))
    return NULL;
  if ((so = new()) == NULL)
    return NULL;
  if ((sp = get(so)) == NULL)
    goto bad;

  if (!PyCallable_Check(read)) {
    PyErr_SetString(PyExc_TypeError, "expected callable");
    goto bad;
  }
  Py_INCREF(read);
  sp->read = read;

  if (!PyCallable_Check(write)) {
    PyErr_SetString(PyExc_TypeError, "expected callable");
    goto bad;
  }
  Py_INCREF(write);
  sp->write = write;

  tmp = spien;
  if ((tmp & (tmp - 1)) || (tmp & ~0xff)) {
    PyErr_SetString(PyExc_ValueError, "Expected 1-bit mask");
    goto bad;
  }
  sp->spien = tmp;

  tmp = rst;
  if ((tmp & (tmp - 1)) || (tmp & ~0xff)) {
    PyErr_SetString(PyExc_ValueError, "Expected 1-bit mask");
    goto bad;
  }
  sp->rst = tmp;

  tmp = sck;
  if (!tmp || (tmp & (tmp - 1)) || (tmp & ~0xff)) {
    PyErr_SetString(PyExc_ValueError, "Expected 1-bit mask");
    goto bad;
  }
  sp->sck = tmp;

  tmp = mosi;
  if (!tmp || (tmp & (tmp - 1)) || (tmp & ~0xff)) {
    PyErr_SetString(PyExc_ValueError, "Expected 1-bit mask");
    goto bad;
  }
  sp->mosi = tmp;

  tmp = miso;
  if (!tmp || (tmp & (tmp - 1)) || (tmp & ~0xff)) {
    PyErr_SetString(PyExc_ValueError, "Expected 1-bit mask");
    goto bad;
  }
  sp->miso = tmp;

  sp->val  = 0;
  sp->nQ   = 0;

  return so;

 bad:
  Py_DECREF(so);
  return NULL;
}

PyDoc_STRVAR(dalloc,
"obj = alloc(spien, rst, sck, mosi, miso, read, write)\n"
"\n"
"create a spi object.\n");

static PyObject *spien(PyObject *self, PyObject *args) {
  PyObject    *so;
  spi_state_t *sp;
  int          val;

  if (!PyArg_ParseTuple(args, "Oi", &so, &val))
    return NULL;
  if ((sp = get(so)) == NULL)
    return NULL;
  if (val)
    sp->val |= sp->spien;
  else
    sp->val &= ~sp->spien;
  Py_INCREF(Py_None);
  return Py_None;
}

PyDoc_STRVAR(dspien,
"spien(spi, value)\n"
"\n"
"set SPI_EN value.\n");

static PyObject *rst(PyObject *self, PyObject *args) {
  PyObject    *so;
  spi_state_t *sp;
  int          val;

  if (!PyArg_ParseTuple(args, "Oi", &so, &val))
    return NULL;
  if ((sp = get(so)) == NULL)
    return NULL;
  if (val)
    sp->val |= sp->rst;
  else
    sp->val &= ~sp->rst;
  Py_INCREF(Py_None);
  return Py_None;
}

PyDoc_STRVAR(drst,
"rst(spi, value)\n"
"\n"
"set SPI_EN value.\n");

static PyObject *sck(PyObject *self, PyObject *args) {
  PyObject    *so;
  spi_state_t *sp;
  int          val;

  if (!PyArg_ParseTuple(args, "Oi", &so, &val))
    return NULL;
  if ((sp = get(so)) == NULL)
    return NULL;
  if (val)
    sp->val |= sp->sck;
  else
    sp->val &= ~sp->sck;
  Py_INCREF(Py_None);
  return Py_None;
}

PyDoc_STRVAR(dsck,
"sck(spi, value)\n"
"\n"
"set SPI_EN value.\n");

static PyObject *mosi(PyObject *self, PyObject *args) {
  PyObject    *so;
  spi_state_t *sp;
  int          val;

  if (!PyArg_ParseTuple(args, "Oi", &so, &val))
    return NULL;
  if ((sp = get(so)) == NULL)
    return NULL;
  if (val)
    sp->val |= sp->mosi;
  else
    sp->val &= ~sp->mosi;
  Py_INCREF(Py_None);
  return Py_None;
}

PyDoc_STRVAR(dmosi,
"mosi(spi, value)\n"
"\n"
"set SPI_EN value.\n");

static PyObject *miso(PyObject *self, PyObject *args) {
  PyObject    *so;
  spi_state_t *sp;
  int          val;

  if (!PyArg_ParseTuple(args, "Oi", &so, &val))
    return NULL;
  if ((sp = get(so)) == NULL)
    return NULL;
  if (val)
    sp->val |= sp->miso;
  else
    sp->val &= ~sp->miso;
  Py_INCREF(Py_None);
  return Py_None;
}

PyDoc_STRVAR(dmiso,
"miso(spi, value)\n"
"\n"
"set SPI_EN value.\n");

/*** write Q to device */
static int wr(spi_state_t *sp) {
  PyObject *rc;

  if (!sp->nQ)
    return 0;
  if ((rc = PyObject_CallFunction(sp->write, "s#", sp->Q, sp->nQ)) == NULL)
    return -1;
  Py_DECREF(rc);
  sp->nQ = 0;
  return 0;
}

/*** enqueue byte to device, possibly calling wr() */
static int enq(spi_state_t *sp, uc val, int f) {
  sp->Q[sp->nQ++] = val;
  if (f || (sp->nQ >= QSIZE))
    return wr(sp);
  return 0;
}

static PyObject *update(PyObject *self, PyObject *args) {
  PyObject    *so;
  spi_state_t *sp;
  int          f = 0;

  if (!PyArg_ParseTuple(args, "O|i", &so, &f))
    return NULL;
  if ((sp = get(so)) == NULL)
    return NULL;

  if (enq(sp, sp->val, f))
    return NULL;
  
  Py_INCREF(Py_None);
  return Py_None;
}

PyDoc_STRVAR(dupdate,
"update(spi, [doFlush=False])\n"
"\n"
"enqueue spi state, possibly flushing.\n");

static PyObject *flush(PyObject *self, PyObject *args) {
  PyObject    *so;
  spi_state_t *sp;

  if (!PyArg_ParseTuple(args, "O", &so))
    return NULL;
  if ((sp = get(so)) == NULL)
    return NULL;

  if (wr(sp))
    return NULL;

  Py_INCREF(Py_None);
  return Py_None;
}

PyDoc_STRVAR(dflush,
"flush(spi)\n"
"\n"
"flush all pending writes to the bus.\n");

/*** read device miso */
static int bit(spi_state_t *sp) {
  PyObject *rc;
  int       ret;

  /*** flush */
  if (wr(sp))
    return -1;

  /*** read bus */
  if ((rc = PyObject_CallFunction(sp->read, NULL)) == NULL)
    return -1;
  if (!PyInt_CheckExact(rc)) {
    PyErr_SetString(PyExc_TypeError, "int expected");
    Py_DECREF(rc);
    return -1;
  }
  ret = PyInt_AsLong(rc);
  Py_DECREF(rc);
  return (ret & sp->miso) ? 1 : 0;
}

static PyObject *rbit(PyObject *self, PyObject *args) {
  PyObject    *so;
  spi_state_t *sp;
  int          ret;

  if (!PyArg_ParseTuple(args, "O", &so))
    return NULL;
  if ((sp = get(so)) == NULL)
    return NULL;

  if ((ret = bit(sp)) < 0)
    return NULL;

  return PyInt_FromLong(ret);
}

PyDoc_STRVAR(drbit,
"bit = rbit(spi)\n"
"\n"
"return state of miso line.\n");

static PyObject *byte(PyObject *self, PyObject *args) {
  PyObject    *so;
  spi_state_t *sp;
  int          i, val, r = 0, ret = 0;

  if (!PyArg_ParseTuple(args, "Oi|i", &so, &val, &r))
    return NULL;
  if ((sp = get(so)) == NULL)
    return NULL;

  for (i = 0; i < 8; i++) {
    int tmp;

    /*** read bit (or not) */
    if (r) {
      if ((tmp = bit(sp)) < 0)
	return NULL;
    } else {
      tmp = 0;
    }
    ret = (ret << 1) | tmp;

    /*** set mosi from val.7 */
    if (val & 0x80) {
      sp->val |= sp->mosi;
    } else {
      sp->val &= ~sp->mosi;
    }
    val = (val & 0x7f) << 1;
    /*** sck high */
    sp->val |= sp->sck;

    /*** enqueue bus state */
    if (enq(sp, sp->val, 0))
      return NULL;

    /*** sck low */
    sp->val &= ~sp->sck;

    /*** enqueue bus state */
    if (enq(sp, sp->val, 0))
      return NULL;
  }
  /*** flush if reading */
  if (r && wr(sp))
    return NULL;

  return PyInt_FromLong(ret);
}

PyDoc_STRVAR(dbyte,
"ret = byte(spi, value, [doRead=False])\n"
"\n"
"write value to the bus and return\n"
"the value read: 0 if doRead is False;\n"
"otherwise, what the bus returns.\n");

static PyMethodDef methods[] = {
  { "alloc",  (PyCFunction) alloc,  METH_VARARGS, dalloc },
  { "spien",  (PyCFunction) spien,  METH_VARARGS, dspien },
  { "rst",    (PyCFunction) rst,    METH_VARARGS, drst },
  { "sck",    (PyCFunction) sck,    METH_VARARGS, dsck },
  { "mosi",   (PyCFunction) mosi,   METH_VARARGS, dmosi },
  { "miso",   (PyCFunction) miso,   METH_VARARGS, dmiso },
  { "update", (PyCFunction) update, METH_VARARGS, dupdate },
  { "flush",  (PyCFunction) flush,  METH_VARARGS, dflush },
  { "rbit",   (PyCFunction) rbit,   METH_VARARGS, drbit },
  { "byte",   (PyCFunction) byte,   METH_VARARGS, dbyte },
  { NULL, NULL }
};

PyDoc_STRVAR(docs,
"See the function docs for details.\n");

PyMODINIT_FUNC
init_spi(void) {
  Py_InitModule3("_spi", methods, docs);
}

/*** EOF spi.c */

