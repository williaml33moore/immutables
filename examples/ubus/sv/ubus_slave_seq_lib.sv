//----------------------------------------------------------------------
//   Copyright 2007-2011 Mentor Graphics Corporation
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
// SEQUENCE: simple_response_seq
//
//------------------------------------------------------------------------------

class simple_response_seq extends uvm_sequence #(ubus_transfer);
   ubus_slave_sequencer p_sequencer;
   
  function new(string name="simple_response_seq");
    super.new(name);
  endfunction

//  `uvm_object_utils(simple_response_seq)
    
  `uvm_object_utils(simple_response_seq)

  ubus_transfer util_transfer;

  virtual task body();
     $cast(p_sequencer, m_sequencer);
     
    `uvm_info(get_type_name(),
      $sformatf("%s starting...",
      get_sequence_path()), UVM_MEDIUM);
    forever begin
      p_sequencer.addr_ph_port.peek(util_transfer);

      // Need to raise/drop objection before each item because we don't want
      // to be stopped in the middle of a transfer.
      uvm_test_done.raise_objection(this);
      `uvm_do_with(req, 
        { req.request_constraints.read_write == util_transfer.get_request().read_write; 
          req.request_constraints.size == util_transfer.get_request().size; 
          req.request_constraints.error_pos == 1000; } )
      uvm_test_done.drop_objection(this);
    end
  endtask : body

endclass : simple_response_seq


//------------------------------------------------------------------------------
//
// SEQUENCE: slave_memory_seq
//
//------------------------------------------------------------------------------

class slave_memory_seq extends uvm_sequence #(ubus_transfer);

  function new(string name="slave_memory_seq");
    super.new(name);
  endfunction

//  `uvm_object_utils(slave_memory_seq)

  `uvm_object_utils(slave_memory_seq)
  `uvm_declare_p_sequencer(ubus_slave_sequencer)

  ubus_transfer util_transfer;

  int unsigned m_mem[int unsigned];

  virtual task pre_do(bit is_item);
    rand_ubus_req tmp_req;
    rand_ubus_rsp tmp_rsp;
    
    // Update the properties that are relevant to both read and write
    tmp_req = rand_ubus_req::type_id::create("request");
    tmp_rsp = rand_ubus_rsp::type_id::create("response");
    if (req.get_request() != null) tmp_req.copy(req.get_request());
    tmp_req.size$       = util_transfer.get_request().size;
    tmp_req.addr$       = util_transfer.get_request().addr;             
    tmp_req.read_write$ = util_transfer.get_request().read_write;             
    tmp_req.error_pos$  = 1000;             
    tmp_req.transmit_delay$ = 0;
    tmp_req.wait_state$ = new[util_transfer.get_request().size];
    tmp_rsp.data$ = new[util_transfer.get_request().size];
    for(int unsigned i = 0 ; i < util_transfer.get_request().size ; i ++) begin
      tmp_req.wait_state$[i] = 2;
      // For reads, populate req with the random "readback" data of the size
      // requested in util_transfer
      if( tmp_req.read_write == READ ) begin : READ_block
        if (!m_mem.exists(util_transfer.get_request().addr + i)) begin
          m_mem[util_transfer.get_request().addr + i] = $urandom;
        end
        tmp_rsp.data$[i] = m_mem[util_transfer.get_request().addr + i];
      end
    end
    req.set_request(tmp_req);
    req.set_response(tmp_rsp);
  endtask

  function void post_do(uvm_sequence_item this_item);
    // For writes, update the m_mem associative array
    if( util_transfer.get_request().read_write == WRITE ) begin : WRITE_block
      for(int unsigned i = 0 ; i < req.get_request().size ; i ++) begin : for_block
        m_mem[req.get_request().addr + i] = req.get_request().data().get(i);
      end : for_block
    end
  endfunction

  virtual task body();
     uvm_phase p;
    `uvm_info(get_type_name(),
      $sformatf("%s starting...",
      get_sequence_path()), UVM_MEDIUM)

    $cast(req, create_item(ubus_transfer::get_type(), p_sequencer, "req"));
    p = get_starting_phase();

    forever
    begin
      p_sequencer.addr_ph_port.peek(util_transfer);

      // Need to raise/drop objection before each item because we don't want
      // to be stopped in the middle of a transfer.
      p.raise_objection(this);

      start_item(req);
      finish_item(req);

      p.drop_objection(this);
    end
  endtask : body

endclass : slave_memory_seq


