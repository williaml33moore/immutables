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

(* factory *)
class ubus_env_config_factory_generic#(type PT=ubus_env_config) extends ubus_env_config_factory;
    `uvm_object_param_utils(ubus_env_config_factory_generic#(PT))
    function new (string name="ubus_env_config_factory_generic");
        super.new(name);
    endfunction : new

    virtual function ubus_env_config_immutable create_new (string name="", bit has_bus_monitor=0, int num_masters=0, int num_slaves=0);
        PT object = PT::create_new(name, has_bus_monitor, num_masters, num_slaves);
        return object;
    endfunction : create_new

    virtual function ubus_env_config_immutable create_copy (string name="", uvm_object rhs);
        PT object = ubus_env_config_copier#(PT)::create_copy(name, rhs);
        return object;
    endfunction : create_copy
endclass : ubus_env_config_factory_generic