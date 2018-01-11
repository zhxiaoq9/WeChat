`ifdef __COVERAGE__

`include "uvm_macros.svh"
import uvm_pkg::*;
`include "writer_macros.svh"

class coverage extends uvm_component;
	virtual arb_if  vif;
	bit [DWIDTH-1:0] data;
	bit [VWIDTH-1:0] cnt;

	localparam data_max = (1 << DWIDTH) - 1;
	localparam cnt_max  = (1 << VWIDTH) - 1;

	`uvm_component_utils(coverage)
	

	covergroup data_cov;
		coverpoint data{
			bins zeros = {0};
			bins others = {[1 : data_max - 1]};
			bins ones = {data_max};
		}
	endgroup
	
	covergroup cnt_cov;
		coverpoint cnt{
			bins zeros = {0};
			bins others = {[1 : cnt_max - 1]};
			bins ones = {cnt_max};
			bins change = (cnt_max => 0);
		}
	endgroup	
	
	
	function new(string name, uvm_component parent);
		super.new(name, parent);
		//the new operation can not be moved to build phase
		data_cov = new();
		cnt_cov  = new();
	endfunction
	
	function void build_phase(uvm_phase phase);
		if(!uvm_config_db #(virtual arb_if)::get(this, "", "vif", vif))
			`uvm_fatal("coverage", "failed to get virtual interface")
	endfunction

	task run_phase(uvm_phase phase);
		forever
		begin
			@(posedge vif.clk);
			data = vif.dcb.in;
			cnt = vif.mcb.cnt;
			data_cov.sample();		
			cnt_cov.sample();
		end
	endtask
	
endclass

`endif
