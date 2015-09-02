module DSC(
	LCLK,
	Row,
	Column,
	SRAM_Addr,
	Inter_Ratio1,
	Inter_Ratio2,
	DeadZone,
	IN_Region,
	Real_X,
	Real_Y,
	DSC_ANGLE

);

	input LCLK;
	input [9:0] Row;
	input [9:0] Column;
	output reg [18:0] SRAM_Addr;
	output reg [7:0] Inter_Ratio1;
	output reg [7:0] Inter_Ratio2;
	input [7:0] DeadZone;
	output reg IN_Region;
	output reg [17:0] Real_X;
	output reg [14:0] Real_Y;
	input [15:0] DSC_ANGLE;
	
	reg signed [19:0] realIn;
	reg signed [19:0] imagIn;
	wire signed [14:0] Angle;
	wire signed [21:0] Amp; 	
	
	

	
	
	//attention  :
	// amplitude = 1.647*trueAmp
	// Angle :  2500=90degree  80degree =128lines  1lines 512 samples
	wire signed [14:0] SHADOW_ANGLE;	
	wire signed [14:0] Angle_pos;
	//assign Angle_pos = Angle+2500;
	
	assign Angle_pos = Angle + DSC_ANGLE[14:0];//�Ƕȴ���90�㣬�Է����ȡ��ʹ���صĸ��Ų�����
    assign SHADOW_ANGLE = DSC_ANGLE[14:0] - 14'd100;  //-100	
	
	always @(posedge LCLK) begin
		Real_X <=   Amp*128/211;       //  amp*2/256/1.647  
		Real_Y <=   Angle_pos*256*64/DSC_ANGLE[14:0];   //(Angle+2500)*128*256/5000=(Angle+2500)*256/39
		Inter_Ratio1 <=Real_Y[7:0];
		Inter_Ratio2 <=Real_X[7:0];
		IN_Region <= (Angle[14]?(Angle>-SHADOW_ANGLE):(Angle<SHADOW_ANGLE)) && (Real_X[17:8] <10'd255+DeadZone) && (Real_X[17:8] > DeadZone) && (Column>10'd12 && Column<10'd321)  ; //+-45degree

		SRAM_Addr[18:8]<= {3'b0,Real_Y[14:8]};
		SRAM_Addr[7:0] <=(Real_X[17:8]>DeadZone)?({Real_X[17:8]}-DeadZone):9'd0;
				
		realIn <= {(Row +DeadZone),8'd0};
		imagIn <= {Column,8'd0}+{-12'd156,8'b1111_1111};		
	end	
	
	
	coordinate_cordic coordinate_cordic_Inst
	(
		.realIn(realIn),
		.imagIn(imagIn),
		.clk(LCLK),
		.amplitude(Amp),
		.angle(Angle),
		.test1(),
		.test2()
	);



 

endmodule
