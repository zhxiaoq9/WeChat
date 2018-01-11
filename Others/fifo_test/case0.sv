`ifndef __CASE0_SEQ__
`define __CASE0_SEQ__

`include "uvm_macros.svh"
import uvm_pkg::*;
import fifo_pkg::*;

class case0_seq extends uvm_sequence #(trans);
	trans       tr;
	
	`uvm_object_utils(case0_seq)

	function new(string name = "case0_seq");
		super.new(name);
	endfunction

	virtual task body();
		//starting_phase is a pointer, so we have to check it
		if(starting_phase != null)
			starting_phase.raise_objection(this); //begin simulating
	    //send data
		repeat (20) 
        	begin
				//`uvm_do(tr)
				`uvm_do_with(tr,{tr.op == FIFO_WRITE;})
			end
		#100
		//close simulating
		if(starting_phase != null)
			starting_phase.drop_objection(this);
	endtask
endclass


class case0 extends base_test;
	`uvm_component_utils(case0)

	function new(string name = "case0", uvm_component parent = null);
		super.new(name, parent);
		$display("run case0");
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		uvm_config_db#(uvm_object_wrapper)::set(this, "env0.i_agt.sqr0.main_phase", "default_sequence", case0_seq::type_id::get());
	endfunction
endclass

`endif
