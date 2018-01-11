`ifndef __MON__
`define __MON__

`include "uvm_macros.svh"
import uvm_pkg::*;
import fifo_pkg::*;

class mon extends uvm_monitor;

	virtual arb_if vif;
	uvm_analysis_port #(trans) ap;

	`uvm_component_utils(mon);

	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db#(virtual arb_if)::get(this, "", "bus", vif))
			`uvm_fatal("mon", "Failed to get interface")
		ap = new("ap", this);
	endfunction

	extern virtual task main_phase(uvm_phase phase);
	extern task receive_one_trans(ref trans tr);
endclass

task mon::main_phase(uvm_phase phase);
	trans tr;
	super.main_phase(phase);
	
	while(1)	
	begin
		tr = new("tr");
		receive_one_trans(tr);
		ap.write(tr);
		`uvm_info("mon", "monitor write a transaction to agent", UVM_MEDIUM)
	end
	
endtask


task mon::receive_one_trans(tr);
	
endmodule

`endif
