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

virtual class box_config_abstract extends immutable_object implements box_config_interface;
    typedef box_config_factory_generic#(box_config_abstract) factory_type; // Sub-classes must override factory_type

    function new (string name="");
        super.new(name);
    endfunction : new

    static function box_config_abstract create_new (string name="", int length=0, int width=0, int height=0);
        `uvm_fatal("OVERRIDE", "Sub-class must override static method box_config_abstract::create_new() with custom implementation")
    endfunction : create_new

    static function box_config_abstract create_copy (string name="", uvm_object rhs);
        return box_config_copier#()::create_copy(name, rhs);
    endfunction : create_copy

    pure virtual function int get_length();
    pure virtual function int get_width();
    pure virtual function int get_height();
endclass : box_config_abstract
