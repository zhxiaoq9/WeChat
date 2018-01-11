`ifndef __BASE_TEST__
`define __BASE_TEST__

`include "uvm_macros.svh"
import uvm_pkg::*;
import writer_pkg::*;

class base_test extends uvm_test;
	`uvm_component_utils(base_test)
	
	env env0;

	function new(string name="base_test", uvm_component parent=null);
		super.new(name, parent);
		env0 = env::type_id::create("env0", this);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction
endclass

`endif
