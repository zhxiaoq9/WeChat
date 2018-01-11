`ifndef __ARB_IF__
`define __ARB_IF__

`include "fifo_macros.svh"

//define read interface
interface arb_if(input bit rclk, input bit wclk);
	//signals for read
	logic              rrst_n;
	logic              rinc;
	logic [DSIZE-1:0]  rdata;
	logic              rempty;
	logic              aempty;

	//signals for write
	logic              wrst_n;
    logic              winc;
    logic [DSIZE-1:0]  wdata;
	logic              wfull;
	logic              afull;



	clocking rcb @(posedge rclk);
		input        rdata;
		input        rempty;
		input        aempty;
		output       rinc;
	endclocking
    
	clocking wcb @(posedge wclk);
		input        wfull;
		input        afull;
		output       winc;
		output       wdata;
	endclocking

	modport read(clocking rcb, output rrst_n);
    modport write(clocking wcb, input wrst_n);

endinterface

`endif
