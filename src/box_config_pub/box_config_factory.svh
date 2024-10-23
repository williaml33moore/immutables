`ifndef BOX_CONFIG_FACTORY_SVH
`define BOX_CONFIG_FACTORY_SVH

`include "uvm_macros.svh"
import uvm_pkg::*;

typedef class box_config_immutable;
typedef class box_config;

(* factory *)
class box_config_factory extends uvm_object;
    `uvm_object_utils(box_config_factory)
    function new (string name="box_config_factory");
        super.new(name);
    endfunction : new

    virtual function box_config_immutable create_new (string name="", int length=0, int width=0, int height=0);
        create_new = box_config::create_new(name, length, width, height);
    endfunction : create_new

    virtual function box_config_immutable create_copy (string name="", uvm_object rhs);
        create_copy = box_config::create_copy(name, rhs);
    endfunction : create_copy
endclass : box_config_factory

`ifndef BOX_CONFIG_SVH
`include "box_config.svh"
`endif

`ifndef BOX_CONFIG_IMMUTABLE_SVH
`include "box_config_immutable.svh"
`endif

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