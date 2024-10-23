`timescale 1s/1ms

program hacks_packer();

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

        // Constructor
        function new(string name="");
            string actual_name;
            int length, width, height;
            super.new("");
            unpack_from_string(name, actual_name, length, width, height);
            set_name(actual_name); // This immutable object must allow name changes
            set_length(length);
            set_width(width);
            set_height(height);
        endfunction

        static function string pack_into_string(string name="", int length=0, int width=0, int height=0);
            uvm_packer packer;
            byte unsigned bytes[];
            const byte ACK = 8'h06;
            const byte NAK = 8'h15;

            pack_into_string = "";
            packer = new();
            packer.use_metadata = 1;
            packer.pack_string(name);
            packer.pack_field_int(length, 32);
            packer.pack_field_int(width, 32);
            packer.pack_field_int(height, 32);
            packer.set_packed_size();
            packer.get_bytes(bytes);
            foreach (bytes[i]) begin
                if (bytes[i] == 0) begin
                    pack_into_string = {pack_into_string, NAK, 8'hff};
                end
                else begin
                    pack_into_string = {pack_into_string, ACK, bytes[i]};
                end
            end
        endfunction

        static function void unpack_from_string(input string packed_string, output string name, output int length, output int width, output int height);
            byte unsigned bytes[];
            uvm_packer packer;
            const byte ACK = 8'h06;
            const byte NAK = 8'h15;

            name = "";
            length = 0;
            width = 0;
            height = 0;
            
            bytes = new[packed_string.len() >> 1];
            foreach (bytes[i]) begin
                bytes[i] = packed_string[2*i] == ACK ? packed_string[2 * i + 1] : 8'h00;
            end
            packer = new();
            packer.use_metadata = 1;
            packer.put_bytes(bytes);
            name = packer.unpack_string();
            length = packer.unpack_field_int(32);
            width = packer.unpack_field_int(32);
            height = packer.unpack_field_int(32);
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

    class box_config_test extends uvm_test;

        `uvm_component_utils(box_config_test)

        function new(string name="box_config_test", uvm_component parent=null);

            super.new(name, parent);

        endfunction

        task run_phase(uvm_phase phase);
           
            $info(
                "Use uvm_packer to pack complex values into the name argument as a non-printable string of bytes."
                );
            begin : pass_values_through_packed_string
                box_config box_cfg;
                int length = 30;
                int width = 20;
                int height = 10;
                string packed_values;

                packed_values = box_config::pack_into_string("box_cfg", length, width, height);
                box_cfg = box_config::type_id::create(packed_values);

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
