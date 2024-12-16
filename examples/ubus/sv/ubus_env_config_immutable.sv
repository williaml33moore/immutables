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

virtual class ubus_env_config_immutable extends immutable_object implements ubus_env_config_interface;
    typedef ubus_env_config_factory_generic#(ubus_env_config_immutable) factory_type; // Sub-classes must override factory_type

    function new (string name="");
        super.new(name);
    endfunction : new

    static function ubus_env_config_immutable create_new (string name="", bit has_bus_monitor=1, int num_masters=0, int num_slaves=0);
        `uvm_fatal("OVERRIDE", "Sub-class must override static method ubus_env_config_immutable::create_new() with custom implementation")
    endfunction : create_new

    static function ubus_env_config_immutable create_copy (string name="", uvm_object rhs);
        return ubus_env_config_copier#()::create_copy(name, rhs);
    endfunction : create_copy

    pure virtual function bit get_has_bus_monitor();
    pure virtual function int get_num_masters();
    pure virtual function int get_num_slaves();
endclass : ubus_env_config_immutable
