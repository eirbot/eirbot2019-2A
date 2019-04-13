/*
 * PID module
 * TODO
 * A lot
 */

`ifndef PID_V
`define PID_V

`include "src/config.vh"

module pid #(
	parameter nbits = `PID_RES
)(
	// Global inputs
	input clk,
	input rst,
	input clr,
	input en,
	// value inputs
	input [nbits-1:0] u_i,
	input [nbits-1:0] v_i,
	// Output
	output reg [nbits-1:0] out
);

always @(posedge clk)
begin
	out <= u_i*v_i;
end


endmodule

`endif
