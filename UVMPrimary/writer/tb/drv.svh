`ifndef __DRV__
`define __DRV__

`include "uvm_macros.svh"
import uvm_pkg::*;
import writer_pkg::*;


class drv extends uvm_driver #(trans);
	`uvm_component_utils(drv)	
	virtual arb_if  vif;

    extern function new(string name, uvm_component parent);
	extern virtual function void build_phase(uvm_phase phase);
	extern virtual task reset_phase(uvm_phase phase);
	extern virtual task main_phase(uvm_phase phase);
    extern task single_write(trans tr);
endclass



function drv::new(string name, uvm_component parent);
	super.new(name, parent);
endfunction

function void drv::build_phase(uvm_phase phase);
	super.build_phase(phase);
	//get virtual interface from top module
	if(!uvm_config_db#(virtual arb_if)::get(this, "", "vif", vif))
		`uvm_fatal("drv", "Failed to get interface")
endfunction

//reset the dut
task drv::reset_phase(uvm_phase phase);
	vif.rst_n <= 1'b0;
	vif.dcb.clear <= 1'b0;
	vif.dcb.start <= 1'b0;
endtask


task drv::main_phase(uvm_phase phase);
	int          send_num = 0;
	trans        tr;
	super.main_phase(phase);


	while(1)
	begin
	vif.rst_n <= 1'b1;
	vif.dcb.clear <= 1'b0;
	seq_item_port.get_next_item(req);
		if(!$cast(tr, req))
			`uvm_fatal("drv","failed to receive transaction from sequencer")
		//drive dut
		single_write(tr);
	send_num++;
	`uvm_info("drv", $sformatf("the %0dth data=%0h has been sent", send_num, tr.data[DWIDTH-1:0]), UVM_MEDIUM)	
	seq_item_port.item_done();	
	end
	
endtask

task drv::single_write(trans tr);
	vif.dcb.start <= 1'b1;
	vif.dcb.in <= tr.data[DWIDTH-1:0];
	@(posedge vif.clk);
	vif.dcb.start <= 1'b0;	
endtask


`endif
