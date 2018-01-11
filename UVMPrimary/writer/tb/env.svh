`ifndef __ENV__
`define __ENV__

`include "uvm_macros.svh"
import uvm_pkg::*;
import writer_pkg::*;

class env extends uvm_env;
	`uvm_component_utils(env);

	agt          agt0;
	o_agt        agt1;
	rm           rm0;
	sb           sb0;
	`ifdef __COVERAGE__
		coverage     cov;
	`endif

	uvm_tlm_analysis_fifo #(trans) agt0_rm0_fifo;
	uvm_tlm_analysis_fifo #(trans) rm0_sb0_fifo;
	uvm_tlm_analysis_fifo #(trans) agt1_sb0_fifo;

	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		agt0 = agt::type_id::create("agt0", this);
		agt1 = o_agt::type_id::create("agt1", this);
		agt0.is_active = UVM_ACTIVE;
		
		rm0 = rm::type_id::create("rm0", this);
		sb0 = sb::type_id::create("sb0", this);
	    
		agt0_rm0_fifo = new("agt0_rm0_fifo", this);
		rm0_sb0_fifo = new("rm0_sb0_fifo", this);
		agt1_sb0_fifo = new("agt1_sb0_fifo", this);

		`ifdef __COVERAGE__
			cov = coverage::type_id::create("cov", this);
		`endif
	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);

		//connect input agent with rm
		agt0.ap.connect(agt0_rm0_fifo.analysis_export);
		rm0.port.connect(agt0_rm0_fifo.blocking_get_export);
		
		//connect rm with sb
		rm0.ap.connect(rm0_sb0_fifo.analysis_export);
		sb0.pred_port.connect(rm0_sb0_fifo.blocking_get_export);

		//connect output agent with sb
		agt1.ap.connect(agt1_sb0_fifo.analysis_export);
		sb0.actu_port.connect(agt1_sb0_fifo.blocking_get_export);
		
	endfunction

endclass


`endif
