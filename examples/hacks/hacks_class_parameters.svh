`timescale 1s/1ms

program hacks_class_parameters();

`include "uvm_macros.svh"

import uvm_pkg::*;

    virtual class box_config_immutable extends uvm_object;
        function new (string name="");
            super.new(name);
        endfunction

        pure virtual function int get_length ();
        pure virtual function int get_width ();
        pure virtual function int get_height ();
    endclass

    class box_config#(
        int LENGTH=0,
        int WIDTH=0,
        int HEIGHT=0
    ) extends box_config_immutable;

        local int length;
        local int width;
        local int height;

        `uvm_object_param_utils_begin(box_config#(LENGTH, WIDTH, HEIGHT))
        `uvm_field_int(length, UVM_ALL_ON | UVM_DEC);
        `uvm_field_int(width , UVM_ALL_ON | UVM_DEC);
        `uvm_field_int(height, UVM_ALL_ON | UVM_DEC);
        `uvm_object_utils_end

        function new (string name="");
            super.new(name);
            set_length(LENGTH);
            set_width(WIDTH);
            set_height(HEIGHT);
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
                "Pass constant values as class parameters."
                );
            begin : pass_values_as_class_parameters

                box_config_immutable box_cfg = box_config#(
                    .LENGTH (24),
                    .WIDTH (18),
                    .HEIGHT (12))::type_id::create("box_cfg");

                assert (box_cfg);
                assert (box_cfg.get_name() == "box_cfg");
                assert (box_cfg.get_length() == 24);
                assert (box_cfg.get_width() == 18);
                assert (box_cfg.get_height() == 12);
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
