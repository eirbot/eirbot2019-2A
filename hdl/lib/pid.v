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
	// Global ports
	input clk,
	input rst,
	input clr,
	input en,
	// PID ports
	input [nbits-1:0] sp_i,
	input [nbits-1:0] pv_i,
	output reg [nbits-1:0] co_o,
	// ALU ports
	input [nbits-1:0] alu_key_i,
	input [7:0] alu_O_i,
	output reg [7:0] alu_key_o,
	output reg [7:0] alu_op_o,
	output reg [nbits-1:0] alu_A_o,
	output reg [nbits-1:0] alu_B_o
);

always @(posedge clk) begin
end

endmodule

`endif
