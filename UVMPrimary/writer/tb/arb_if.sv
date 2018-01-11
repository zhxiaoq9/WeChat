`ifndef __ARB_IF__
`define __ARB_IF__

import writer_pkg::*;

//define read interface
interface arb_if(input bit clk, input bit rst_n);
	//signals for read
	bit                clear;
	bit                start;
	bit   [DWIDTH-1:0] in;
	bit   [VWIDTH-1:0] cnt;
	bit   [DWIDTH:0]   out;

	//for driver
	clocking dcb @(posedge clk);
		output        clear;
		output        start;
		output        in;
	endclocking

	//for monitor
	clocking mcb @(posedge clk);
		input         clear;
		input         start;
		input         in;
		input         cnt;
		input         out;
	endclocking
    
endinterface

`endif
