`ifndef __TRANS__
`define __TRANS__

`include "fifo_macros.svh"
import fifo_pkg::*;
`include "uvm_macros.svh"
import uvm_pkg::*;

//class trans extends uvm_transaction;
class trans extends uvm_sequence_item;
	//rand  bit                 wrst_n;
	//rand  bit                 winc;
	rand  bit [DSIZE-1:0]     wdata;
	rand  bit [DSIZE-1:0]     rdata;
	rand  fifo_op             op;

//	constraint wdata_range{
//		wdata > 0;
//        wdata < 1000;
//	}
//	constraint rdata_range{
//		wdata > 0;
//        wdata < 1000;
//	}

	`uvm_object_utils_begin(trans)
	`uvm_field_int(wdata, UVM_ALL_ON)
	`uvm_field_int(rdata, UVM_ALL_ON)
	`uvm_object_utils_end

function new (string name = "trans");
	super.new(name);
endfunction

endclass

`endif
