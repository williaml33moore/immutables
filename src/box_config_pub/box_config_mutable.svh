`ifndef BOX_CONFIG_MUTABLE_SVH
`define BOX_CONFIG_MUTABLE_SVH

`include "uvm_macros.svh"
import uvm_pkg::*;

`include "box_config_interface.svh"

class box_config_mutable extends uvm_object implements box_config_interface;
    typedef box_config_mutable this_type;

    rand int length;
    rand int width;
    rand int height;

    constraint nonnegative_c {length >= 0; width >= 0; height >= 0;}
 
    `uvm_object_utils_begin(box_config_mutable)
        `uvm_field_int(length, UVM_ALL_ON | UVM_DEC)
        `uvm_field_int(width , UVM_ALL_ON | UVM_DEC)
        `uvm_field_int(height, UVM_ALL_ON | UVM_DEC)
    `uvm_object_utils_end

    function new (string name="", int length=0, int width=0, int height=0);
        super.new(name);
        this.set_length(length);
        this.set_width(width);
        this.set_height(height);
    endfunction : new

    (* override *)
    virtual function string convert2string();
        struct {int length; int width; int height;} value = '{length: get_length(), width: get_width(), height: get_height()};
        return $sformatf("%p", value);
    endfunction

    (* override *)
    virtual function void do_copy (uvm_object rhs);
        box_config_interface rhs_;
        int success;
        super.do_copy(rhs);
        success = $cast(rhs_, rhs);
        assert (success);
        set_length(rhs_.get_length());
        set_width(rhs_.get_width());
        set_height(rhs_.get_height());
    endfunction : do_copy

    virtual function void set_length (int length);
        this.length = length;
    endfunction : set_length

    virtual function void set_width (int width);
        this.width = width;
    endfunction : set_width

    virtual function void set_height (int height);
        this.height = height;
    endfunction : set_height

    virtual function int get_length ();
        return this.length;
    endfunction : get_length

    virtual function int get_width ();
        return this.width;
    endfunction : get_width

    virtual function int get_height ();
        return this.height;
    endfunction : get_height
endclass : box_config_mutable

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