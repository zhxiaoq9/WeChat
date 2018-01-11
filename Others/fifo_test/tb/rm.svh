`ifndef __RM__
`define __RM__

`include "uvm_macros.svh"
import uvm_pkg::*;
import fifo_pkg::*;

class rm extends uvm_component;
	`uvm_component_utils(rm)

	uvm_blocking_get_port #(trans)   port;
	uvm_analysis_port #(trans)       ap;

	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction
	
	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		port = new("port", this);
		ap = new("ap", this);
	endfunction

	extern task main_phase(uvm_phase phase);
endclass

task rm::main_phase(uvm_phase phase);
	trans      tr;
	super.main_phase(phase);
	while (1)
	begin
		port.get(tr);
		`uvm_info("rm", "get a transaction from monitor", UVM_MEDIUM)
		ap.write(tr);
		`uvm_info("rm", "send a transaction to secore board", UVM_MEDIUM)
	end
endtask


`endif
