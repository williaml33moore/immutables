`timescale 1s/1ms

program hacks_static_vars();

`include "uvm_macros.svh"

import uvm_pkg::*;

    class box_config extends uvm_object;

        static int LENGTH = 0;
        static int WIDTH = 0;
        static int HEIGHT = 0;
        local int length;
        local int width;
        local int height;

        `uvm_object_utils_begin(box_config)
        `uvm_field_int(length, UVM_ALL_ON | UVM_DEC);
        `uvm_field_int(width , UVM_ALL_ON | UVM_DEC);
        `uvm_field_int(height, UVM_ALL_ON | UVM_DEC);
        `uvm_object_utils_end

        function new (string name="", int length=LENGTH, int width=WIDTH, int height=HEIGHT);
            super.new(name);
            this.set_length(length);
            this.set_width(width);
            this.set_height(height);
        endfunction

        static function void set_static_values(int length=0, int width=0, int height=0);
            LENGTH = length;
            WIDTH = width;
            HEIGHT = height;
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
                "Pass values to the constructor through static variables."
                );
            begin : pass_values_through_static_vars
                box_config box_cfg;
                const int length = 30;
                const int width = 20;
                const int height = 10;

                box_config::set_static_values(length, width, height);
                box_cfg = box_config::type_id::create("box_cfg");

                assert (box_cfg);
                assert (box_cfg.get_name() == "box_cfg");
                assert (box_cfg.get_length() == length);
                assert (box_cfg.get_width() == width);
                assert (box_cfg.get_height() == height);
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
