`timescale 1s/1ms

program hacks_component_parent();

`include "uvm_macros.svh"

import uvm_pkg::*;

    interface class box_config_initializer;
        pure virtual function uvm_component get_parent ();
        pure virtual function int get_length ();
        pure virtual function int get_width ();
        pure virtual function int get_height ();
    endclass

    class box_config extends uvm_component;

        local int length;
        local int width;
        local int height;

        `uvm_component_utils_begin(box_config)
        `uvm_field_int(length, UVM_ALL_ON | UVM_DEC);
        `uvm_field_int(width , UVM_ALL_ON | UVM_DEC);
        `uvm_field_int(height, UVM_ALL_ON | UVM_DEC);
        `uvm_component_utils_end

        // Constructor
        function new(string name="", uvm_component parent=null);
            box_config_initializer initializer;
            bit ok;

            super.new(name, parent);
            if (parent != null) begin
                ok = $cast(initializer, parent);
                assert (ok) else `uvm_fatal("TYPE_ERR", "parent is not an initializer")
                set_length(initializer.get_length());
                set_width(initializer.get_width());
                set_height(initializer.get_height());
            end
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

    typedef box_config box_config_immutable;

    class box_config_test extends uvm_test implements box_config_initializer;

        `uvm_component_utils(box_config_test)

        function new(string name="box_config_test", uvm_component parent=null);

            super.new(name, parent);

        endfunction

        virtual function uvm_component get_parent ();
            return this;
        endfunction

        virtual function int get_length ();
            return 30;
        endfunction

        virtual function int get_width ();
            return 20;
        endfunction

        virtual function int get_height ();
            return 10;
        endfunction

        virtual function void build_phase(uvm_phase phase);
           
            $info(
                "Pass values through the uvm_component constructor parent argument."
                );
            begin : pass_values_through_component_parent

                box_config box_cfg = box_config::type_id::create("box_cfg", this);

                assert (box_cfg);
                assert (box_cfg.get_name() == "box_cfg");
                assert (box_cfg.get_length() == 30);
                assert (box_cfg.get_width() == 20);
                assert (box_cfg.get_height() == 10);
                `uvm_info("box_cfg", {"\n", box_cfg.sprint()}, UVM_NONE)
            end

        endfunction
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
