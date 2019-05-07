/*
 * PID module
 * TODO
 * A lot
 */

`ifndef PID_V
`define PID_V

`include "src/config.vh"

module pid #(
	parameter nbits = `PID_RES,
	parameter base_key = `KEY_SIZE'h0
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
	input [`KEY_SIZE-1:0] alu_key_i,
	input [nbits-1:0] alu_O_i,
	output reg [`KEY_SIZE-1:0] alu_key_o,
	output reg [`OPCODE_SIZE-1:0] alu_op_o,
	output reg [nbits-1:0] alu_A_o,
	output reg [nbits-1:0] alu_B_o
);

localparam key1 = base_key;
localparam key2 = base_key+1;
localparam beta1 = 0;
localparam beta2 = 0;
localparam beta3 = 0;
localparam alpha0 = 0;
localparam alpha1 = 0;
localparam alpha2 = 0;
localparam alpha3 = 0;
reg [7:0] state;
reg [nbits-1:0] e0;
reg [nbits-1:0] e1;
reg [nbits-1:0] e2;
reg [nbits-1:0] e3;
reg [nbits-1:0] u0;
reg [nbits-1:0] u1;
reg [nbits-1:0] u2;
reg [nbits-1:0] u3;

always @(posedge clk) begin
	if (rst || clr) begin
		co_o <= {nbits{0}};
		alu_key_o <= {`KEY_SIZE{0}};
		alu_op_o <= {`OPCODE_SIZE{0}};
		alu_A_o <= {nbits{0}};
		alu_B_o <= {nbits{0}};
	//calcul de l'erreur
	end else if (en && state == 0) begin
		u0 <= {nbits{0}};
		u1 <= u0;
		u2 <= u1;
		u3 <= u2;
		e1 <= e0;
		e2 <= e1;
		e3 <= e2;
		alu_key_o <= key1;
		alu_op_o <= `SUB;
		alu_A_o <= sp_i;
		alu_B_o <= pv_i;
		state <= state + 1;
	//calcul de beta1*u[n-1]
	end else if (state == 1 && alu_key_i == alu_key_o) begin
		e0 <= alu_O_i;
		alu_key_o <= key2;
		alu_op_o <= `MUL;
		alu_A_o <= beta1;
		alu_B_o <= u1;
		state <= state + 1;
	//calcul de beta2*u[n-2]
	end else if (state == 2 && alu_key_i == alu_key_o) begin
		u0 <= alu_O_i;
		alu_key_o <= key1;
		alu_op_o <= `MUL;
		alu_A_o <= beta2;
		alu_B_o <= u2;
		state <= state + 1;
	//calcul de beta1*u[n-1]+beta2*u[n-2]
	end else if (state == 3 && alu_key_i == alu_key_o) begin
		alu_key_o <= key2;
		alu_op_o <= `ADD;
		alu_A_o <= u0;
		alu_B_o <= alu_O_i;
		state <= state + 1;
	//calcul de beta3*u[n-3]
	end else if (state == 4 && alu_key_i == alu_key_o) begin
		u0 <= alu_O_i;
		alu_key_o <= key1;
		alu_op_o <= `MUL;
		alu_A_o <= beta3;
		alu_B_o <= u3;
		state <= state + 1;
	//calcul de beta1*u[n-1]+beta2*u[n-2]+beta3*u[n-3]
	end else if (state == 5 && alu_key_i == alu_key_o) begin
		alu_key_o <= key2;
		alu_op_o <= `ADD;
		alu_A_o <= u0;
		alu_B_o <= alu_O_i;
		state <= state + 1;
	//calcul de alpha3*e[n-3]
	end else if (state == 6 && alu_key_i == alu_key_o) begin
		u0 <= alu_O_i;
		alu_key_o <= key1;
		alu_op_o <= `MUL;
		alu_A_o <= alpha3;
		alu_B_o <= e3;
		state <= state + 1;
	//calcul de alpha3*e[n-3] - (beta1*u[n-1]+beta2*u[n-2]+beta3*u[n-3]+beta4*u[n-4])
	end else if (state == 7 && alu_key_i == alu_key_o) begin
		alu_key_o <= key2;
		alu_op_o <= `SUB;
		alu_A_o <= u0;
		alu_B_o <= alu_O_i;
		state <= state + 1;
	//calcul de alpha2*e[n-2]
	end else if (state == 8 && alu_key_i == alu_key_o) begin
		u0 <= alu_O_i;
		alu_key_o <= key1;
		alu_op_o <= `MUL;
		alu_A_o <= alpha2;
		alu_B_o <= e2;
		state <= state + 1;
	//calcul de alpha2*e[n-2] + alpha3*e[n-3] - (beta1*u[n-1]+beta2*u[n-2]+beta3*u[n-3]+beta4*u[n-4])
	end else if (state == 9 && alu_key_i == alu_key_o) begin
		alu_key_o <= key2;
		alu_op_o <= `ADD;
		alu_A_o <= u0;
		alu_B_o <= alu_O_i;
		state <= state + 1;
	//calcul de alpha1*e[n-1]
	end else if (state == 10 && alu_key_i == alu_key_o) begin
		u0 <= alu_O_i;
		alu_key_o <= key1;
		alu_op_o <= `MUL;
		alu_A_o <= alpha1;
		alu_B_o <= e1;
		state <= state + 1;
	//calcul de alpha1*e[n-1] + alpha2*e[n-2] + alpha3*e[n-3] - (beta1*u[n-1]+beta2*u[n-2]+beta3*u[n-3]+beta4*u[n-4])
	end else if (state == 11 && alu_key_i == alu_key_o) begin
		alu_key_o <= key2;
		alu_op_o <= `ADD;
		alu_A_o <= u0;
		alu_B_o <= alu_O_i;
		state <= state + 1;
	//calcul de alpha0*e[n]
	end else if (state == 12 && alu_key_i == alu_key_o) begin
		u0 <= alu_O_i;
		alu_key_o <= key1;
		alu_op_o <= `MUL;
		alu_A_o <= alpha0;
		alu_B_o <= e0;
		state <= state + 1;
	//calcul de alpha0*e[n] + alpha1*e[n-1] + alpha2*e[n-2] + alpha3*e[n-3] - (beta1*u[n-1]+beta2*u[n-2]+beta3*u[n-3]+beta4*u[n-4])
	end else if (state == 13 && alu_key_i == alu_key_o) begin
		alu_key_o <= key2;
		alu_op_o <= `ADD;
		alu_A_o <= u0;
		alu_B_o <= alu_O_i;
		state <= state + 1;
	end else if (state == 13 && alu_key_i == alu_key_o) begin
		u0 <= alu_O_i;
		alu_key_o <= 0;
		co_o <= u0;
		state <= 0;
	end
end

endmodule

`endif
