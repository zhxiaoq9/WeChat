`ifndef __TRANS__
`define __TRANS__

`include "writer_macros.svh"
import writer_pkg::*;
`include "uvm_macros.svh"
import uvm_pkg::*;

//class trans extends uvm_transaction;
class trans extends uvm_sequence_item;
	rand  bit [DWIDTH:0]     data;

//	constraint data_range{
//		data[DWIDTH-1:0] > 0;
//      data[DWIDTH-1:0] < 1000;
//	}

	`uvm_object_utils_begin(trans)
	`uvm_field_int(data, UVM_ALL_ON)
	`uvm_object_utils_end

function new (string name = "trans");
	super.new(name);
endfunction

endclass

`endif
