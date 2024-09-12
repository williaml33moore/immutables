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

(* immutable *)
class box_config extends box_config_abstract;
    typedef box_config this_type;
    typedef box_config_factory_generic#(this_type) factory_type;
    const static string type_name = "box_config";

    local int length;
    local int width;
    local int height;
 
    `uvm_field_utils_begin(box_config)
        `uvm_field_int(length, UVM_ALL_ON | UVM_DEC | UVM_NOPACK | UVM_NOCOPY | UVM_READONLY);
        `uvm_field_int(width , UVM_ALL_ON | UVM_DEC | UVM_NOPACK | UVM_NOCOPY | UVM_READONLY);
        `uvm_field_int(height, UVM_ALL_ON | UVM_DEC | UVM_NOPACK | UVM_NOCOPY | UVM_READONLY);
    `uvm_field_utils_end
   
    local function new (string name="", int length=0, int width=0, int height=0);
        super.new(name);
        this.set_length(length);
        this.set_width(width);
        this.set_height(height);
    endfunction : new

    static function box_config create_new (string name="", int length=0, int width=0, int height=0);
        create_new = new(name, length, width, height);
    endfunction : create_new

    static function box_config create_copy (string name="", uvm_object rhs);
        create_copy = box_config_copier#(box_config)::create_copy(name, rhs);
    endfunction : create_copy

    (* override *)
    virtual function string get_type_name();
        return type_name;
    endfunction : get_type_name

    (* override *)
    virtual function uvm_object create(string name="");
        this_type object = new(name);
        return object;
    endfunction : create

    (* override *)
    virtual function string convert2string();
        struct {int length; int width; int height;} value = '{length: get_length(), width: get_width(), height: get_height()};
        return $sformatf("%p", value);
    endfunction

    local function void set_length(int length);
        this.length = length;
    endfunction : set_length

    local function void set_width(int width);
        this.width = width;
    endfunction : set_width

    local function void set_height(int height);
        this.height = height;
    endfunction : set_height

    virtual function int get_length();
        return this.length;
    endfunction : get_length

    virtual function int get_width();
        return this.width;
    endfunction : get_width

    virtual function int get_height();
        return this.height;
    endfunction : get_height
endclass : box_config
