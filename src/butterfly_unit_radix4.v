`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:32:42 03/12/2013 
// Design Name: 
// Module Name:    butterfly_unit_radix4 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module butterfly_unit_radix4(
											input clk,
											
											input[15:0] cos0,
											input[15:0] sin0,
											input[15:0] cos1,
											input[15:0] sin1,
											input[15:0] cos2,
											input[15:0] sin2,
											
											input[15:0] x1_re,
											input[15:0] x1_im,
											input[15:0] x2_re,
											input[15:0] x2_im,
											input[15:0] x3_re,
											input[15:0] x3_im,
											input[15:0] x4_re,
											input[15:0] x4_im,
											
											output[15:0] p1_re,
											output[15:0] p1_im,
											output[15:0] p2_re,
											output[15:0] p2_im,
											output[15:0] p3_re,
											output[15:0] p3_im,
											output[15:0] p4_re,
											output[15:0] p4_im
								  );
	/**�˷����**/
	wire[15:0] X2_re;
	wire[15:0] X2_im;
	wire[15:0] X3_re;
	wire[15:0] X3_im;
	wire[15:0] X4_re;
	wire[15:0] X4_im;
	/**end**/
	
	reg[15:0] X1_re_reg0 = 16'd0;
	reg[15:0] X1_re_reg1 = 16'd0;
	reg[15:0] X1_re_reg2 = 16'd0;
	reg[15:0] X1_re_reg3 = 16'd0;
	reg[15:0] X1_re_reg4 = 16'd0;
	reg[15:0] X1_re_reg5 = 16'd0;
	
	reg[15:0] X1_im_reg0 = 16'd0;
	reg[15:0] X1_im_reg1 = 16'd0;
	reg[15:0] X1_im_reg2 = 16'd0;
	reg[15:0] X1_im_reg3 = 16'd0;
	reg[15:0] X1_im_reg4 = 16'd0;
	reg[15:0] X1_im_reg5 = 16'd0;
	
	always @(posedge clk)
	begin
		X1_re_reg0 <= x1_re;
		X1_im_reg0 <= x1_im;

		X1_re_reg1 <= X1_re_reg0;
		X1_im_reg1 <= X1_im_reg0;

		X1_re_reg2 <= X1_re_reg1;
		X1_im_reg2 <= X1_im_reg1;
		
		X1_re_reg3 <= X1_re_reg2;
		X1_im_reg3 <= X1_im_reg2;
		
		X1_re_reg4 <= X1_re_reg3;
		X1_im_reg4 <= X1_im_reg3;
		
		X1_re_reg5 <= X1_re_reg4;
		X1_im_reg5 <= X1_im_reg4;
	end
	
	complex_mul inst0_complex_mul(
												.clk(clk),
												.ar(cos0),
												.ai(sin0),
												.br(x2_re),
												.bi(x2_im),
												
												.pr(X2_re),
												.pi(X2_im)
											);
	complex_mul inst1_complex_mul(
												.clk(clk),
												.ar(cos1),
												.ai(sin1),
												.br(x3_re),
												.bi(x3_im),
												
												.pr(X3_re),
												.pi(X3_im)
											);
	complex_mul inst2_complex_mul(
												.clk(clk),
												.ar(cos2),
												.ai(sin2),
												.br(x4_re),
												.bi(x4_im),
												
												.pr(X4_re),
												.pi(X4_im)
											);
	complex_add_radix_4 inst_complex_add_radix_4(
																	.clk(clk),
																	.x1_re(X1_re_reg5),
																	.x1_im(X1_im_reg5),
																	.x2_re(X2_re),
																	.x2_im(X2_im),
																	.x3_re(X3_re),
																	.x3_im(X3_im),
																	.x4_re(X4_re),
																	.x4_im(X4_im),
																	
																	.re_0(p1_re),
																	.im_0(p1_im),
																	.re_1(p2_re),
																	.im_1(p2_im),
																	.re_2(p3_re),
																	.im_2(p3_im),
																	.re_3(p4_re),
																	.im_3(p4_im)
																);
endmodule
