`ifndef __ENV__
`define __ENV__

`include "uvm_macros.svh"
import uvm_pkg::*;
import fifo_pkg::*;

class env extends uvm_env;
	`uvm_component_utils(env);

	agt          i_agt;
	agt          o_agt;
	rm           rm0;
	sb           sb0;

	uvm_tlm_analysis_fifo #(trans) i_agt_rm_fifo;
	uvm_tlm_analysis_fifo #(trans) rm_sb_fifo;
	uvm_tlm_analysis_fifo #(trans) o_agt_sb_fifo;

	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		i_agt = new("i_agt", this);
		o_agt = new("o_agt", this);
		i_agt.is_active = UVM_ACTIVE;
        o_agt.is_active = UVM_PASSIVE;
		rm0     = new("rm0", this);
		sb0     = new("sb0", this);
		i_agt_rm_fifo = new("i_agt_rm_fifo", this);
		rm_sb_fifo = new("rm_sb_fifo", this);
		o_agt_sb_fifo = new("o_agt_sb_fifo", this);
	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);

		i_agt.ap.connect(i_agt_rm_fifo.analysis_export);
		rm0.port.connect(i_agt_rm_fifo.blocking_get_export);
		
		rm0.ap.connect(rm_sb_fifo.analysis_export);
		sb0.pred_port.connect(rm_sb_fifo.blocking_get_export);

		o_agt.ap.connect(o_agt_sb_fifo.analysis_export);
		sb0.actu_port.connect(o_agt_sb_fifo.blocking_get_export);
		
	endfunction

endclass


`endif
