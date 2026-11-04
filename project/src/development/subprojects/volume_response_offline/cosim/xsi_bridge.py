"""ctypes binding to the installed Vivado 2026.1 XSI C ABI (xsi.h).

Used by run_cosim.py; no hardware/network access. XSI ports are the external
testbench boundary. MMIO is transferred over AXI handshakes in the HDL bridge.
"""
import ctypes as C
import os
from pathlib import Path


class Logic(C.Structure):
    _fields_ = [('a', C.c_uint32), ('b', C.c_uint32)]


class Setup(C.Structure):
    _fields_ = [('logFileName', C.c_char_p), ('wdbFileName', C.c_char_p), ('xsimDir', C.c_char_p)]


class Xsi:
    def __init__(self, vivado, directory, snapshot):
        self.directory = Path(directory).resolve()
        self.handles = [os.add_dll_directory(str(Path(vivado)/'lib/win64.o')),
                        os.add_dll_directory(str(Path(vivado)/'bin/unwrapped/win64.o'))]
        self.kernel = C.CDLL(str(Path(vivado)/'lib/win64.o/xv_simulator_kernel.dll'))
        self.design = C.CDLL(str(self.directory/'xsim.dir'/snapshot/'xsimk.dll'))
        self.design.xsi_open.argtypes = [C.POINTER(Setup)]
        self.design.xsi_open.restype = C.c_void_p
        types = dict(xsi_get_port_number=([C.c_void_p,C.c_char_p],C.c_int),
                     xsi_put_value=([C.c_void_p,C.c_int,C.c_void_p],None),
                     xsi_get_value=([C.c_void_p,C.c_int,C.c_void_p],C.c_int),
                     xsi_run=([C.c_void_p,C.c_int64],None),
                     xsi_get_status=([C.c_void_p],C.c_int),
                     xsi_get_error_info=([C.c_void_p],C.c_char_p),
                     xsi_get_time=([C.c_void_p],C.c_int64),
                     xsi_get_int=([C.c_void_p,C.c_int],C.c_int),
                     xsi_close=([C.c_void_p],None))
        for name,(arguments,result) in types.items():
            function=getattr(self.kernel,name);function.argtypes=arguments;function.restype=result
        self.setup=Setup(str(self.directory/'xsi.log').encode(),None,str(self.directory).encode())
        self.handle=self.design.xsi_open(C.byref(self.setup))
        assert self.handle,'XSI design open failed'
        self.ports={}
        assert self.kernel.xsi_get_int(self.handle,2)==-12,'expected 1ps simulation precision'

    def port(self,name):
        if name not in self.ports:
            self.ports[name]=self.kernel.xsi_get_port_number(self.handle,name.encode())
            assert self.ports[name]>=0,'missing XSI port '+name
        return self.ports[name]

    def put(self,name,value):
        v=Logic(value & 0xffffffff,0)
        self.kernel.xsi_put_value(self.handle,self.port(name),C.byref(v))

    def get(self,name):
        v=Logic()
        self.kernel.xsi_get_value(self.handle,self.port(name),C.byref(v))
        assert v.b==0,f'unknown bits on {name}: {v.b:#x}'
        return int(v.a)

    def run_ns(self,ns):
        self.kernel.xsi_run(self.handle,round(ns*1000))
        assert self.kernel.xsi_get_status(self.handle)==1,self.kernel.xsi_get_error_info(self.handle)

    def monotonic(self):return self.kernel.xsi_get_time(self.handle)/1e12
    def monotonic_ns(self):return self.kernel.xsi_get_time(self.handle)//1000
    def sleep(self,seconds):self.run_ns(seconds*1e9)

    def close(self):
        if self.handle:self.kernel.xsi_close(self.handle);self.handle=None
