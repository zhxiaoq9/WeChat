`ifndef __RM__
`define __RM__

`include "uvm_macros.svh"
import uvm_pkg::*;
import writer_pkg::*;

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
	extern function bit calculate(input bit [DWIDTH-1:0] data);
endclass


task rm::main_phase(uvm_phase phase);
	trans      tr;
	trans      new_tr;
	super.main_phase(phase);
	while(1)
	begin
		port.get(tr);
		new_tr = new("new_tr");
		new_tr.copy(tr);
		new_tr.data[DWIDTH] = calculate(new_tr.data[DWIDTH-1:0]);
		ap.write(new_tr);

	end
endtask

//calculate the MSB bit
function bit rm::calculate(input bit [DWIDTH-1:0] data);
	bit   ret = 0;
	ret = ^data;
	return ret;
endfunction

`endif
