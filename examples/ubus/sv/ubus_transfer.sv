//----------------------------------------------------------------------
//   Copyright 2007-2010 Mentor Graphics Corporation
//   Copyright 2007-2010 Cadence Design Systems, Inc.
//   Copyright 2010 Synopsys, Inc.
//   All Rights Reserved Worldwide
//
//   Licensed under the Apache License, Version 2.0 (the
//   "License"); you may not use this file except in
//   compliance with the License.  You may obtain a copy of
//   the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in
//   writing, software distributed under the License is
//   distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
//   CONDITIONS OF ANY KIND, either express or implied.  See
//   the License for the specific language governing
//   permissions and limitations under the License.
//----------------------------------------------------------------------

//------------------------------------------------------------------------------
//
// ubus transfer enums, parameters, and events
//
//------------------------------------------------------------------------------

typedef enum { NOP,
               READ,
               WRITE
             } ubus_read_write_enum;

//------------------------------------------------------------------------------
//
// CLASS: ubus_transfer
//
//------------------------------------------------------------------------------

interface class ubus_req_if;
  pure virtual function bit[15:0] addr();
  pure virtual function ubus_read_write_enum read_write();
  pure virtual function int unsigned size();
  pure virtual function immutables_pkg::scalar_tuple#(bit[7:0]) data();
  pure virtual function immutables_pkg::scalar_tuple#(bit[3:0]) wait_state();
  pure virtual function int unsigned error_pos();
  pure virtual function int unsigned transmit_delay();
endclass : ubus_req_if

interface class ubus_rsp_if;
  pure virtual function immutables_pkg::scalar_tuple#(bit[7:0]) data();
endclass : ubus_rsp_if

typedef class rand_ubus_req;
typedef class ubus_req;
typedef class rand_ubus_rsp;
typedef class ubus_rsp;

class ubus_transfer extends uvm_sequence_item;                                  

  rand rand_ubus_req request_constraints;
  local ubus_req     request;
  rand rand_ubus_rsp response_constraints;
  local ubus_rsp     response;
  string             master = "";
  string             slave = "";

  `uvm_object_utils_begin(ubus_transfer)
    `uvm_field_object (request, UVM_DEFAULT)
    `uvm_field_object (response, UVM_DEFAULT)
  `uvm_object_utils_end

  // new - constructor
  function new (string name = "ubus_transfer_inst");
    super.new(name);
    request_constraints = null;
    request = null;
    response_constraints = null;
    response = null;
  endfunction : new

  function void set_request(ubus_req_if request);
    uvm_object object;
    ubus_req immutable_req;
    int success;

    // It's fine if it's null.
    if (request == null) begin
      this.request = null;
      return;
    end

    // Make sure it's a uvm_object.
    success = $cast(object, request);
    type_check_object : assert (success) else
      `uvm_fatal("TYPE_CHECK", "request needs to be a subclass of uvm_object")

    // If it's already an immutable ubus_req...great!
    success = $cast(immutable_req, object);
    if (success) begin
      // It's immutable; no need to copy it. We can use it as-is.
      this.request = immutable_req;
      return;
    end

    // Otherwise make and keep an immutable copy since we can't be sure it's immutable.
    success = $cast(this.request, ubus_req::create_copy("request", object));
    type_check_copy : assert (success) else
      `uvm_fatal("TYPE_CHECK", "Failed to cast ubus_req copy")
  endfunction : set_request

  function ubus_req get_request();
    return this.request;
  endfunction : get_request

  function void set_response(ubus_rsp_if response);
    uvm_object object;
    ubus_rsp immutable_rsp;
    int success;

    // It's fine if it's null.
    if (response == null) begin
      this.response = null;
      return;
    end

    // Make sure it's a uvm_object.
    success = $cast(object, response);
    type_check_object : assert (success) else
      `uvm_fatal("TYPE_CHECK", "response needs to be a subclass of uvm_object")

    // If it's already an immutable ubus_rsp...great!
    success = $cast(immutable_rsp, object);
    if (success) begin
      // It's immutable; no need to copy it. We can use it as-is.
      this.response = immutable_rsp;
      return;
    end

    // Otherwise make and keep an immutable copy since we can't be sure it's immutable.
    success = $cast(this.response, ubus_rsp::create_copy("response", object));
    type_check_copy : assert (success) else
      `uvm_fatal("TYPE_CHECK", "Failed to cast ubus_rsp copy")
  endfunction : set_response

  function ubus_rsp get_response();
    return this.response;
  endfunction : get_response

  function void pre_randomize();
    if (request_constraints == null) request_constraints = rand_ubus_req::type_id::create("request_constraints");
    if (response_constraints == null) response_constraints = rand_ubus_rsp::type_id::create("response_constraints");
  endfunction : pre_randomize

  function void post_randomize();
    int success;

    success = $cast(this.request, ubus_req::create_copy("request", request_constraints));
    type_check_req : assert (success) else
      `uvm_fatal("TYPE_CHECK", "Failed to cast ubus_req copy")

    success = $cast(this.response, ubus_rsp::create_copy("response", response_constraints));
    type_check_rsp : assert (success) else
      `uvm_fatal("TYPE_CHECK", "Failed to cast ubus_rsp copy")
  endfunction : post_randomize
endclass : ubus_transfer


class rand_ubus_req extends uvm_object implements ubus_req_if;

  typedef bit[7:0] data_t;
  typedef bit[3:0] wait_state_t;

  rand bit [15:0]           addr$;
  rand ubus_read_write_enum read_write$;
  rand int unsigned         size$;
  rand data_t               data$[];
  rand wait_state_t         wait_state$[];
  rand int unsigned         error_pos$;
  rand int unsigned         transmit_delay$ = 0;

  constraint c_read_write {
    read_write$ inside { READ, WRITE };
  }
  constraint c_size {
    size$ inside {1,2,4,8};
  }
  constraint c_data_wait_size {
    data$.size() == size$;
    wait_state$.size() == size$;
  }
  constraint c_transmit_delay { 
    transmit_delay$ <= 10 ; 
  }

  `uvm_object_utils_begin(rand_ubus_req)
    `uvm_field_int      (addr$,           UVM_DEFAULT)
    `uvm_field_enum     (ubus_read_write_enum, read_write$, UVM_DEFAULT)
    `uvm_field_int      (size$,           UVM_DEFAULT)
    `uvm_field_array_int(data$,           UVM_DEFAULT)
    `uvm_field_array_int(wait_state$,     UVM_DEFAULT)
    `uvm_field_int      (error_pos$,      UVM_DEFAULT)
    `uvm_field_int      (transmit_delay$, UVM_DEFAULT)
  `uvm_object_utils_end

  // new - constructor
  function new (string name = "rand_ubus_req");
    super.new(name);
  endfunction : new

  virtual function bit[15:0] addr();
    return this.addr$;
  endfunction : addr

  virtual function ubus_read_write_enum read_write();
    return this.read_write$;
  endfunction : read_write

  virtual function int unsigned size();
    return this.size$;
  endfunction : size

  virtual function immutables_pkg::scalar_tuple#(data_t) data();
    immutables_pkg::scalar_tuple#(data_t) data_tuple;
    data_tuple = immutables_pkg::scalar_tuple#(data_t)::create_new("data", this.data$);
    return data_tuple;
  endfunction : data

  virtual function immutables_pkg::scalar_tuple#(wait_state_t) wait_state();
    immutables_pkg::scalar_tuple#(wait_state_t) wait_state_tuple;
    wait_state_tuple = immutables_pkg::scalar_tuple#(wait_state_t)::create_new("wait_state", this.wait_state$);
    return wait_state_tuple;
  endfunction : wait_state

  virtual function int unsigned error_pos();
    return this.error_pos$;
  endfunction : error_pos

  virtual function int unsigned transmit_delay();
    return this.transmit_delay$;
  endfunction : transmit_delay

  virtual function void do_copy (uvm_object rhs);
    ubus_req_if rhs_;
    super.do_copy(rhs);
    $cast(rhs_, rhs);
    this.addr$ = rhs_.addr();
    this.read_write$ = rhs_.read_write();
    this.size$ = rhs_.size();
    rhs_.data().to_queue(this.data$);
    rhs_.wait_state().to_queue(this.wait_state$);
    this.error_pos$ = rhs_.error_pos();
    this.transmit_delay$ = rhs_.transmit_delay;
  endfunction : do_copy

endclass : rand_ubus_req


class ubus_req extends immutables_pkg::immutable_object implements ubus_req_if;

  typedef bit[7:0] data_t;
  typedef bit[3:0] wait_state_t;

  local rand_ubus_req values;
  local immutables_pkg::scalar_tuple#(data_t) data_tuple;
  local immutables_pkg::scalar_tuple#(wait_state_t) wait_state_tuple;

  `immutable_object_utils(ubus_req)
  `uvm_field_utils_begin(ubus_req)
    `uvm_field_object (values, UVM_DEFAULT | immutables_pkg::IMMUTABLE_FIELD_FLAGS)
  `uvm_field_utils_end

  local function new (string name = "ubus_req",
      bit [15:0]           addr=0,
      ubus_read_write_enum read_write=NOP,
      int unsigned         size=0,
      data_t               data[$]='{},
      wait_state_t         wait_state[$]='{},
      int unsigned         error_pos=0,
      int unsigned         transmit_delay=0
    );
    super.new(name);
    values = rand_ubus_req::type_id::create("values");
    values.addr$ = addr;
    values.read_write$ = read_write;
    values.size$ = size;
    values.data$ = new[data.size()](data);
    data_tuple = values.data();
    values.wait_state$ = new[wait_state.size()](wait_state);
    wait_state_tuple = values.wait_state();
    values.error_pos$ = error_pos;
    values.transmit_delay$ = transmit_delay;
  endfunction : new

  static function ubus_req create_new (string name = "ubus_req",
      bit [15:0]           addr=0,
      ubus_read_write_enum read_write=NOP,
      int unsigned         size=0,
      data_t               data[$]='{},
      wait_state_t         wait_state[$]='{},
      int unsigned         error_pos=0,
      int unsigned         transmit_delay=0
    );
    ubus_req product = new(name,
      addr,
      read_write,
      size,
      data,
      wait_state,
      error_pos,
      transmit_delay);
    return product;
  endfunction : create_new

  static function ubus_req create_copy (string name = "ubus_req", uvm_object rhs);
    ubus_req product;
    ubus_req_if rhs_;
    int success;
    data_t data[$];
    wait_state_t wait_state[$];

    success = $cast(rhs_, rhs);
    type_check : assert (success) else
      `uvm_fatal("TYPE_CHECK", {"Failed to cast object ", rhs.get_name(), " to ubus_req_if"})
    rhs_.data().to_queue(data);
    rhs_.wait_state().to_queue(wait_state);

    product = new(name,
      rhs_.addr(),
      rhs_.read_write(),
      rhs_.size(),
      data,
      wait_state,
      rhs_.error_pos(),
      rhs_.transmit_delay());
    return product;
  endfunction : create_copy

  virtual function bit[15:0] addr();
    return values.addr();
  endfunction : addr

  virtual function ubus_read_write_enum read_write();
    return values.read_write();
  endfunction : read_write

  virtual function int unsigned size();
    return values.size();
  endfunction : size

  virtual function immutables_pkg::scalar_tuple#(data_t) data();
    return this.data_tuple;
  endfunction : data

  virtual function immutables_pkg::scalar_tuple#(wait_state_t) wait_state();
    return this.wait_state_tuple;
  endfunction : wait_state

  virtual function int unsigned error_pos();
    return values.error_pos();
  endfunction : error_pos

  virtual function int unsigned transmit_delay();
    return values.transmit_delay();
  endfunction : transmit_delay

endclass : ubus_req


class rand_ubus_rsp extends uvm_object implements ubus_rsp_if;

  typedef bit[7:0] data_t;

  rand data_t data$[];

  constraint c_data_size {
    soft data$.size() == 1;
  }

  `uvm_object_utils_begin(rand_ubus_rsp)
    `uvm_field_array_int(data$, UVM_DEFAULT)
  `uvm_object_utils_end

  // new - constructor
  function new (string name = "rand_ubus_rsp");
    super.new(name);
  endfunction : new

  virtual function immutables_pkg::scalar_tuple#(data_t) data();
    immutables_pkg::scalar_tuple#(data_t) data_tuple;
    data_tuple = immutables_pkg::scalar_tuple#(data_t)::create_new("data", this.data$);
    return data_tuple;
  endfunction : data

endclass : rand_ubus_rsp


class ubus_rsp extends immutables_pkg::immutable_object implements ubus_rsp_if;

  typedef bit[7:0] data_t;

  local rand_ubus_rsp values;
  local immutables_pkg::scalar_tuple#(data_t) data_tuple;

  `immutable_object_utils(ubus_rsp)
  `uvm_field_utils_begin(ubus_rsp)
    `uvm_field_object (values, UVM_DEFAULT | immutables_pkg::IMMUTABLE_FIELD_FLAGS)
  `uvm_field_utils_end

  local function new (string name = "ubus_rsp",
      data_t data[$]='{}
    );
    super.new(name);
    values = rand_ubus_rsp::type_id::create("values");
    values.data$ = new[data.size()](data);
    data_tuple = values.data();
  endfunction : new

  static function ubus_rsp create_new (string name = "ubus_rsp",
      data_t data[$]='{}
    );
    ubus_rsp product = new(name,
      data
    );
    return product;
  endfunction : create_new

  static function ubus_rsp create_copy (string name = "ubus_rsq", uvm_object rhs);
    ubus_rsp product;
    ubus_rsp_if rhs_;
    int success;
    data_t data[$];

    success = $cast(rhs_, rhs);
    type_check : assert (success) else
      `uvm_fatal("TYPE_CHECK", {"Failed to cast object ", rhs.get_name(), " to ubus_rsp_if"})
    rhs_.data().to_queue(data);

    product = new(name,
      data
    );
    return product;
  endfunction : create_copy

  virtual function immutables_pkg::scalar_tuple#(data_t) data();
    return this.data_tuple;
  endfunction : data

endclass : ubus_rsp
