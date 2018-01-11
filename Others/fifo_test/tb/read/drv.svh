`ifndef __DRV__
`define __DRV__

`include "uvm_macros.svh"
import uvm_pkg::*;
import fifo_pkg::*;


class drv extends uvm_driver #(trans);
	`uvm_component_utils(drv)
	
	virtual arb_if  vif;

    extern function new(string name, uvm_component parent);
	extern virtual function void build_phase(uvm_phase phase);
	extern virtual task reset_phase(uvm_phase phase);
	extern virtual task main_phase(uvm_phase phase);
    extern task single_write(trans tr);
	extern task single_read(trans tr);
endclass



function drv::new(string name, uvm_component parent);
	super.new(name, parent);
endfunction

function void drv::build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db#(virtual arb_if)::get(this, "", "bus", vif))
		`uvm_fatal("drv", "Failed to get interface")
endfunction

task drv::reset_phase(uvm_phase phase);
	vif.rrst_n <= 1'b0;
	vif.wrst_n <= 1'b0;
endtask


task drv::main_phase(uvm_phase phase);
	trans        tr;
	super.main_phase(phase);

	#100;
	while(1)
	begin
		seq_item_port.get_next_item(req);
		if(!$cast(tr, req))
		begin
			`uvm_fatal("drv","failed to receive transaction from sequencer")
		end
		//drive dut
		if(tr.op == FIFO_WRITE)
		begin
			single_write(tr);
			`uvm_info("drv","write fifo", UVM_MEDIUM)
		end
		else
		begin
			single_read(tr);
			`uvm_info("drv","read fifo", UVM_MEDIUM)
		end
		seq_item_port.item_done();
	end

endtask

task drv::single_write(trans tr);
	vif.wrst_n <= 1'b1;
	//@vif.wcb;
	if(vif.wcb.wfull != 1'b1)
	begin
		vif.wcb.winc <= 1'b1;
		vif.wcb.wdata <= tr.wdata;
	end
	@vif.wcb
	vif.wcb.winc <= 1'b0;
endtask


task drv::single_read(trans tr);
	vif.rrst_n <= 1'b1;
	//@vif.rcb;
	if(vif.rcb.rempty != 1'b1)
	begin
		vif.rcb.rinc <= 1'b1;
	end
	@vif.rcb;
	vif.rcb.rinc <= 1'b0;
endtask

`endif
