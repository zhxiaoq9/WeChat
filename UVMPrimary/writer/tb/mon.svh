`ifndef __MON__
`define __MON__

`include "uvm_macros.svh"
import uvm_pkg::*;
import writer_pkg::*;

class mon extends uvm_monitor;

	int   received_num = 0;
	virtual arb_if vif;
	uvm_analysis_port #(trans) ap;

	`uvm_component_utils(mon);

	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db#(virtual arb_if)::get(this, "", "vif", vif))
			`uvm_fatal("mon", "Failed to get interface")
		ap = new("ap", this);
	endfunction

	extern virtual task main_phase(uvm_phase phase);
	extern task receive_one_trans(ref trans tr);
endclass


task mon::main_phase(uvm_phase phase);
	trans tr;
	super.main_phase(phase);
	
	while(1)	
	begin
		tr = new("tr");
		receive_one_trans(tr);
	end
endtask	


task mon::receive_one_trans(ref trans tr);
	bit   start_d1 = 1'b0;
	//wait until not clear
	//while(vif.mcb.clear == 1'b1) @vif.mcb;
	
	while(1)
	begin
		if(vif.mcb.start == 1'b1)     		//wait to start
		begin
			start_d1 = vif.mcb.start; 		//store old value of start
			tr.data = {1'b0,vif.mcb.in};    //store input data to lower bits of transaction
			received_num++;           		//update received transaction number
			`uvm_info("mon", $sformatf("has received %0dth data=%0h", received_num, tr.data), UVM_MEDIUM)
			ap.write(tr);             		//send the transaction
		end
		else if(start_d1 == 1'b1)     		//the last transaction 
		begin
			start_d1 = 1'b0;          
			tr.data = {1'b0, vif.mcb.in}; 	//set the MSB to 1'b0, which will be calculated in rm
			received_num++;           		//update received transaction number
			`uvm_info("mon", $sformatf("has received %0dth data=%0h", received_num, tr.data), UVM_MEDIUM)
			ap.write(tr);             		//send the transaction
			break;
		end
		else                          		//do nothing if not start
		begin
		end
		@vif.mcb;                     		//wait a clock cycle to deal with the next cycle event
	end

endtask

`endif
