`ifndef IMMUTABLE_OBJECT_SVH
`define IMMUTABLE_OBJECT_SVH

`include "uvm_macros.svh"
import uvm_pkg::*;

virtual class immutable_object extends uvm_object;
    function new (string name = "");
        super.new(name);
    endfunction

    virtual function void set_name (string name);
        `uvm_fatal("IMMUTABLE", "set_name() operation is not allowed on this immutable object")
    endfunction

    virtual function void do_copy (uvm_object rhs);
        `uvm_fatal("IMMUTABLE", "copy()/do_copy() operation is not allowed on this immutable object")
    endfunction

    virtual function void do_unpack (uvm_packer packer);
        `uvm_fatal("IMMUTABLE", "unpack()/do_unpack() operation is not allowed on this immutable object")
    endfunction

    virtual function void set_int_local(string field_name, uvm_bitstream_t value, bit recurse=1);
        `uvm_fatal("IMMUTABLE", "set_int_local() operation is not allowed on this immutable object")
    endfunction

    virtual function void set_string_local(string field_name, string value, bit recurse=1);
        `uvm_fatal("IMMUTABLE", "set_string_local() operation is not allowed on this immutable object")
    endfunction

    virtual function void set_object_local(string field_name, uvm_object value, bit clone=1, bit recurse=1);
        `uvm_fatal("IMMUTABLE", "set_object_local() operation is not allowed on this immutable object")
    endfunction

    function void pre_randomize();
        `uvm_fatal("IMMUTABLE", "randomize()/pre_randomize() operation is not allowed on this immutable object")
    endfunction
endclass : immutable_object

`endif

/*
MIT License

Copyright (c) 2024 William L. Moore

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/
