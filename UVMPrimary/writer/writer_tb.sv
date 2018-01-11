`include "uvm_macros.svh"
import uvm_pkg::*;
`include "writer_macros.svh"
import writer_pkg::*;

module WRITER_TB;

reg            clk;
reg            rst_n;

initial begin
clk = 1'b0;
rst_n = 1'b0;
end
//100M write clock
always #5 clk = ~clk;

arb_if   vif(clk, rst_n);

WRITER  WRITER(
 .clk(vif.clk),
 .rst_n(vif.rst_n),
 .clear(vif.clear),
 .start(vif.start),
 .in(vif.in),
 .cnt(vif.cnt),
 .out(vif.out)
);

initial
begin
	uvm_config_db #(virtual arb_if)::set(null, "uvm_test_top.env0.agt0.*", "vif", vif);
	uvm_config_db #(virtual arb_if)::set(null, "uvm_test_top.env0.agt1.mon0", "vif", vif);
	uvm_config_db #(virtual arb_if)::set(null, "uvm_test_top.env0.cov", "vif", vif);
	run_test();
end

endmodule
