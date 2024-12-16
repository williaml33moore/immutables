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
class ubus_env_config extends ubus_env_config_immutable;
    typedef ubus_env_config this_type;
    typedef ubus_env_config_factory_generic#(this_type) factory_type;
    const static string type_name = "ubus_env_config";

    local bit has_bus_monitor;
    local int num_masters;
    local int num_slaves;
 
    `uvm_field_utils_begin(ubus_env_config)
        `uvm_field_int(has_bus_monitor, UVM_ALL_ON | UVM_DEC | UVM_NOPACK | UVM_NOCOPY | UVM_READONLY);
        `uvm_field_int(num_masters    , UVM_ALL_ON | UVM_DEC | UVM_NOPACK | UVM_NOCOPY | UVM_READONLY);
        `uvm_field_int(num_slaves     , UVM_ALL_ON | UVM_DEC | UVM_NOPACK | UVM_NOCOPY | UVM_READONLY);
    `uvm_field_utils_end
   
    local function new (string name="", bit has_bus_monitor=1, int num_masters=0, int num_slaves=0);
        super.new(name);
        this.set_has_bus_monitor(has_bus_monitor);
        this.set_num_masters(num_masters);
        this.set_num_slaves(num_slaves);
    endfunction : new

    static function ubus_env_config create_new (string name="", bit has_bus_monitor=1, int num_masters=0, int num_slaves=0);
        create_new = new(name, has_bus_monitor, num_masters, num_slaves);
    endfunction : create_new

    static function ubus_env_config create_copy (string name="", uvm_object rhs);
        create_copy = ubus_env_config_copier#(ubus_env_config)::create_copy(name, rhs);
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
        struct {bit has_bus_monitor; int num_masters; int num_slaves;} value = '{has_bus_monitor: get_has_bus_monitor(), num_masters: get_num_masters(), num_slaves: get_num_slaves()};
        return $sformatf("%p", value);
    endfunction

    local function void set_has_bus_monitor(bit has_bus_monitor);
        this.has_bus_monitor = has_bus_monitor;
    endfunction : set_has_bus_monitor

    local function void set_num_masters(int num_masters);
        this.num_masters = num_masters;
    endfunction : set_num_masters

    local function void set_num_slaves(int num_slaves);
        this.num_slaves = num_slaves;
    endfunction : set_num_slaves

    virtual function bit get_has_bus_monitor();
        return this.has_bus_monitor;
    endfunction : get_has_bus_monitor

    virtual function int get_num_masters();
        return this.num_masters;
    endfunction : get_num_masters

    virtual function int get_num_slaves();
        return this.num_slaves;
    endfunction : get_num_slaves
endclass : ubus_env_config
