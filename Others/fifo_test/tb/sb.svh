`ifndef __SB__
`define __SB__

`include "uvm_macros.svh"
import uvm_pkg::*;
import fifo_pkg::*;

class sb extends uvm_scoreboard;
	`uvm_component_utils(sb)

	trans tr;

	uvm_blocking_get_port #(trans) pred_port;  //predict data
	uvm_blocking_get_port #(trans) actu_port;  //real data

	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		pred_port    = new("pred_port", this);
		actu_port = new("actu_port", this);
	endfunction

	extern virtual task main_phase(uvm_phase phase);

endclass

task sb::main_phase(uvm_phase phase);
	trans       pred_tr;
	trans       actu_tr;
	super.main_phase(phase);

	while(1)
	begin
		#20;
		pred_port.get(pred_tr);
		`uvm_info("sb", "get a transaction from rm", UVM_MEDIUM)
		pred_port.get(actu_tr);
		`uvm_info("sb", "get a transaction from out agent", UVM_MEDIUM)
	end
endtask

`endif
