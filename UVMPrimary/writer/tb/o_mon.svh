`ifndef __O_MON__
`define __O_MON__

`include "uvm_macros.svh"
import uvm_pkg::*;
import writer_pkg::*;

class o_mon extends uvm_monitor;

	int   received_num = 0;
	virtual arb_if vif;
	uvm_analysis_port #(trans) ap;

	`uvm_component_utils(o_mon);

	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db#(virtual arb_if)::get(this, "", "vif", vif))
			`uvm_fatal("o_mon", "Failed to get interface")
		ap = new("ap", this);
	endfunction

	extern virtual task main_phase(uvm_phase phase);
	extern task receive_one_trans(ref trans tr);
endclass


task o_mon::main_phase(uvm_phase phase);
	trans tr;
	super.main_phase(phase);
	
	while(1)	
	begin
		tr = new("tr");
		receive_one_trans(tr);
	end
endtask	


task o_mon::receive_one_trans(ref trans tr);
	bit   start_d1 = 1'b0;
	bit   start_d2 = 1'b0;

	//wait until not clear
	//while(vif.mcb.clear == 1'b1) @vif.mcb;
	
	while(1)
	begin
		start_d1 = vif.mcb.start;     //store old value of start
		@vif.mcb;                     //wait a clock cycle to updata start signal
		if(start_d1 == 1'b1)          //use the old value of start to check transmittion inorder to get correct dut output
		begin
			start_d2 = start_d1;      
			tr.data = vif.mcb.out;    //store dut output to a new transaction
			received_num++;           //update received transaction number
			`uvm_info("o_mon", $sformatf("has received %0dth data=%0h", received_num, tr.data), UVM_MEDIUM)
			ap.write(tr);             //send the transaction
		end
		else if(start_d2 == 1'b1)     //the last transaction
		begin
			start_d2 = 1'b0;
			tr.data = vif.mcb.out;    //update received transaction number
			received_num++;
			`uvm_info("o_mon", $sformatf("has received %0dth data=%0h", received_num, tr.data), UVM_MEDIUM)
			break;
		end
		else                          //do nothing if not start
		begin
		end
	end

endtask

`endif
