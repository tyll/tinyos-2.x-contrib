%module SimxPushback
%{
#include <stdio.h>
#include <stdarg.h>
#include <string.h>

#include "pushback.h"
%}

%{

  static void pushback_dtor (pushback_t *pushback) {
    free(pushback->name);
    free(pushback->format);
    Py_XDECREF((PyObject*)pushback->data);
  }

  typedef struct error_handle {
    PyObject *print_exc;
  } error_handle_t;

  /*
    Load various handlers.
   */
  static error_handle_t *init_error_handling() {
    static error_handle_t eh = {NULL};
    if (NULL == eh.print_exc) {
      PyObject *traceback = PyImport_ImportModule("traceback"); 
      if (NULL != traceback) {
        eh.print_exc = PyObject_GetAttrString(traceback, "print_exception");
      }
      Py_XDECREF(traceback);
      return NULL != eh.print_exc ? &eh : NULL;
    } else {
      return &eh;
    }
  }

  static void report_error() {
    PyObject *ptype, *pvalue, *ptraceback;
    PyErr_Fetch(&ptype, &pvalue, &ptraceback);
    {
      error_handle_t *eh = init_error_handling();
      if (NULL == eh) {
        /* error with init */
        PyErr_Print();
      } else {
        PyObject *no_trace = PyObject_GetAttrString(pvalue, "no_trace");
        PyObject *limit = NULL;
        PyObject *res = NULL;
        PyObject *_traceback = NULL != ptraceback ? ptraceback : Py_None;
        if (NULL != no_trace && PyObject_IsTrue(no_trace)) {
          limit = PyLong_FromLong(0);
          _traceback = Py_None;
        }
        PyErr_Clear(); /* clear errors possibly caused by get attr */
        res = PyObject_CallFunctionObjArgs(eh->print_exc, ptype, pvalue,
                                           _traceback, limit, NULL);
        if (NULL == res) {
          fprintf(stderr, __FILE__ ": ");
          PyErr_Print();
        }
        Py_XDECREF(res);
        Py_XDECREF(limit);
        Py_XDECREF(no_trace);
      }
    }
    Py_XDECREF(ptype);
    Py_XDECREF(pvalue);
    Py_XDECREF(ptraceback);
  }

  static pushback_result_t pushback_cb(void *_pushback, va_list va) {
    pushback_t *pushback = (pushback_t*)_pushback;
    PyObject *func, *arglist;
    PyObject *result;
    pushback_result_t res;

    func = (PyObject*)pushback->data;
    arglist = Py_VaBuildValue(pushback->format, va);
    result = PyEval_CallObject(func, arglist);
    Py_DECREF(arglist);

    if (NULL == result) {
      report_error();
      PyErr_Clear();
      res.type = PUSHBACK_EXCEPTION;
    } else if (Py_None == result) {
      res.type = PUSHBACK_NONE;
    } else if (PyInt_Check(result) || PyLong_Check(result)) {
      res.type = PUSHBACK_LONG;
      res.data.l = PyLong_AsLong(result);
    } else if (PyFloat_Check(result)) {
      res.type = PUSHBACK_DOUBLE;
      res.data.d = PyFloat_AsDouble(result);
    } else {
      PyObject *str = PyObject_Str(result);
      res.type = PUSHBACK_STRING;
      res.data.h = strdup(PyString_AsString(str));
      Py_XDECREF(str);
    }
    Py_XDECREF(result);

    return res;
  }
%}

%extend Pushback {

  int addPythonPushback(PyObject *name, PyObject *format, PyObject *pyfunc) {
    pushback_t pushback;
    int err;
    char *c_name = PyString_AsString(name);
    char *c_format = PyString_AsString(format);

    if (NULL == c_name) {
      PyErr_SetString(PyExc_ValueError, "Invalid name");
      return -1;
    }
    if (NULL == c_format) {
      PyErr_SetString(PyExc_ValueError, "Invalid format");
      return -1;
    }
    if (!PyCallable_Check(pyfunc)) {
      PyErr_SetString(PyExc_TypeError, "Need a callable object");
      return -1;
    }

    pushback.name = strdup(c_name);
    pushback.format = strdup(c_format);
    pushback.fn = pushback_cb;
    pushback.data = pyfunc;
    pushback.dtor = pushback_dtor;

    Py_INCREF(pyfunc);

    err = self->addPushback(pushback, false);
    if (err) {
      // not added, clean up data ourselves
      PyErr_SetString(PyExc_RuntimeError, "Pushback not added");
      pushback.dtor(&pushback);
    }

    return err;
  }

  int removePythonPushback(PyStringObject *name) {
    char *c_name = PyString_AsString((PyObject*)name);

    if (NULL == c_name) {
      PyErr_SetString(PyExc_ValueError, "Invalid name");
      return -1;
    }

    return self->removePushback(c_name);
  }

}

%include "pushback.h"
