/***********************************************************************
 * d2xx.c -- python ftdi d2xx driver interface (partial)
 */

#include <Python.h>

#include "windows.h"
#include "ftd2xx.h"

static char c;

static void _del(void *fp, void *desc) {
  if (desc == &c) {
    FT_Close(*(FT_HANDLE *) fp);
    PyMem_Free(fp);
  }
}

static PyObject *new(void) {
  FT_HANDLE *fp;
  PyObject  *o;

  if ((fp = PyMem_Malloc(sizeof(FT_HANDLE))) == NULL)
    return PyErr_NoMemory();
  if ((o = PyCObject_FromVoidPtrAndDesc(fp, &c, _del)) == NULL) {
    PyMem_Free(fp);
    return NULL;
  }
  return o;
}

static FT_HANDLE *get(PyObject *o) {
  if (!PyCObject_Check(o)) {
    PyErr_SetString(PyExc_TypeError, "FT_HANDLE expected");
    return NULL;
  }
  if (PyCObject_GetDesc(o) != &c) {
    PyErr_SetString(PyExc_TypeError, "FT_HANDLE expected");
    return NULL;
  }
  return (FT_HANDLE *) PyCObject_AsVoidPtr(o);
}

static char *fterrs[] = {
  "Success",
  "Invalid Handle",
  "Device not found",
  "Device not opened",
  "IO Error",
  "Insufficient resources",
  "Invalid parameter",
  "Invalid baud rate",
  "Device not opened for erase",
  "Device not opened for write",
  "Failed to write device",
  "EEPROM read failed",
  "EEPROM write failed",
  "EEPROM erase failed",
  "EEPROM not present",
  "EEPROM not programmed",
  "Invalid argument",
  "Not supported",
  "Other error",
  "Device list not ready",
};

static PyObject *fterr(int code) {
  PyObject *r, *c = NULL, *d = NULL;

  if ((code < 0) || (code > FT_DEVICE_LIST_NOT_READY))
    code = FT_OTHER_ERROR;
  if ((r = PyTuple_New(2)) == NULL)
    return NULL;

  if ((c = PyInt_FromLong(code)) == NULL)
    goto bad;
  PyTuple_SET_ITEM(r, 0, c); c = NULL;
  if ((d = PyString_FromString(fterrs[code])) == NULL)
      goto bad;
  PyTuple_SET_ITEM(r, 1, d);
  PyErr_SetObject(PyExc_RuntimeError, r);
  return NULL;

 bad:
  Py_XDECREF(r);
  Py_XDECREF(c);
  Py_XDECREF(d);
  return NULL;
}

static PyObject *ftopen(PyObject *self, PyObject *args) {
  FT_HANDLE *hp;
  PyObject  *ho, *dvo = NULL;
  FT_STATUS  rc;
  int        dev;
  char      *sdev;
  DWORD      dwFlags, dwFlags2;

  if (!PyArg_ParseTuple(args, "|O", &dvo))
    return NULL;
  if ((ho = new()) == NULL)
    goto bad;
  if ((hp = get(ho)) == NULL)
    goto bad;
  if ((dvo == NULL) || (PyInt_CheckExact(dvo))) {
    if (dvo == NULL)
      dev = 0;
    else
      dev = PyInt_AsLong(dvo);
    if ((rc = FT_Open(dev, hp)) != FT_OK)
      goto bonk;
  } else {
    if (!PyString_CheckExact(dvo)) {
      PyErr_SetString(PyExc_RuntimeError, "Expected string or int");
      goto bad;
    }
    if ((sdev = PyString_AsString(dvo)) == NULL)
      return NULL;
    if (*sdev == '=') {
      sdev++;
      dwFlags = dwFlags2 = FT_OPEN_BY_SERIAL_NUMBER;
    } else {
      if (*sdev == ':') {
	sdev++;
	dwFlags = dwFlags2 = FT_OPEN_BY_DESCRIPTION;
      } else {
	dwFlags  = FT_OPEN_BY_DESCRIPTION;
	dwFlags2 = FT_OPEN_BY_SERIAL_NUMBER;
      }
    }
    if ((rc = FT_OpenEx(sdev, dwFlags, hp)) != FT_OK) {
      if ((rc = FT_OpenEx(sdev, dwFlags2, hp)) != FT_OK)
	goto bonk;
    }
  }
  return ho;

 bonk:
  fterr(rc);
 bad:
  Py_XDECREF(ho);
  return NULL;
}

PyDoc_STRVAR(dopen,
"handle = open(dev=0)\n"
"\n"
"attempt to open the specified device and\n"
"return a handle to it. dev can be one of\n"
"the following:\n"
"  - a non-negative integer\n"
"  - an equals (=) followed by a serial\n"
"    number\n"
"  - a colon (:) followed by a description\n"
"  - a description or a serial number (open\n"
"    will attempt them in that order)\n");

static PyObject *ftreset(PyObject *self, PyObject *args) {
  PyObject  *ho;
  FT_HANDLE *hp;
  FT_STATUS  rc;
  int        how = 0;

  if (!PyArg_ParseTuple(args, "O|i", &ho, &how))
    return NULL;
  if ((hp = get(ho)) == NULL)
    return NULL;
  switch (how) {
    case 0: {
      rc = FT_ResetDevice(*hp); break;
    }
    case 1: {
      rc = FT_ResetPort(*hp); break;
    }
    case 2: {
      rc = FT_CyclePort(*hp); break;
    }
    default: {
      PyErr_SetString(PyExc_ValueError, "how must be 0, 1, or 2");
      return NULL;
    }
  }
  if (rc != FT_OK)
    return fterr(rc);
  Py_INCREF(Py_None);
  return Py_None;
}

PyDoc_STRVAR(dreset,
"reset(handle, [how])\n"
"\n"
"reset the device given a device handle.\n"
"\n"
"if how==0, call FT_ResetDevice (default).\n"
"if how==1, call FT_ResetPort.\n"
"if how==2, call FT_CyclePort.\n");

static PyObject *ftflow(PyObject *self, PyObject *args) {
  PyObject  *ho;
  FT_HANDLE *hp;
  FT_STATUS  rc;
  int        meth, xon = 19, xoff = 20;

  if (!PyArg_ParseTuple(args, "Oi|ii", &ho, &meth, &xon, &xoff))
    return NULL;
  if ((hp = get(ho)) == NULL)
    return NULL;
  if ((rc = FT_SetFlowControl(*hp, meth, xon, xoff)) != FT_OK)
    return fterr(rc);
  Py_INCREF(Py_None);
  return Py_None;
}

PyDoc_STRVAR(dflow,
"flow(handle, method [, xonChar, xoffChar])\n"
"\n"
"set the flow control method to one of:\n"
"  - FT_FLOW_NONE\n"
"  - FT_FLOW_RTS_CTS\n"
"  - FT_FLOW_DTR_DSR\n"
"  - FT_FLOW_XON_XOFF\n");

static PyObject *ftspeed(PyObject *self, PyObject *args) {
  PyObject  *ho;
  FT_HANDLE *hp;
  FT_STATUS  rc;
  int        b;

  if (!PyArg_ParseTuple(args, "Oi", &ho, &b))
    return NULL;
  if ((hp = get(ho)) == NULL)
    return NULL;
  if ((rc = FT_SetBaudRate(*hp, b)) != FT_OK)
    return fterr(rc);
  Py_INCREF(Py_None);
  return Py_None;
}

PyDoc_STRVAR(dspeed,
"speed(handle, rate)\n"
"\n"
"set the baud rate to one of the\n"
"FT_BAUD_xxx values.\n");

static PyObject *ftdfmt(PyObject *self, PyObject *args) {
  PyObject  *ho;
  FT_HANDLE *hp;
  FT_STATUS  rc;
  int        db, sb, p;

  if (!PyArg_ParseTuple(args, "Oiii", &ho, &db, &sb, &p))
    return NULL;
  if ((hp = get(ho)) == NULL)
    return NULL;
  if ((rc = FT_SetDataCharacteristics(*hp, db, sb, p)) != FT_OK)
    return fterr(rc);
  Py_INCREF(Py_None);
  return Py_None;
}

PyDoc_STRVAR(ddfmt,
"dfmt(handle, databits, stopbits, parity)\n"
"\n"
"set the number of data bits to one of the\n"
"FT_BITS_xxx value, the number of stop bits\n"
"to one of the FT_STOP_BITS_xxx values, and\n"
"the parity to one of the FT_PARITY_xxx\n"
"values.\n");

static PyObject *ftmode(PyObject *self, PyObject *args) {
  PyObject  *ho;
  FT_HANDLE *hp;
  FT_STATUS  rc;
  int        mask, mode;

  if (!PyArg_ParseTuple(args, "Oii", &ho, &mask, &mode))
    return NULL;
  if ((hp = get(ho)) == NULL)
    return NULL;
  if ((rc = FT_SetBitMode(*hp, mask, mode)) != FT_OK)
    return fterr(rc);
  Py_INCREF(Py_None);
  return Py_None;
}

PyDoc_STRVAR(dmode,
"mode(handle, mask, mode)\n"
"\n"
"set the bit-banging mode to one of the\n"
"FT_MODE_xxx values. mask is a bitwise\n"
"or of FT_BANG_xxx values. see the d2xx\n"
"programmer's guide for more details.\n");

static PyObject *ftwrite(PyObject *self, PyObject *args) {
  PyObject  *ho;
  FT_HANDLE *hp;
  FT_STATUS  rc;
  char      *s;
  int        l;
  DWORD      nw;

  if (!PyArg_ParseTuple(args, "Os#", &ho, &s, &l))
    return NULL;
  if ((hp = get(ho)) == NULL)
    return NULL;
  if ((rc = FT_Write(*hp, s, l, &nw)) != FT_OK)
    return fterr(rc);
  return PyInt_FromLong(nw);
}

PyDoc_STRVAR(dwrite,
"nwrite = write(handle, string)\n"
"\n"
"write the given string data to the port.\n");

static PyObject *ftread(PyObject *self, PyObject *args) {
  PyObject  *ret;
  PyObject  *ho;
  FT_HANDLE *hp;
  FT_STATUS  rc;
  char      *s;
  int        l = 1;
  DWORD      nr;

  if (!PyArg_ParseTuple(args, "O|i", &ho, &l))
    return NULL;
  if ((hp = get(ho)) == NULL)
    return NULL;
  if ((ret = PyString_FromStringAndSize(NULL, l)) == NULL)
    return NULL;
  if (PyString_AsStringAndSize(ret, &s, &l))
    goto bad;
  if ((rc = FT_Read(*hp, s, l, &nr)) != FT_OK)
    return fterr(rc);
  if (nr != l) {
    if (nr > l) {
      PyErr_SetString(PyExc_ValueError, "read() returned too many bytes?!?");
      goto bad;
    }
    if (_PyString_Resize(&ret, nr))
      return NULL;
  }
  return ret;

 bad:
  Py_XDECREF(ret);
  return NULL;
}

PyDoc_STRVAR(dread,
"string = read(handle, nbytes)\n"
"\n"
"read up to nbytes bytes from the port.\n"
"returns a string containing the bytes\n"
"actually read.\n");

static PyObject *ftmodem(PyObject *self, PyObject *args) {
  PyObject  *ho;
  FT_HANDLE *hp;
  FT_STATUS  rc;
  DWORD      ret;

  if (!PyArg_ParseTuple(args, "O", &ho))
    return NULL;
  if ((hp = get(ho)) == NULL)
    return NULL;
  if ((rc = FT_GetModemStatus(*hp, &ret)) != FT_OK)
    return fterr(rc);
  return PyInt_FromLong(ret);
}

PyDoc_STRVAR(dmodem,
"status = modem(handle)\n"
"\n"
"return a bitwise or of the FT_MODEM_xxx\n"
"values according to the modem status lines.\n");

static PyObject *ftpurge(PyObject *self, PyObject *args) {
  PyObject  *ho;
  FT_HANDLE *hp;
  int        what;
  FT_STATUS  rc;

  if (!PyArg_ParseTuple(args, "Oi", &ho, &what))
    return NULL;
  if ((hp = get(ho)) == NULL)
    return NULL;
  if ((rc = FT_Purge(*hp, what)) != FT_OK)
    return fterr(rc);
  Py_INCREF(Py_None);
  return Py_None;
}

PyDoc_STRVAR(dpurge,
"purge(what)\n"
"\n"
"purge according to any combination of\n"
"FT_PURGE_{RX, TX}.\n");

static PyObject *ftdtr(PyObject *self, PyObject *args) {
  PyObject  *ho;
  FT_HANDLE *hp;
  int        val = 1;
  FT_STATUS  rc;

  if (!PyArg_ParseTuple(args, "O|i", &ho, &val))
    return NULL;
  if ((hp = get(ho)) == NULL)
    return NULL;
  if (val)
    rc = FT_SetDtr(*hp);
  else
    rc = FT_ClrDtr(*hp);
  if (rc != FT_OK)
    return fterr(rc);
  Py_INCREF(Py_None);
  return Py_None;
}

PyDoc_STRVAR(ddtr,
"dtr(level=1)\n"
"\n"
"set the DTR line according to level.\n");

static PyObject *ftrts(PyObject *self, PyObject *args) {
  PyObject  *ho;
  FT_HANDLE *hp;
  int        val = 1;
  FT_STATUS  rc;

  if (!PyArg_ParseTuple(args, "O|i", &ho, &val))
    return NULL;
  if ((hp = get(ho)) == NULL)
    return NULL;
  if (val)
    rc = FT_SetRts(*hp);
  else
    rc = FT_ClrRts(*hp);
  if (rc != FT_OK)
    return fterr(rc);
  Py_INCREF(Py_None);
  return Py_None;
}

PyDoc_STRVAR(drts,
"rts(level=1)\n"
"\n"
"set the RTS line according to level.\n");

static PyObject *ftbrk(PyObject *self, PyObject *args) {
  PyObject  *ho;
  FT_HANDLE *hp;
  int        val;
  FT_STATUS  rc;

  if (!PyArg_ParseTuple(args, "Oi", &ho, &val))
    return NULL;
  if ((hp = get(ho)) == NULL)
    return NULL;
  if (val)
    rc = FT_SetBreakOn(*hp);
  else
    rc = FT_SetBreakOff(*hp);
  if (rc != FT_OK)
    return fterr(rc);
  Py_INCREF(Py_None);
  return Py_None;
}

PyDoc_STRVAR(dbrk,
"brk(bool)\n"
"\n"
"set/clear break condition.\n");

static PyObject *ftinq(PyObject *self, PyObject *args) {
  PyObject  *ho;
  FT_HANDLE *hp;
  FT_STATUS  rc;
  DWORD      ret, v1, v2;

  if (!PyArg_ParseTuple(args, "O", &ho))
    return NULL;
  if ((hp = get(ho)) == NULL)
    return NULL;
  if ((rc = FT_GetStatus(*hp, &ret, &v1, &v2)) != FT_OK)
    return fterr(rc);
  return PyInt_FromLong(ret);
}

PyDoc_STRVAR(dinq,
"bytes_in_rx_queue = inq(handle)\n"
"\n"
"return the number of bytes in the rx queue.\n");

static PyObject *fttimeo(PyObject *self, PyObject *args) {
  PyObject  *ho;
  FT_HANDLE *hp;
  FT_STATUS  rc;
  int        timeo;

  if (!PyArg_ParseTuple(args, "Oi", &ho, &timeo))
    return NULL;
  if ((hp = get(ho)) == NULL)
    return NULL;
  if ((rc = FT_SetTimeouts(*hp, timeo, timeo)) != FT_OK)
    return fterr(rc);
  Py_INCREF(Py_None);
  return Py_None;
}

PyDoc_STRVAR(dtimeo,
"timeo(handle, timeout)\n"
"\n"
"set rx/tx timeout in milliseconds for the port.\n");

static PyObject *devs(PyObject *self, PyObject *args) {
  FT_STATUS                 rc;
  DWORD                     numDev;
  FT_DEVICE_LIST_INFO_NODE *raw;
  PyObject                 *ret = NULL;
  int                       i;

  if ((rc = FT_CreateDeviceInfoList(&numDev)) != FT_OK)
    return fterr(rc);
  if (!numDev)
    return PyTuple_New(0);
  if ((raw = (FT_DEVICE_LIST_INFO_NODE *) PyMem_Malloc(numDev * sizeof(FT_DEVICE_LIST_INFO_NODE))) == NULL)
    return PyErr_NoMemory();
  if ((rc = FT_GetDeviceInfoList(raw, &numDev)) != FT_OK)
    goto bonk;
  if ((ret = PyTuple_New(numDev)) == NULL)
    goto bad;
  for (i = 0; i < numDev; i++) {
    PyObject *e, *n;

    if ((e = PyTuple_New(3)) == NULL)
      goto bad;
    if ((n = PyInt_FromLong(raw[i].Type)) == NULL) {
      Py_DECREF(e);
      goto bad;
    }
    PyTuple_SET_ITEM(e, 0, n);
    if ((n = PyString_FromString(raw[i].SerialNumber)) == NULL) {
      Py_DECREF(e);
      goto bad;
    }
    PyTuple_SET_ITEM(e, 1, n);
    if ((n = PyString_FromString(raw[i].Description)) == NULL) {
      Py_DECREF(e);
      goto bad;
    }
    PyTuple_SET_ITEM(e, 2, n);
    PyTuple_SET_ITEM(ret, i, e);
  }
  return ret;

 bonk:
  fterr(rc);
 bad:
  PyMem_Free(raw);
  Py_XDECREF(ret);
  return NULL;
}

PyDoc_STRVAR(ddevs,
"((serial_num, description), ...) = devs()\n"
"\n"
"return the serial number and description\n"
"of every connected device\n");

static PyObject *info(PyObject *self, PyObject *args) {
  PyObject  *ho, *tmp, *ret = NULL;
  FT_HANDLE *hp;
  FT_DEVICE  dev;
  DWORD      id;
  char       serl[16];
  char       desc[64];
  FT_STATUS  rc;

  if (!PyArg_ParseTuple(args, "O", &ho))
    return NULL;
  if ((hp = get(ho)) == NULL)
    return NULL;
  if ((rc = FT_GetDeviceInfo(*hp, &dev, &id, serl, desc, NULL)) != FT_OK) {
    fterr(rc);
    return NULL;
  }
  if ((ret = PyTuple_New(4)) == NULL)
    return NULL;
  if ((tmp = PyInt_FromLong(dev)) == NULL)
    goto bonk;
  PyTuple_SET_ITEM(ret, 0, tmp);
  if ((tmp = PyInt_FromLong(id)) == NULL)
    goto bonk;
  PyTuple_SET_ITEM(ret, 1, tmp);
  if ((tmp = PyString_FromString(serl)) == NULL)
    goto bonk;
  PyTuple_SET_ITEM(ret, 2, tmp);
  if ((tmp = PyString_FromString(desc)) == NULL)
    goto bonk;
  PyTuple_SET_ITEM(ret, 3, tmp);
  return ret;

 bonk:
  Py_DECREF(ret);
  return NULL;
}

PyDoc_STRVAR(dinfo,
"(type, id, ser#, desc) = info(handle)\n"
"\n"
"Return the device type, ID, serial number,\n"
"and description for the given handle.\n");

static PyObject *prog(PyObject *self, PyObject *args) {
  FT_PROGRAM_DATA  fd;
  char             MfgBuf[32];
  char             MfgIdBuf[16];
  char             DescBuf[64];
  char             SerlBuf[16];
  FT_HANDLE       *hp;
  FT_STATUS        rc;
  PyObject        *ho, *pd, *ko, *vo;
  Py_ssize_t       pos = 0;
  char            *ks, *vs;
  int              vi;
  FT_DEVICE        dev;
  DWORD            id;
  char             serl[16];
  char             desc[64];

  if (!PyArg_ParseTuple(args, "OO", &ho, &pd))
    return NULL;
  if ((hp = get(ho)) == NULL)
    return NULL;
  if (!PyDict_CheckExact(pd)) {
    PyErr_SetString(PyExc_TypeError, "dict expected");
    return NULL;
  }
  if (!PyDict_Size(pd)) {
    PyErr_SetString(PyExc_ValueError, "dict is empty");
    return NULL;
  }
  /*** get device info */
  if ((rc = FT_GetDeviceInfo(*hp, &dev, &id, serl, desc, NULL)) != FT_OK) {
    fterr(rc);
    return NULL;
  }
  /*** read eeprom */
  fd.Signature1     = 0x00000000;
  fd.Signature2     = 0xffffffff;
  switch (dev) {
    case FT_DEVICE_232R:  { fd.Version = 0x00000002; break; }
    case FT_DEVICE_2232C: { fd.Version = 0x00000001; break; }
    default:              { fd.Version = 0x00000000; break; }    
  }
  fd.Manufacturer   = MfgBuf;
  fd.ManufacturerId = MfgIdBuf;
  fd.Description    = DescBuf;
  fd.SerialNumber   = SerlBuf;
  if ((rc = FT_EE_Read(*hp, &fd)) != FT_OK) {
    fterr(rc);
    return NULL;
  }

  /*** update from dict */
  while (PyDict_Next(pd, &pos, &ko, &vo)) {
    int did = 0;

    if (PyString_AsStringAndSize(ko, &ks, NULL))
      return NULL;
    /*** integers */
    if (PyInt_CheckExact(vo)) {
      vi = PyInt_AsLong(vo);
      while (!did) {
	if (!strcasecmp(ks, "vendorid")) {
	  fd.VendorId = vi; did = 1; break;
	}
	if (!strcasecmp(ks, "productid")) {
	  fd.ProductId = vi; did = 1; break;
	}
	if (!strcasecmp(ks, "maxpower")) {
	  fd.MaxPower = vi; did = 1; break;
	}
	if (!strcasecmp(ks, "pnp")) {
	  fd.PnP = vi; did = 1; break;
	}
	if (!strcasecmp(ks, "selfpowered")) {
	  fd.SelfPowered = vi; did = 1; break;
	}
	if (!strcasecmp(ks, "remotewakeup")) {
	  fd.RemoteWakeup = vi; did = 1; break;
	}
	/*** FT232BM */
	if (dev == FT_DEVICE_BM) {
	  if (!strcasecmp(ks, "rev4")) {
	    fd.Rev4 = vi; did = 1; break;
	  }
	  if (!strcasecmp(ks, "pulldownenable")) {
	    fd.PullDownEnable = vi; did = 1; break;
	  }
	  if (!strcasecmp(ks, "sernumenable")) {
	    fd.SerNumEnable = vi; did = 1; break;
	  }
	  if (!strcasecmp(ks, "usbversionenable")) {
	    fd.USBVersionEnable = vi; did = 1; break;
	  }
	  if (!strcasecmp(ks, "usbversion")) {
	    fd.USBVersion = vi; did = 1; break;
	  }
	  /*** ...incomplete... */
	}
	/*** FT2232C */
	if (dev == FT_DEVICE_2232C) {
	  if (!strcasecmp(ks, "rev5")) {
	    fd.Rev5 = vi; did = 1; break;
	  }
	  if (!strcasecmp(ks, "pulldownenable5")) {
	    fd.PullDownEnable5 = vi; did = 1; break;
	  }
	  if (!strcasecmp(ks, "sernumenable5")) {
	    fd.SerNumEnable5 = vi; did = 1; break;
	  }
	  if (!strcasecmp(ks, "usbversionenable5")) {
	    fd.USBVersionEnable5 = vi; did = 1; break;
	  }
	  if (!strcasecmp(ks, "usbversion5")) {
	    fd.USBVersion5 = vi; did = 1; break;
	  }
	  /*** ...incomplete... */
	}
	/*** FT232R */
	if (dev == FT_DEVICE_232R) {
	  if (!strcasecmp(ks, "useextosc")) {
	    fd.UseExtOsc = vi; did = 1; break;
	  }
	  if (!strcasecmp(ks, "highdriveios")) {
	    fd.HighDriveIOs = vi; did = 1; break;
	  }
	  if (!strcasecmp(ks, "endpointsize")) {
	    fd.EndpointSize = vi; did = 1; break;
	  }
	  if (!strcasecmp(ks, "pulldownenabler")) {
	    fd.PullDownEnableR = vi; did = 1; break;
	  }
	  if (!strcasecmp(ks, "sernumenabler")) {
	    fd.SerNumEnableR = vi; did = 1; break;
	  }
	  if (!strcasecmp(ks, "inverttxd")) {
	    fd.InvertTXD = vi; did = 1; break;
	  }
	  if (!strcasecmp(ks, "invertrxd")) {
	    fd.InvertRXD = vi; did = 1; break;
	  }
	  if (!strcasecmp(ks, "invertrts")) {
	    fd.InvertRTS = vi; did = 1; break;
	  }
	  if (!strcasecmp(ks, "invertcts")) {
	    fd.InvertCTS = vi; did = 1; break;
	  }
	  if (!strcasecmp(ks, "invertdtr")) {
	    fd.InvertDTR = vi; did = 1; break;
	  }
	  if (!strcasecmp(ks, "invertdsr")) {
	    fd.InvertDSR = vi; did = 1; break;
	  }
	  if (!strcasecmp(ks, "invertdcd")) {
	    fd.InvertDCD = vi; did = 1; break;
	  }
	  if (!strcasecmp(ks, "invertri")) {
	    fd.InvertRI = vi; did = 1; break;
	  }
	  if (!strcasecmp(ks, "cbus0")) {
	    fd.Cbus0 = vi; did = 1; break;
	  }
	  if (!strcasecmp(ks, "cbus1")) {
	    fd.Cbus1 = vi; did = 1; break;
	  }
	  if (!strcasecmp(ks, "cbus2")) {
	    fd.Cbus2 = vi; did = 1; break;
	  }
	  if (!strcasecmp(ks, "cbus3")) {
	    fd.Cbus3 = vi; did = 1; break;
	  }
	  if (!strcasecmp(ks, "cbus4")) {
	    fd.Cbus4 = vi; did = 1; break;
	  }
	  if (!strcasecmp(ks, "risd2xx")) {
	    fd.RIsD2XX = vi; did = 1; break;
	  }
	}
	/*** nope */
	break;
      }
    }
    /*** strings */
    while (!did) {
      if (PyString_AsStringAndSize(vo, &vs, NULL))
	return NULL;
      if (!strcasecmp(ks, "manufacturer")) {
	fd.Manufacturer = vs; did = 1; break;
      }
      if (!strcasecmp(ks, "manufacturerid")) {
	fd.ManufacturerId = vs; did = 1; break;
      }
      if (!strcasecmp(ks, "description")) {
	fd.Description = vs; did = 1; break;
      }
      if (!strcasecmp(ks, "serialnumber")) {
	fd.SerialNumber = vs; did = 1; break;
      }
      break;
    }
    /*** got it? */
    if (!did) {
      PyErr_SetObject(PyExc_KeyError, ko);
      return NULL;
    }
  }

  /*** write updates to eeprom */
  if ((rc = FT_EE_Program(*hp, &fd)) != FT_OK) {
    fterr(rc);
    return NULL;
  }

  /*** done */
  Py_INCREF(Py_None);
  return Py_None;
}

PyDoc_STRVAR(dprog,
"prog(handle, dict)\n"
"\n"
"Program the EEPROM on the FTDI chip. Dict\n"
"contains key-value pairs in the FT_PROGRAM_DATA\n"
"struct (see ftd2xx.h). The keys are not\n"
"case sensitive.\n");

static PyObject *uasz(PyObject *self, PyObject *args) {
  FT_HANDLE *hp;
  PyObject  *ho;
  FT_STATUS  rc;
  DWORD      sz;

  if (!PyArg_ParseTuple(args, "O", &ho))
    return NULL;
  if ((hp = get(ho)) == NULL)
    return NULL;
  if ((rc = FT_EE_UASize(*hp, &sz)) != FT_OK) {
    fterr(rc);
    return NULL;
  }
  return PyInt_FromLong(sz);
}

PyDoc_STRVAR(duasz,
"nbytes = uasz(handle)\n"
"\n"
"Return the size of the EEPROM user area.\n");

static PyObject *uard(PyObject *self, PyObject *args) {
  FT_HANDLE *hp;
  PyObject  *ho, *ret = NULL;
  FT_STATUS  rc;
  DWORD      sz, nr;
  char      *s;

  if (!PyArg_ParseTuple(args, "O", &ho))
    return NULL;
  if ((hp = get(ho)) == NULL)
    return NULL;
  if ((rc = FT_EE_UASize(*hp, &sz)) != FT_OK) {
    fterr(rc);
    return NULL;
  }
  if (!sz)
    return PyString_FromString("");
  if ((ret = PyString_FromStringAndSize(NULL, sz)) == NULL)
    return NULL;
  if ((s = PyString_AsString(ret)) == NULL)
    goto bad;
  if ((rc = FT_EE_UARead(*hp, (unsigned char *) s, sz, &nr)) != FT_OK) {
    fterr(rc);
    goto bad;
  }
  if (nr != sz) {
    PyErr_SetString(PyExc_RuntimeError, "UARead size mismatch");
    goto bad;
  }
  return ret;

 bad:
  Py_DECREF(ret);
  return NULL;
}

PyDoc_STRVAR(duard,
"data = uard(handle)\n"
"\n"
"Return the contents of the EEPROM user area.\n");

static PyObject *uawr(PyObject *self, PyObject *args) {
  FT_HANDLE *hp;
  PyObject  *ho;
  FT_STATUS  rc;
  DWORD      sz;
  char      *s;
  int        l;

  if (!PyArg_ParseTuple(args, "Os#", &ho, &s, &l))
    return NULL;
  if ((hp = get(ho)) == NULL)
    return NULL;
  if ((rc = FT_EE_UASize(*hp, &sz)) != FT_OK) {
    fterr(rc);
    return NULL;
  }
  if (l > sz) {
    PyErr_SetString(PyExc_ValueError, "UA data too long to write");
    return NULL;
  }
  if ((rc = FT_EE_UAWrite(*hp, (unsigned char *) s, l)) != FT_OK) {
    fterr(rc);
    return NULL;
  }
  Py_INCREF(Py_None);
  return Py_None;
}

PyDoc_STRVAR(duawr,
"uawr(handle, data)\n"
"\n"
"Write data to the EEPROM user area.\n");

static PyObject *bits(PyObject *self, PyObject *args) {
  FT_HANDLE     *hp;
  PyObject      *ho;
  FT_STATUS      rc;
  unsigned char  c;

  if (!PyArg_ParseTuple(args, "O", &ho))
    return NULL;
  if ((hp = get(ho)) == NULL)
    return NULL;
  if ((rc = FT_GetBitMode(*hp, &c)) != FT_OK) {
    fterr(rc);
    return NULL;
  }
  return PyInt_FromLong(c);
}

PyDoc_STRVAR(dbits,
"value = bits(handle)\n"
"\n"
"Return the instantaneous bit values\n"
"when in a bitbang mode\n");

static PyMethodDef methods[] = {
  { "open",  (PyCFunction) ftopen,  METH_VARARGS, dopen },
  { "reset", (PyCFunction) ftreset, METH_VARARGS, dreset },
  { "flow",  (PyCFunction) ftflow,  METH_VARARGS, dflow },
  { "speed", (PyCFunction) ftspeed, METH_VARARGS, dspeed },
  { "dfmt",  (PyCFunction) ftdfmt,  METH_VARARGS, ddfmt },
  { "mode",  (PyCFunction) ftmode,  METH_VARARGS, dmode },
  { "write", (PyCFunction) ftwrite, METH_VARARGS, dwrite },
  { "read",  (PyCFunction) ftread,  METH_VARARGS, dread },
  { "modem", (PyCFunction) ftmodem, METH_VARARGS, dmodem },
  { "purge", (PyCFunction) ftpurge, METH_VARARGS, dpurge },
  { "dtr",   (PyCFunction) ftdtr,   METH_VARARGS, ddtr },
  { "rts",   (PyCFunction) ftrts,   METH_VARARGS, drts },
  { "brk",   (PyCFunction) ftbrk,   METH_VARARGS, dbrk },
  { "inq",   (PyCFunction) ftinq,   METH_VARARGS, dinq },
  { "timeo", (PyCFunction) fttimeo, METH_VARARGS, dtimeo },
  { "devs",  (PyCFunction) devs,    METH_NOARGS,  ddevs },
  { "info",  (PyCFunction) info,    METH_VARARGS, dinfo },
  { "prog",  (PyCFunction) prog,    METH_VARARGS, dprog },
  { "uasz",  (PyCFunction) uasz,    METH_VARARGS, duasz },
  { "uard",  (PyCFunction) uard,    METH_VARARGS, duard },
  { "uawr",  (PyCFunction) uawr,    METH_VARARGS, duawr },
  { "bits",  (PyCFunction) bits,    METH_VARARGS, dbits },
  { NULL, NULL },
};

PyDoc_STRVAR(docs,
"See the individual function docs\n"
"and the D2XX programmer's guide\n"
"for details\n");

PyMODINIT_FUNC
init_d2xx(void) {
  PyObject *m;

  if ((m = Py_InitModule3("_d2xx", methods, docs)) == NULL)
    return;

  /*** constants from ftd2xx.h */
#define K(s) if (PyModule_AddIntConstant(m, #s, s)) return
  K(FT_OK);
  K(FT_INVALID_HANDLE);
  K(FT_DEVICE_NOT_FOUND);
  K(FT_DEVICE_NOT_OPENED);
  K(FT_IO_ERROR);
  K(FT_INSUFFICIENT_RESOURCES);
  K(FT_INVALID_PARAMETER);
  K(FT_INVALID_BAUD_RATE);

  K(FT_DEVICE_NOT_OPENED_FOR_ERASE);
  K(FT_DEVICE_NOT_OPENED_FOR_WRITE);
  K(FT_FAILED_TO_WRITE_DEVICE);
  K(FT_EEPROM_READ_FAILED);
  K(FT_EEPROM_WRITE_FAILED);
  K(FT_EEPROM_ERASE_FAILED);
  K(FT_EEPROM_NOT_PRESENT);
  K(FT_EEPROM_NOT_PROGRAMMED);
  K(FT_INVALID_ARGS);
  K(FT_NOT_SUPPORTED);
  K(FT_OTHER_ERROR);
  K(FT_DEVICE_LIST_NOT_READY);

  K(FT_OPEN_BY_SERIAL_NUMBER);
  K(FT_OPEN_BY_DESCRIPTION);
  K(FT_OPEN_BY_LOCATION);

  K(FT_LIST_NUMBER_ONLY);
  K(FT_LIST_BY_INDEX);
  K(FT_LIST_ALL);
  K(FT_LIST_MASK);

  K(FT_BAUD_300);
  K(FT_BAUD_600);
  K(FT_BAUD_1200);
  K(FT_BAUD_2400);
  K(FT_BAUD_4800);
  K(FT_BAUD_9600);
  K(FT_BAUD_14400);
  K(FT_BAUD_19200);
  K(FT_BAUD_38400);
  K(FT_BAUD_57600);
  K(FT_BAUD_115200);
  K(FT_BAUD_230400);
  K(FT_BAUD_460800);
  K(FT_BAUD_921600);

  K(FT_BITS_8);
  K(FT_BITS_7);
  K(FT_BITS_6);
  K(FT_BITS_5);

  K(FT_STOP_BITS_1);
  K(FT_STOP_BITS_1_5);
  K(FT_STOP_BITS_2);

  K(FT_PARITY_NONE);
  K(FT_PARITY_ODD);
  K(FT_PARITY_EVEN);
  K(FT_PARITY_MARK);
  K(FT_PARITY_SPACE);

  K(FT_FLOW_NONE);
  K(FT_FLOW_RTS_CTS);
  K(FT_FLOW_DTR_DSR);
  K(FT_FLOW_XON_XOFF);

  K(FT_PURGE_RX);
  K(FT_PURGE_TX);

  K(FT_EVENT_RXCHAR);
  K(FT_EVENT_MODEM_STATUS);

  K(FT_DEFAULT_RX_TIMEOUT);
  K(FT_DEFAULT_TX_TIMEOUT);

  K(FT_DEVICE_BM);
  K(FT_DEVICE_AM);
  K(FT_DEVICE_100AX);
  K(FT_DEVICE_UNKNOWN);
  K(FT_DEVICE_2232C);
  K(FT_DEVICE_232R);

  /*** constants from the programmer's guide */
  if (PyModule_AddIntConstant(m, "FT_MODE_UART", 0x00)) return;
  if (PyModule_AddIntConstant(m, "FT_MODE_ASYNC", 0x01)) return;
  if (PyModule_AddIntConstant(m, "FT_MODE_MPSSE", 0x02)) return;
  if (PyModule_AddIntConstant(m, "FT_MODE_SYNC", 0x04)) return;
  if (PyModule_AddIntConstant(m, "FT_MODE_MHBEM", 0x08)) return;
  if (PyModule_AddIntConstant(m, "FT_MODE_FOSM", 0x10)) return;
  if (PyModule_AddIntConstant(m, "FT_MODE_CBUS", 0x20)) return;

  /*** DBn versions */
  if (PyModule_AddIntConstant(m, "FT_BANG_DB0_OUTPUT", 0x01)) return;
  if (PyModule_AddIntConstant(m, "FT_BANG_DB1_OUTPUT", 0x02)) return;
  if (PyModule_AddIntConstant(m, "FT_BANG_DB2_OUTPUT", 0x04)) return;
  if (PyModule_AddIntConstant(m, "FT_BANG_DB3_OUTPUT", 0x08)) return;
  if (PyModule_AddIntConstant(m, "FT_BANG_DB4_OUTPUT", 0x10)) return;
  if (PyModule_AddIntConstant(m, "FT_BANG_DB5_OUTPUT", 0x20)) return;
  if (PyModule_AddIntConstant(m, "FT_BANG_DB6_OUTPUT", 0x40)) return;
  if (PyModule_AddIntConstant(m, "FT_BANG_DB7_OUTPUT", 0x80)) return;

  /*** Alt names for FT232R */
  if (PyModule_AddIntConstant(m, "FT_BANG_TXD_OUTPUT", 0x01)) return;
  if (PyModule_AddIntConstant(m, "FT_BANG_RXD_OUTPUT", 0x02)) return;
  if (PyModule_AddIntConstant(m, "FT_BANG_RTS_OUTPUT", 0x04)) return;
  if (PyModule_AddIntConstant(m, "FT_BANG_CTS_OUTPUT", 0x08)) return;
  if (PyModule_AddIntConstant(m, "FT_BANG_DTR_OUTPUT", 0x10)) return;
  if (PyModule_AddIntConstant(m, "FT_BANG_DSR_OUTPUT", 0x20)) return;
  if (PyModule_AddIntConstant(m, "FT_BANG_DCD_OUTPUT", 0x40)) return;
  if (PyModule_AddIntConstant(m, "FT_BANG_RI_OUTPUT",  0x80)) return;

  /*** bitmasks for write() */
  if (PyModule_AddIntConstant(m, "FT_BANG_TXD_HIGH", 0x01)) return;
  if (PyModule_AddIntConstant(m, "FT_BANG_RXD_HIGH", 0x02)) return;
  if (PyModule_AddIntConstant(m, "FT_BANG_RTS_HIGH", 0x04)) return;
  if (PyModule_AddIntConstant(m, "FT_BANG_CTS_HIGH", 0x08)) return;
  if (PyModule_AddIntConstant(m, "FT_BANG_DTR_HIGH", 0x10)) return;
  if (PyModule_AddIntConstant(m, "FT_BANG_DSR_HIGH", 0x20)) return;
  if (PyModule_AddIntConstant(m, "FT_BANG_DCD_HIGH", 0x40)) return;
  if (PyModule_AddIntConstant(m, "FT_BANG_RI_HIGH",  0x80)) return;

  /*** CBUS defs */
  if (PyModule_AddIntConstant(m, "FT_BANG_CB0_OUTPUT", 0x10)) return;
  if (PyModule_AddIntConstant(m, "FT_BANG_CB1_OUTPUT", 0x20)) return;
  if (PyModule_AddIntConstant(m, "FT_BANG_CB2_OUTPUT", 0x40)) return;
  if (PyModule_AddIntConstant(m, "FT_BANG_CB3_OUTPUT", 0x80)) return;

  if (PyModule_AddIntConstant(m, "FT_BANG_CB0_HIGH", 0x01)) return;
  if (PyModule_AddIntConstant(m, "FT_BANG_CB1_HIGH", 0x02)) return;
  if (PyModule_AddIntConstant(m, "FT_BANG_CB2_HIGH", 0x04)) return;
  if (PyModule_AddIntConstant(m, "FT_BANG_CB3_HIGH", 0x08)) return;

  /*** modem status line values */
  if (PyModule_AddIntConstant(m, "FT_MODEM_CTS", 0x10)) return;
  if (PyModule_AddIntConstant(m, "FT_MODEM_DSR", 0x20)) return;
  if (PyModule_AddIntConstant(m, "FT_MODEM_RI",  0x40)) return;
  if (PyModule_AddIntConstant(m, "FT_MODEM_DCD", 0x80)) return;
}

/*** EOF d2xx.c */

