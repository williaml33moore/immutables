`timescale 1s/1ms

program hacks_global_resource_db();

`include "uvm_macros.svh"

import uvm_pkg::*;

    class box_config extends uvm_object;

        local int length;
        local int width;
        local int height;

        `uvm_object_utils_begin(box_config)
        `uvm_field_int(length, UVM_ALL_ON | UVM_DEC);
        `uvm_field_int(width , UVM_ALL_ON | UVM_DEC);
        `uvm_field_int(height, UVM_ALL_ON | UVM_DEC);
        `uvm_object_utils_end

        function new (string name="");
            int length;
            int width;
            int height;
            bit ok;
            
            super.new(name);
            ok = uvm_resource_db#(int)::read_by_name("box_config", "length", length, this);
            assert (ok);
            ok = uvm_resource_db#(int)::read_by_name("box_config", "width", width, this);
            assert (ok);
            ok = uvm_resource_db#(int)::read_by_name("box_config", "height", height, this);
            assert (ok);
            this.set_length(length);
            this.set_width(width);
            this.set_height(height);
        endfunction

        virtual function int get_length ();
            return this.length;
        endfunction

        virtual function int get_width ();
            return this.width;
        endfunction

        virtual function int get_height ();
            return this.height;
        endfunction

        local function void set_length (int length);
            this.length = length;
        endfunction

        local function void set_width (int width);
            this.width = width;
        endfunction

        local function void set_height (int height);
            this.height = height;
        endfunction
    endclass

    class box_config_test extends uvm_test;

        `uvm_component_utils(box_config_test)

        function new(string name="box_config_test", uvm_component parent=null);

            super.new(name, parent);

        endfunction

        task run_phase(uvm_phase phase);
           
            $info(
                "Pass values to the constructor through global storage."
                );
            begin : pass_values_through_resource_db
                box_config box_cfg;

                uvm_resource_db#(int)::set("box_config", "length", 30, this);
                uvm_resource_db#(int)::set("box_config", "width", 20, this);
                uvm_resource_db#(int)::set("box_config", "height", 10, this);
                box_cfg = box_config::type_id::create("box_cfg");

                assert (box_cfg);
                assert (box_cfg.get_name() == "box_cfg");
                assert (box_cfg.get_length() == 30);
                assert (box_cfg.get_width() == 20);
                assert (box_cfg.get_height() == 10);
                `uvm_info("box_cfg", {"\n", box_cfg.sprint()}, UVM_NONE)
            end

        endtask
    endclass
    
    initial run_test("box_config_test");

endprogram


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
