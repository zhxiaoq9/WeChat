`ifndef __O_AGT__
`define __O_AGT__

`include "uvm_macros.svh"
import uvm_pkg::*;
import writer_pkg::*;

class o_agt extends uvm_agent;
	`uvm_component_utils(o_agt)

	o_mon      mon0;
	uvm_analysis_port #(trans) ap;


	extern function new(string name, uvm_component parent);
	extern virtual function void build_phase(uvm_phase phase);
	extern virtual function void connect_phase(uvm_phase phase);

endclass

function o_agt::new(string name, uvm_component parent);
	super.new(name, parent);
endfunction

function void o_agt::build_phase(uvm_phase phase);
	super.build_phase(phase);
	mon0 = o_mon::type_id::create("mon0",this);
endfunction

function void o_agt::connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	//connect agent analysis port to monitor analysis port
	this.ap = mon0.ap;
endfunction


`endif

