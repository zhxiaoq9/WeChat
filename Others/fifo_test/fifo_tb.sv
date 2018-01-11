`timescale 1ns/1ns

`include "uvm_macros.svh"
import uvm_pkg::*;
`include "fifo_macros.svh"
import fifo_pkg::*;
//`include "case0.sv"

module FIFO_TB;

reg            wclk;
reg            rclk;

initial begin
wclk = 1'b0;
rclk = 1'b0;

#1000;
$stop;

end
//100M write clock
always #5 wclk = ~wclk;
//300M read clock
always #2 rclk = ~rclk;

arb_if   bus(rclk, wclk);

FIFO1  FIFO1(
 .wclk(bus.wclk),
 .wrst_n(bus.wrst_n),
 .winc(bus.winc),
 .wdata(bus.wdata),

 .rclk(bus.rclk),
 .rrst_n(bus.rrst_n),
 .rinc(bus.rinc),

 .wfull(bus.wfull),
 .afull(bus.afull),

 .rempty(bus.rempty),
 .aempty(bus.aempty),
 .rdata(bus.rdata)
);

initial
begin
	uvm_config_db #(virtual arb_if)::set(null, "*", "bus", bus);
	run_test();
end

endmodule
