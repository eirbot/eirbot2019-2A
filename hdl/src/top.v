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

module top(
	// Global inputs
	input rst,
	// QEI inputs
	input qeiL_A,
	input qeiL_B,
	input qeiR_A,
	input qeiR_B,
	// LED outputs
	output ledR,
	output ledG,
	output ledB,
	// Motor outputs
	output pwmL,
	output pwmR
);

// Global signals
wire clk;

//assign led_o = leds;
wire [`QEI_RES-1:0] qeiL;
wire [`QEI_RES-1:0] qeiR;

// Tests
reg [23:0] Irgb;

// Internal oscillator to generate clock
SB_HFOSC inthosc (
	.CLKHFPU(1'b1),
	.CLKHFEN(1'b1),
	.CLKHF(clk)
);

// RGB LED
rgb #(
	.nbpc(`LED_NBPC)
) rgb (
	.clk(clk),
	.rst(rst),
	.en(1'b1),
	.in(Irgb),
	.ledR(ledR),
	.ledG(ledG),
	.ledB(ledB)
);

pwm #(
	.freq(`PWM_FREQ),
	.nbits(`PWM_RES)
) m_pwmL (
	.clk(clk),
	.rst(rst),
	.en(1'b1),
	.in(10'd2**9),
	.out(pwmL)
);

// PWM
pwm #(
	.freq(`PWM_FREQ),
	.nbits(`PWM_RES)
) m_pwmR (
	.clk(clk),
	.rst(rst),
	.en(1'b1),
	.in(10'd2**9),
	.out(pwmR)
);

// QEI
qei #(
	.nbits(`QEI_RES)
) m_qeiL (
	.clk(clk),
	.rst(rst),
	.clr(1'b0),
	.en(1'b1),
	.in_A(qeiL_A),
	.in_B(qeiL_B),
	.val(qeiL)
);

qei #(
	.nbits(`QEI_RES)
) m_qeiR (
	.clk(clk),
	.rst(rst),
	.clr(1'b0),
	.en(1'b1),
	.in_A(qeiR_A),
	.in_B(qeiR_B),
	.val(qeiR)
);

`define INA 32'hffc6b000
`define INB 32'hffd4d800

wire [31:0] aluO;
wire [7:0] key2;
wire [7:0] op1;
wire [7:0] key1;
wire [31:0] a1;
wire [31:0] b1;

keymux #(
	.ninputs(1)
) m_keymux (
	.clk(clk),
	.rst(rst),
	.op_i({`MUL, `ADD}),
	.key_i({8'h04, 8'h05}),
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
		Irgb <= 24'h000000;
/*
	end else if (keyO == 8'h05) begin
		if (aluO == 32'hff9b8800) begin
			Irgb <= 24'h000800;
		end else if (aluO == 32'hfff1d800) begin
			Irgb <= 24'h000008;
		end else if (aluO == 32'h09a96480) begin
			Irgb <= 24'h00f0f0;
*/
	end else if (key2 == 8'h05 && aluO == 32'hff9b8800) begin
			Irgb <= 24'h000800;
	end else if (key2 == 8'h04 && aluO == 32'h09a96480) begin
			Irgb <= 24'h00f0f0;
	end else if (key2 != 8'h00) begin
		Irgb <= 24'hff0000;
	end else begin
		Irgb <= 24'h000000;
	end
end

endmodule
