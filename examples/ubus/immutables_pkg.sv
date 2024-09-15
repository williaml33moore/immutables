`ifndef IMMUTABLES_PKG_SV
`define IMMUTABLES_PKG_SV

`include "uvm_macros.svh"

`define immutable_object_utils(T,C=create_new)\
function uvm_object create (string name=""); \
    T tmp; \
    if (name=="") tmp = C(); \
    else tmp = C(name); \
    return tmp; \
endfunction\
\
const static string type_name = `"T`"; \
virtual function string get_type_name (); \
    return type_name; \
endfunction 


package immutables_pkg;

import uvm_pkg::*;

parameter IMMUTABLE_FIELD_FLAGS = UVM_NOPACK | UVM_NOCOPY | UVM_READONLY;

virtual class immutable_object extends uvm_object;
    function new (string name = "");
        super.new(name);
    endfunction

    virtual function void set_name (string name);
        `uvm_fatal("IMMUTABLE", "set_name() operation is not allowed on this immutable object")
    endfunction

    virtual function void do_copy (uvm_object rhs);
        `uvm_fatal("IMMUTABLE", "copy()/do_copy() operation is not allowed on this immutable object")
    endfunction

    virtual function void do_unpack (uvm_packer packer);
        `uvm_fatal("IMMUTABLE", "unpack()/do_unpack() operation is not allowed on this immutable object")
    endfunction

    virtual function void set_int_local(string field_name, uvm_bitstream_t value, bit recurse=1);
        `uvm_fatal("IMMUTABLE", "set_int_local() operation is not allowed on this immutable object")
    endfunction

    virtual function void set_string_local(string field_name, string value, bit recurse=1);
        `uvm_fatal("IMMUTABLE", "set_string_local() operation is not allowed on this immutable object")
    endfunction

    virtual function void set_object_local(string field_name, uvm_object value, bit clone=1, bit recurse=1);
        `uvm_fatal("IMMUTABLE", "set_object_local() operation is not allowed on this immutable object")
    endfunction

    function void pre_randomize();
        `uvm_fatal("IMMUTABLE", "randomize()/pre_randomize() operation is not allowed on this immutable object")
    endfunction
endclass : immutable_object


interface class tuple_if#(type T=int);
    pure virtual function T get(int index);
    pure virtual function int size();
    pure virtual function void to_queue(output T queue[$]);
endclass : tuple_if


virtual class abstract_tuple#(type T=int) extends immutable_object implements tuple_if#(T);
    typedef abstract_tuple#(T) this_type;
    typedef T element_type;

    protected uvm_queue#(T) q;

    `immutable_object_utils(abstract_tuple#(T))
    `uvm_field_utils_begin(abstract_tuple#(T))
    `uvm_field_object(q, UVM_ALL_ON | IMMUTABLE_FIELD_FLAGS)
    `uvm_field_utils_end

    protected function new (string name="", T elements[$]='{});
        super.new(name);
    endfunction : new

    static function this_type create_new(string name="", T elements[$]='{});
        `uvm_fatal("OVERRIDE", "Subclass must override create_new()")
    endfunction : create_new

    virtual function T get(int index);
        return q.get(index);
    endfunction : get

    virtual function int size();
        return q.size();
    endfunction : size

    virtual function void to_queue(output T queue[$]);
        queue.delete();
        for (int i = 0; i < size(); i++) queue.push_back(get(i));
    endfunction : to_queue
endclass : abstract_tuple


class scalar_tuple#(type T=int) extends abstract_tuple#(T);
    typedef scalar_tuple#(T) this_type;
    typedef T element_type;

    `immutable_object_utils(scalar_tuple#(T))
    `uvm_field_utils_begin(scalar_tuple#(T))
    `uvm_field_object(q, UVM_ALL_ON | IMMUTABLE_FIELD_FLAGS)
    `uvm_field_utils_end

    local function new (string name="", T elements[$]='{});
        super.new(name, elements);
        q = new("q");
        foreach (elements[i]) q.push_back(elements[i]);
    endfunction : new

    static function this_type create_new (string name="", T elements[$]='{});
        this_type product = new(name, elements);
        return product;
    endfunction : create_new
endclass : scalar_tuple


class object_tuple#(type T=uvm_object) extends abstract_tuple#(T);
    typedef object_tuple#(T) this_type;
    typedef T element_type;

    local uvm_queue#(T) q;

    `immutable_object_utils(object_tuple#(T))
    `uvm_field_utils_begin(object_tuple#(T))
    `uvm_field_object(q, UVM_ALL_ON | IMMUTABLE_FIELD_FLAGS)
    `uvm_field_utils_end

    local function new (string name="", T elements[$]='{});
        super.new(name);
        begin : pre_conditions
            uvm_object test_object;
            int success;
            if (elements.size() == 0) disable pre_conditions;
            success = $cast(test_object, elements[0]);
            type_check : assert (success) else `uvm_fatal("TYPE_CHECK", "element[0] is not a uvm_object")
        end
        q = new("q");
        foreach (elements[i]) q.push_back(elements[i].clone());
    endfunction : new

    static function this_type create_new (string name="", T elements[$]='{});
        this_type product = new(name, elements);
        return product;
    endfunction : create_new

    virtual function T get(int index);
        return q.get(index).clone();
    endfunction : get

    virtual function void to_queue(output T queue[$]);
        queue.delete();
        for (int i = 0; i < size(); i++) queue.push_back(get(i).clone());
    endfunction : to_queue
endclass : object_tuple

endpackage : immutables_pkg

`endif // IMMUTABLES_PKG_SV