/*
 * Top module
 * TODO
 * Documentation
 */

`include "src/config.vh"
`include "lib/counter.v"
`include "lib/pid.v"
`include "lib/pwm.v"
`include "lib/qei.v"
`include "lib/rgb.v"
`include "lib/alu32.v"
`include "lib/keymux.v"
`include "lib/speedblock.v"

module top(
	// Global inputs
	input rst,
	// QEI inputs
	input qeiLA_i,
	input qeiLB_i,
	input qeiRA_i,
	input qeiRB_i,
	// LED outputs
	output R_o,
	output G_o,
	output B_o,
	// Motor outputs
	output pwmL_o,
	output pwmR_o
);

/* clk generator */
wire clk;
SB_HFOSC inthosc (
	.CLKHFPU(1'b1),
	.CLKHFEN(1'b1),
	.CLKHF(clk)
);

/* RGB LED */
reg [3*`LED_NBPC-1:0] rgb;
rgb #(
	.nbpc(`LED_NBPC)
) m_rgb (
	.clk(clk),
	.rst(rst),
	.en(1'b1),
	.rgb_i(rgb),
	.R_o(R_o),
	.G_o(G_o),
	.B_o(B_o)
);

/* Speed block */
wire [2*`KEY_SIZE-1:0] speedblock_alu_key_i;
wire [2*`OPERAND_SIZE-1:0] speedblock_alu_O_i;
wire [2*`KEY_SIZE-1:0] speedblock_alu_key_o;
wire [2*`OPCODE_SIZE-1:0] speedblock_alu_op_o;
wire [2*`OPERAND_SIZE-1:0] speedblock_alu_A_o;
wire [2*`OPERAND_SIZE-1:0] speedblock_alu_B_o;
speedblock #(
	.clk_freq(`CLK_FREQ),
	.pid_freq(`PID_SPEED_FREQ),
	.pwm_freq(`PWM_FREQ),
	.pid_res(`PID_RES),
	.pwm_res(`PWM_RES),
	.qei_res(`QEI_RES)
) m_speedblock (
	.clk(clk),
	.rst(rst),
	.clr(1'b0),
	.en(1'b1),
	.speedL_i(),
	.speedR_i(),
	.qeiLA_i(qeiLA_i),
	.qeiLB_i(qeiLB_i),
	.qeiRA_i(qeiRA_i),
	.qeiRB_i(qeiRB_i),
	.pwmL_o(pwmL_o),
	.pwmR_o(pwmR_o),
	.alu_key_i(speedblock_alu_key_i),
	.alu_O_i(speedblock_alu_O_i),
	.alu_key_o(speedblock_alu_key_o),
	.alu_op_o(speedblock_alu_op_o),
	.alu_A_o(speedblock_alu_A_o),
	.alu_B_o(speedblock_alu_B_o)
);

`define INA 32'hffc6b000
`define INB 32'hffd4d800

wire [31:0] aluO;
wire [`KEY_SIZE-1:0] key2;
wire [`OPCODE_SIZE-1:0] op1;
wire [`KEY_SIZE-1:0] key1;
wire [31:0] a1;
wire [31:0] b1;

keymux #(
	.ninputs(2)
) m_keymux (
	.clk(clk),
	.rst(rst),
	.op_i({`MUL, `ADD}),
	.key_i({4'h4, 4'h5}),
	.A_i({`INA, `INB}),
	.B_i({`INB, `INA}),
	.keyback_i(key2),
	.op_o(op1),
	.key_o(key1),
	.A_o(a1),
	.B_o(b1)
);

alu32 #(
	.addsuber(1),
	.multiplier(1)
) m_alu32 (
	.clk(clk),
	.rst(rst),
	.clr(1'b0),
	.en(1'b1),
	.op(op1),
	.key_in(key1),
	.inA(a1),
	.inB(b1),
	.out(aluO),
	.key_out(key2)
);

always @(posedge clk) begin
	if (rst) begin
		rgb <= 24'h000000;
/*
	end else if (keyO == 8'h05) begin
		if (aluO == 32'hff9b8800) begin
			rgb <= 24'h000800;
		end else if (aluO == 32'hfff1d800) begin
			rgb <= 24'h000008;
		end else if (aluO == 32'h09a96480) begin
			rgb <= 24'h00f0f0;
*/
	end else if (key2 == 8'h5 && aluO == 32'hff9b8800) begin
			rgb <= 24'h000800;
	end else if (key2 == 8'h4 && aluO == 32'h09a96480) begin
			rgb <= 24'h000080;
	end else if (key2 != 8'h0) begin
		rgb <= 24'hff0000;
	end else begin
		rgb <= 24'h000000;
	end
end

endmodule
