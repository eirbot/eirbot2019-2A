/*
 * PWM generator module
 * TODO
 * Documentation
 */

`include "config.vh"

module pwm #(
	parameter freq = `PWM_FREQ,
	parameter nbits = `PWM_RES
)(
	input clk,
	input rst,
	input en,
	input [nbits-1:0] in,
	output reg out
);

localparam nbits_pwm = nbits;
localparam max_pwm = 2**nbits_pwm-1;
localparam max_clk_divider = $rtoi($floor(48000000/(freq*(2**nbits_pwm)))-1);
localparam nbits_clk_divider = $clog2(max_clk_divider+1);

wire counter_en;
wire [nbits_pwm-1:0] count;

generate
	if (max_clk_divider >= 0)
	begin
		counter #(
			.nbits(nbits_clk_divider),
			.min(0),
			.max(max_clk_divider),
			.step(1)
		) clk_divider (
			.clk(clk),
			.rst(rst),
			.clr(1'b0),
			.en(en),
			.count(),
			.overflow(counter_en)
		);

		counter #(
			.nbits(nbits_pwm),
			.min(0),
			.max(max_pwm),
			.step(1)
		) counter_pwm (
			.clk(clk),
			.rst(rst),
			.clr(1'b0),
			.en(counter_en),
			.count(count),
			.overflow()
		);

		always @(posedge clk)
		begin
			if (rst || !en) begin
				out <= 0;
			end else begin
				out <= (count<in) ? 1'b1 : 1'b0;
			end
		end

	end
	else
	begin
		initial
		begin
			$display("pwm: Invalid parameters");
			$display("frequency too high for precision");
			$finish(1);
		end
	end
endgenerate

endmodule
