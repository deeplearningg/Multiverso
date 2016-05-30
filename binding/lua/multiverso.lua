#!/usr/bin/env lua

mv = {}

ffi = require('ffi')
util = require('util')

ffi.cdef[[
    typedef void* TableHandler;
    void MV_Init(int* argc, char* argv[]);
    void MV_ShutDown();
    void MV_Barrier();
    int MV_NumWorkers();
    int MV_WorkerId();
    int MV_ServerId();
]]

libmv = ffi.load('libmultiverso', 'true')

mv.ArrayTableHandler = require('multiverso.ArrayTableHandler')
mv.MatrixTableHandler = require('multiverso.MatrixTableHandler')

function mv.init(args)
    args = args or {}
    argc = ffi.new("int[1]", #args)
    argv = ffi.new("char*[?]", #args)
    for i = 1, #args do
        argv[i - 1] = ffi.new("char[1]")
        ffi.copy(argv[i - 1], args[i])
    end
    libmv.MV_Init(argc, argv)
end

function mv.barrier()
    libmv.MV_Barrier()
end

function mv.shutdown()
    libmv.MV_ShutDown()
end

function mv.num_workers()
    return libmv.MV_NumWorkers()
end

function mv.worker_id()
    return libmv.MV_WorkerId()
end

function mv.server_id()
    return libmv.MV_ServerId()
end

return mv
