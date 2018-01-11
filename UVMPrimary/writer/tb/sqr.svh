`ifndef __SQR__
`define __SQR__

`include "uvm_macros.svh"
import uvm_pkg::*;
import writer_pkg::*;

class sqr extends uvm_sequencer #(trans);

	`uvm_component_utils(sqr)

	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction
endclass

`endif

