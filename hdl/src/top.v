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
	output pwmR_o,
	output dirL_o,
	output dirR_o,
	output brL_o,
	output brR_o
);

// CLK wires
wire clk;

// ALU wires
wire [`KEY_SIZE-1:0] alu_key_o;
wire [`OPERAND_SIZE-1:0] alu_O_o;
wire [`KEY_SIZE-1:0] alu_key_i;
wire [`OPCODE_SIZE-1:0] alu_op_i;
wire [`OPERAND_SIZE-1:0] alu_A_i;
wire [`OPERAND_SIZE-1:0] alu_B_i;

// Speedblock to mux
wire [2*`KEY_SIZE-1:0] speedblock_mux_key;
wire [2*`OPCODE_SIZE-1:0] speedblock_mux_op;
wire [2*`OPERAND_SIZE-1:0] speedblock_mux_A;
wire [2*`OPERAND_SIZE-1:0] speedblock_mux_B;

/* CLK generator */
SB_HFOSC inthosc (
	.CLKHFPU(1'b1),
	.CLKHFEN(1'b1),
	.CLKHF(clk)
);

/* RGB LED */
reg [3*`LED_NBPC-1:0] rgb = 24'h040404;
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

/* ALU mux */
keymux #(
	.ninputs(2)
) m_keymux (
	.clk(clk),
	.rst(rst),
	.op_i(speedblock_mux_op),
	.key_i(speedblock_mux_key),
	.A_i(speedblock_mux_A),
	.B_i(speedblock_mux_B),
	.keyback_i(alu_key_o),
	.op_o(alu_op_i),
	.key_o(alu_key_i),
	.A_o(alu_A_i),
	.B_o(alu_B_i)
);

/* ALU */
alu32 #(
	.addsuber(1),
	.multiplier(1)
) m_alu32 (
	.clk(clk),
	.rst(rst),
	.clr(1'b0),
	.en(1'b1),
	.op(alu_op_i),
	.key_in(alu_key_i),
	.inA(alu_A_i),
	.inB(alu_B_i),
	.out(alu_O_o),
	.key_out(alu_key_o)
);

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
	.speedL_i(32'd50),
	.speedR_i(32'd50),
	.qeiLA_i(qeiLA_i),
	.qeiLB_i(qeiLB_i),
	.qeiRA_i(qeiRA_i),
	.qeiRB_i(qeiRB_i),
	.pwmL_o(pwmL_o),
	.pwmR_o(pwmR_o),
	.dirL_o(dirL_o),
	.dirR_o(dirR_o),
	.brL_o(brL_o),
	.brR_o(brR_o),
	.alu_key_i(alu_key_o),
	.alu_O_i(alu_O_o),
	.alu_key_o(speedblock_mux_key),
	.alu_op_o(speedblock_mux_op),
	.alu_A_o(speedblock_mux_A),
	.alu_B_o(speedblock_mux_B)
);

endmodule
