`ifndef BOX_CONFIG_SVH
`define BOX_CONFIG_SVH

`include "uvm_macros.svh"
import uvm_pkg::*;

typedef class box_config_immutable;
typedef class box_config_factory_generic;
typedef class box_config_copier;

// Class extends abstract base class box_config_immutable, which extends
// abstract base class immutable_object and implements box_config_interface
// ========================================================================

class box_config extends box_config_immutable;

    // * Typedef "factory_type" associates this class with its own factory class
    typedef box_config_factory_generic#(box_config) factory_type;

    // * Local variables
    // * No const variables
    // * No rand variables
    local int length;
    local int width;
    local int height;

    // * No `uvm_object_utils()
    // * Field utils only
    // * Set field flags "UVM_NOPACK | UVM_NOCOPY | UVM_READONLY" on every variable
    `uvm_field_utils_begin(box_config)
    `uvm_field_int(length, UVM_ALL_ON | UVM_NOPACK | UVM_NOCOPY | UVM_READONLY);
    `uvm_field_int(width , UVM_ALL_ON | UVM_NOPACK | UVM_NOCOPY | UVM_READONLY);
    `uvm_field_int(height, UVM_ALL_ON | UVM_NOPACK | UVM_NOCOPY | UVM_READONLY);
    `uvm_field_utils_end

    // * Local constructor "new()"
    // * First parameter is "string name"
    // * Remaining parameters initialize all variables
    // * All parameters have default values
    local function new (string name="", int length=0, int width=0, int height=0);
        super.new(name);
        this.set_length(length);
        this.set_width(width);
        this.set_height(height);
    endfunction

    // * Static factory method
    static function box_config_immutable create_new (
            string name="", int length=0, int width=0, int height=0
        );
        box_config product = new(name, length, width, height);
        return product;
    endfunction

    // * Static copy function
    static function box_config_immutable create_copy (string name="", uvm_object rhs);
        // Non-trivial copy algorithm is provided by a parameterized helper class
        create_copy = box_config_copier#(box_config)::create_copy(name, rhs);
    endfunction

    // * Required implementation of uvm_object::get_type_name()
    virtual function string get_type_name ();
        return "box_config";
    endfunction

    // * Required implementation of uvm_object::create()
    virtual function uvm_object create (string name="");
        box_config object = new(name);
        return object;
    endfunction

    // Public getters required by box_config_interface
    // -----------------------------------------------
    virtual function int get_length ();
        return this.length;
    endfunction

    virtual function int get_width ();
        return this.width;
    endfunction

    virtual function int get_height ();
        return this.height;
    endfunction

    // Local setters
    // -------------
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

`include "box_config_copier.svh"

`ifndef BOX_CONFIG_FACTORY_GENERIC_SVH
`include "box_config_factory_generic.svh"
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
