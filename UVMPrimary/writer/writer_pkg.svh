`ifndef __WRITER_PKG__
`define __WRITER_PKG__

package writer_pkg;

parameter DWIDTH = 10;
parameter VWIDTH = 4;

`include "writer_macros.svh"

`include "tb/coverage.svh"
`include "tb/trans.svh"
`include "tb/sqr.svh"
`include "tb/drv.svh"
`include "tb/mon.svh"
`include "tb/agt.svh"
`include "tb/o_mon.svh"
`include "tb/o_agt.svh"

`include "tb/rm.svh"
`include "tb/sb.svh"
`include "tb/env.svh"
`include "tb/base_test.svh"


`include "case0.sv"
`include "case1.sv"

endpackage

`endif

