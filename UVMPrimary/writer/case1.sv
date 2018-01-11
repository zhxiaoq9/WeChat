`ifndef __CASE1_SEQ__
`define __CASE1_SEQ__

`include "uvm_macros.svh"
import uvm_pkg::*;
import writer_pkg::*;

class case1_seq extends uvm_sequence #(trans);
	trans       tr;
	
	localparam max = (1 << DWIDTH) - 1;

	`uvm_object_utils(case1_seq)

	function new(string name = "case1_seq");
		super.new(name);
	endfunction

	virtual task body();
		//starting_phase is a pointer, so we have to check it
		if(starting_phase != null)
			starting_phase.raise_objection(this); //begin simulating
		#10;
	    //send data
		repeat (20) 
        	begin
				`uvm_do(tr)
			end
		`uvm_do_with(tr,{tr.data == 0;})
		`uvm_do_with(tr,{tr.data == max;})
		
		#100;
		//close simulation
		if(starting_phase != null)
			starting_phase.drop_objection(this);
	endtask
endclass


class case1 extends base_test;
	`uvm_component_utils(case1)

	function new(string name = "case1", uvm_component parent = null);
		super.new(name, parent);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		uvm_config_db#(uvm_object_wrapper)::set(this, "env0.agt0.sqr0.main_phase", "default_sequence", case1_seq::type_id::get());
	endfunction
endclass

`endif
