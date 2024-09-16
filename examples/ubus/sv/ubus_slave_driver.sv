//----------------------------------------------------------------------
//   Copyright 2007-2010 Mentor Graphics Corporation
//   Copyright 2007-2011 Cadence Design Systems, Inc.
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
// CLASS: ubus_slave_driver
//
//------------------------------------------------------------------------------

class ubus_slave_driver extends uvm_driver #(ubus_transfer);

  // The virtual interface used to drive and view HDL signals.
  protected virtual ubus_if vif;

  // Provide implementations of virtual methods such as get_type_name and create
  `uvm_component_utils(ubus_slave_driver)

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
     if(!uvm_config_db#(virtual ubus_if)::get(this, "", "vif", vif))
       `uvm_fatal("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"});
  endfunction: build_phase

  // run phase
  virtual task run_phase(uvm_phase phase);
    fork
      get_and_drive();
      reset_signals();
    join
  endtask : run_phase

  // get_and_drive
  virtual protected task get_and_drive();
    @(negedge vif.sig_reset);
    forever begin
      @(posedge vif.sig_clock);
      seq_item_port.get_next_item(req);
      respond_to_transfer(req);
      seq_item_port.item_done();
    end
  endtask : get_and_drive

  // reset_signals
  virtual protected task reset_signals();
    forever begin
      @(posedge vif.sig_reset);
      vif.sig_error      <= 1'bz;
      vif.sig_wait       <= 1'bz;
      vif.rw             <= 1'b0;
    end
  endtask : reset_signals

  // respond_to_transfer
  virtual protected task respond_to_transfer(ubus_transfer trans);
    ubus_req bus_req;
    ubus_rsp bus_rsp;
    rand_ubus_req updated_req;

    bus_req = trans.get_request();
    bus_rsp = trans.get_response();
    updated_req = rand_ubus_req::type_id::create("updated_req");
    updated_req.copy(bus_req);
    if (bus_req.read_write != NOP)
    begin
      vif.sig_error <= 1'b0;
      if (bus_req.read_write == WRITE) updated_req.data$ = new[bus_req.size];
      for (int i = 0; i < bus_req.size; i++)
      begin
        case (bus_req.read_write)
          READ : begin
            vif.rw <= 1'b1;
            vif.sig_data_out <= bus_rsp.data().get(i);
          end
          WRITE : begin
          end
        endcase
        if (bus_req.wait_state().get(i) > 0) begin
          vif.sig_wait <= 1'b1;
          repeat (bus_req.wait_state().get(i))
            @(posedge vif.sig_clock);
        end
        vif.sig_wait <= 1'b0;
        @(posedge vif.sig_clock);
        if (bus_req.read_write == WRITE) updated_req.data$[i] = vif.sig_data;
      end
      vif.rw <= 1'b0;
      vif.sig_wait  <= 1'bz;
      vif.sig_error <= 1'bz;
    end
    trans.set_request(updated_req);
  endtask : respond_to_transfer

endclass : ubus_slave_driver


