`ifndef __AGT__
`define __AGT__

`include "uvm_macros.svh"
import uvm_pkg::*;
import fifo_pkg::*;

class agt extends uvm_agent;
	`uvm_component_utils(agt)

	sqr      sqr0;
	drv      drv0;
	mon      mon0;
	uvm_analysis_port #(trans) ap;


	extern function new(string name, uvm_component parent);
	extern virtual function void build_phase(uvm_phase phase);
	extern virtual function void connect_phase(uvm_phase phase);

endclass

function agt::new(string name, uvm_component parent);
	super.new(name, parent);
endfunction

function void agt::build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(is_active == UVM_ACTIVE)
	begin
		sqr0 = sqr::type_id::create("sqr0",this);
		drv0 = drv::type_id::create("drv0",this);
	end
	mon0 = mon::type_id::create("mon0",this);
endfunction

function void agt::connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	if(is_active == UVM_ACTIVE)
	begin
		drv0.seq_item_port.connect(sqr0.seq_item_export);
	end
	this.ap = mon0.ap;
endfunction


`endif

