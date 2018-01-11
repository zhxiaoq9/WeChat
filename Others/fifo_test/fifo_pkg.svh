`ifndef __FIFO_PKG__
`define __FIFO_PKG__

package fifo_pkg;

typedef enum bit{
	FIFO_READ  = 1'b0,
	FIFO_WRITE = 1'b1
} fifo_op;

`include "tb/trans.svh"
`include "tb/sqr.svh"
`include "tb/drv.svh"
`include "tb/mon.svh"
`include "tb/agt.svh"

`include "tb/rm.svh"
`include "tb/sb.svh"
`include "tb/env.svh"
`include "tb/base_test.svh"

`include "case0.sv"

endpackage

`endif

