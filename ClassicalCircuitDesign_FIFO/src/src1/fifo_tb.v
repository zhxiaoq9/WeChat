`timescale 1ns/1ns


module FIFO_TB;

reg            wclk;
reg            wrst_n;
reg            winc;
reg  [7:0]     wdata;   

reg            rclk;
reg            rrst_n;
reg            rinc;

wire           wfull;
wire           afull;
wire           rempty;
wire           aempty;
wire [7:0]     rdata; 



initial begin
init();
unreset();
//write 16 data
single_write();
single_write();
single_write();
single_write();
single_write();
single_write();
single_write();
single_write();
single_write();
single_write();
single_write();
single_write();
single_write();
single_write();
single_write();
single_write();

//read 16 data
single_read();
single_read();
single_read();
single_read();
single_read();
single_read();
single_read();
single_read();
single_read();
single_read();
single_read();
single_read();
single_read();
single_read();
single_read();
single_read();

//write 3 data
single_write();
single_write();
single_write();

#100;
end

/*
initial begin
init();
unreset();
random_op();
random_op();
random_op();
random_op();
random_op();
random_op();
random_op();
random_op();
random_op();
random_op();
random_op();
random_op();
random_op();
random_op();
random_op();
random_op();
random_op();
random_op();
random_op();
random_op();
$stop;
end
*/

//100M write clock
always #5 wclk = ~wclk;
//300M read clock
always #2 rclk = ~rclk;

task init();
begin
	wclk = 1'b0;
	wrst_n = 1'b0;
	winc = 1'b0;
	wdata = 8'd0;

	rclk = 1'b0;
	rrst_n = 1'b0;
	rinc = 1'b0;
	#20;
end
endtask

task unreset();
begin
	wrst_n <= 1'b1;
	rrst_n <= 1'b1;
	#20;
end
endtask


task single_write();
begin
	winc <= 1'b1;
	wdata <= $random();
	@(posedge wclk);
	winc <= 1'b0;
end
endtask

task single_read();
begin
	rinc <= 1'b1;
	@(posedge rclk);
	rinc <= 1'b0;
end
endtask

task random_op();
begin
	winc <= $random();
	wdata <= $random();
	rinc <= $random();
	@(posedge rclk);
end
endtask

FIFO1  FIFO1(
 .wclk(wclk),
 .wrst_n(wrst_n),
 .winc(winc),
 .wdata(wdata),

 .rclk(rclk),
 .rrst_n(rrst_n),
 .rinc(rinc),

 .wfull(wfull),
 .afull(afull),

 .rempty(rempty),
 .aempty(aempty),
 .rdata(rdata)
);

endmodule
