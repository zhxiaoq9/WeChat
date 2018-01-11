`ifndef __SB__
`define __SB__

`include "uvm_macros.svh"
import uvm_pkg::*;
import writer_pkg::*;

class sb extends uvm_scoreboard;
	`uvm_component_utils(sb)

	trans pred[$];                             //predict data queue
	trans actu[$];                             //real data queue

	uvm_blocking_get_port #(trans) pred_port;  //predict data
	uvm_blocking_get_port #(trans) actu_port;  //real data

	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		pred_port    = new("pred_port", this);
		actu_port = new("actu_port", this);
	endfunction

	extern virtual task main_phase(uvm_phase phase);

endclass

task sb::main_phase(uvm_phase phase);
	trans       pred_tr;
	trans       pred_tr_tmp;
	trans       actu_tr;
	bit         error;
	super.main_phase(phase);

	fork
		while(1)
		begin
			pred_port.get(pred_tr);
			pred.push_back(pred_tr);
		end
		while(1)
		begin
			actu_port.get(actu_tr);

			if(pred.size() > 0)
			begin
				pred_tr_tmp = pred.pop_front();
				error = actu_tr.compare(pred_tr_tmp);
				if(error == 1'b1) //compare successful
				begin
					`uvm_info("sb", "result compare successful", UVM_MEDIUM);
					`uvm_info("sb", "the transaction from rm", UVM_MEDIUM);
					pred_tr_tmp.print();
					`uvm_info("sb", "the transaction from dut", UVM_MEDIUM);
					actu_tr.print();
				end
				else              //compare error
				begin
					`uvm_error("sb", "result compare failed")
					$display("the expect transaction is");
					pred_tr_tmp.print();
					$display("the actual transaction is");
					actu_tr.print();
				end
			end
			else                  //unknow error
			begin
				`uvm_error("sb", "received a transaction from dut, while the expect transaction is empty")
				$display("the actual is");
				actu_tr.print();
			end
		end
	join
endtask

`endif
