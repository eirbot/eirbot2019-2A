/*
 * Speed block module
 * TODO
 * Tests
 */

`ifndef SPEEDBLOCK_V
`define SPEEDBLOCK_V

`include "src/config.vh"
`include "lib/counter.v"
`include "lib/LMD18200.v"
`include "lib/qei.v"

module speedblock #(
	parameter clk_freq = `CLK_FREQ,
	parameter pid_freq = `PID_SPEED_FREQ,
	parameter pwm_freq = `PWM_FREQ,
	parameter pid_res = `PID_RES,
	parameter pwm_res = `PWM_RES,
	parameter qei_res = `QEI_RES
)(
	// Global inputs
	input clk,
	input rst,
	input clr,
	input en,
	// Inputs
	input [pid_res-1:0] speedL_i,
	input [pid_res-1:0] speedR_i,
	input qeiLA_i,
	input qeiLB_i,
	input qeiRA_i,
	input qeiRB_i,
	// Outputs
	output pwmL_o,
	output pwmR_o,
	output dirL_o,
	output dirR_o,
	output brL_o,
	output brR_o,
	// ALU connections
	input [`KEY_SIZE-1:0] alu_key_i,
	input signed [`OPERAND_SIZE-1:0] alu_O_i,
	output [2*`KEY_SIZE-1:0] alu_key_o,
	output [2*`OPCODE_SIZE-1:0] alu_op_o,
	output signed [2*`OPERAND_SIZE-1:0] alu_A_o,
	output signed [2*`OPERAND_SIZE-1:0] alu_B_o
);

/* PID signals */
wire pid_en;
wire [pid_res-1:0] coL_o;
wire [pid_res-1:0] coR_o;
reg [pid_res-1:0] pv_L;
reg [pid_res-1:0] pv_R;
/* PWM signals */
wire [pwm_res:0] pwmL_i = {coL_o[`OPERAND_SIZE-1], coL_o[15:15-pwm_res+1]};
wire [pwm_res:0] pwmR_i = {coR_o[`OPERAND_SIZE-1], coR_o[15:15-pwm_res+1]};
/* QEI signals */
reg qeiL_clr;
wire [qei_res-1:0] qeiL_o;
reg qeiR_clr;
wire [qei_res-1:0] qeiR_o;


/* ALU connections */
// For pidL
wire [`KEY_SIZE-1:0] pidL_key_o;
wire [`OPCODE_SIZE-1:0] pidL_op_o;
wire [`OPERAND_SIZE-1:0] pidL_A_o;
wire [`OPERAND_SIZE-1:0] pidL_B_o;
wire [`KEY_SIZE-1:0] pidL_key_i;
wire [`OPERAND_SIZE-1:0] pidL_O_i;
// For pidR
wire [`KEY_SIZE-1:0] pidR_key_o;
wire [`OPCODE_SIZE-1:0] pidR_op_o;
wire [`OPERAND_SIZE-1:0] pidR_A_o;
wire [`OPERAND_SIZE-1:0] pidR_B_o;
wire [`KEY_SIZE-1:0] pidR_key_i;
wire [`OPERAND_SIZE-1:0] pidR_O_i;
// For speedblock pors
//assign alu_key_i = {pidL_key_i, pidR_key_i};
//assign alu_O_i = {pidL_O_i, pidR_O_i};
assign alu_key_o = {pidL_key_o, pidR_key_o};
assign alu_op_o = {pidL_op_o, pidR_op_o};
assign alu_A_o = {pidL_A_o, pidR_A_o};
assign alu_B_o = {pidL_B_o, pidR_B_o};

localparam pid_clk_max = $rtoi($floor(clk_freq/pid_freq));
localparam pid_clk_nbits = $clog2(pid_clk_max+1);
counter #(
	.nbits(pid_clk_nbits),
	.min(0),
	.max(pid_clk_max),
	.step(1)
) m_clk_pid (
	.clk(clk),
	.rst(rst),
	.clr(1'b0),
	.en(en),
	.count(),
	.overflow(pid_en)
);

LMD18200 #(
	.freq(pwm_freq),
	.nbits(pwm_res+1),
	.dir_motor(`DIR_MOTOR_L)
) m_LMD18200L (
	.clk(clk),
	.rst(rst),
	.en(en),
	.pwm_i(pwmL_i),
	.pwm_o(pwmL_o),
	.dir_o(dirL_o),
	.br_o(brL_o)
);

LMD18200 #(
	.freq(pwm_freq),
	.nbits(pwm_res+1),
	.dir_motor(`DIR_MOTOR_R)
) m_LMD18200R (
	.clk(clk),
	.rst(rst),
	.en(en),
	.pwm_i(pwmR_i),
	.pwm_o(pwmR_o),
	.dir_o(dirR_o),
	.br_o(brR_o)
);

qei #(
	.nbits(qei_res)
) m_qeiL (
	.clk(clk),
	.rst(rst),
	.clr(qeiL_clr),
	.en(en),
	.A_i(qeiLA_i),
	.B_i(qeiLB_i),
	.qei_o(qeiL_o)
);

qei #(
	.nbits(qei_res)
) m_qeiR (
	.clk(clk),
	.rst(rst),
	.clr(qeiR_clr),
	.en(en),
	.A_i(qeiRA_i),
	.B_i(qeiRB_i),
	.qei_o(qeiR_o)
);

pid #(
	.nbits(pid_res),
	.base_key(`PIDL_BASE_KEY)
) m_pidL (
	.clk(clk),
	.rst(rst),
	.clr(1'b0),
	.en(pid_en),
	.sp_i(speedL_i),
	.pv_i(pv_L),
	.co_o(coL_o),
	.alu_key_i(alu_key_i),
	.alu_O_i(alu_O_i),
	.alu_key_o(pidL_key_o),
	.alu_op_o(pidL_op_o),
	.alu_A_o(pidL_A_o),
	.alu_B_o(pidL_B_o)
);

pid #(
	.nbits(pid_res),
	.base_key(`PIDR_BASE_KEY)
) m_pidR (
	.clk(clk),
	.rst(rst),
	.clr(1'b0),
	.en(pid_en),
	.sp_i(speedR_i),
	.pv_i(pv_R),
	.co_o(coR_o),
	.alu_key_i(alu_key_i),
	.alu_O_i(alu_O_i),
	.alu_key_o(pidR_key_o),
	.alu_op_o(pidR_op_o),
	.alu_A_o(pidR_A_o),
	.alu_B_o(pidR_B_o)
);

always @(posedge clk) begin
	if (rst) begin
		pv_L <= pid_res'h00000000;
		pv_R <= pid_res'h00000000;
		qeiL_clr <= 1'b0;
		qeiR_clr <= 1'b0;
	end else if (pid_en) begin
		pv_L <= {{(pid_res-qei_res){qeiL_o[qei_res-1]}}, qeiL_o};
		pv_R <= {{(pid_res-qei_res){qeiR_o[qei_res-1]}}, qeiR_o};
		qeiL_clr <= 1'b1;
		qeiR_clr <= 1'b1;
	end else begin
		qeiL_clr <= 1'b0;
		qeiR_clr <= 1'b0;
	end
end

endmodule

`endif
