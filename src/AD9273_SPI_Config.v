module AD9273_SPI_Config(
	input RST_n,
	input SPI_CLK,
	inout SPI_Data,
	output SPI_CS
);

parameter 
	CHIP_PORT_CONFIG 	= 8'h18,
	CHIP_ID				= 8'h2F,
	CHIP_GRADE			= 8'h10,
	DEVICE_INDEX2		= 8'h0F,
	DEVICE_INDEX1		= 8'h0F,  //no INCLUDE dco and fco 
	DEVICE_UPDATE_EN	= 8'h01,
	DEVICE_UPDATE_DIS	= 8'h00,	
	Modes				   = 8'h00,
	Clock			   	= 8'h01,
	TEST_IO				= 8'h00,  //mi
	FLEX_CHANNEL_INPUT= 8'h0E,  //antialias filter 0.7*1/4.5 Fsampling
	FLEX_OFFSET			= 8'h20,
	FLEX_GAIN			= 8'h0E,  //PGA:30db,LNA 21.3db
	BIAS_CURRENT		= 8'h08,
	OUTPUT_MODE			= 8'h00,  //complement output
	OUTPUT_ADJUST		= 8'h31,
	OUTPUT_PHASE		= 8'h03,  //
	FLEX_VREF			= 8'h00,
	USER_PATT1_LSB		= 8'h00,
	USER_PATT1_MSB		= 8'h00,
	USER_PATT2_LSB		= 8'h00,
	USER_PATT2_MSB		= 8'h00,	
	SERIAL_CONTROL		= 8'h00,
	SERIAL_CH_STAT		= 8'h00,
	FLEX_FILTER			= 8'h00,   //flp/20.7
	ANALOG_INPUT		= 8'h01,   //LOSW-x connect to LNA -output
	CROSS_POINT_SWITCH  = 8'h00,
	DELAY_A				= 8'h03,  //180degree
	DELAY_B				= 8'h03,  //180degree
	DELAY_C				= 8'h03,  //180degree
	DELAY_D				= 8'h03,  //180degree
	DELAY_E				= 8'h03,  //180degree
	DELAY_F				= 8'h03,  //180degree
	DELAY_G				= 8'h03,  //180degree
	DELAY_H				= 8'h03;  //180degree

				
						
	

		

    reg [12:0] SPI_Addr;
    reg [3:0]  SPI_STAT;
    reg [7:0]  Addr_Counter;
    reg [7:0]  SND_DATA;
    reg        SPI_New_Word;
    reg        SPI_RW ;//= 1'b1;
    wire       SPI_Over;
    
    parameter
		SPI_PR	 = 4'd0,
		SPI_REQ   = 4'd1,
		SPI_WAIT  = 4'd2,
		SPI_END   = 4'd3;				
		
	always @(posedge SPI_CLK or negedge RST_n) 
	begin
		if(~RST_n) 
		   begin
			SPI_Addr     <= 8'd0; 
			SPI_STAT     <= 4'd0;
			Addr_Counter <= 13'd0;
			SPI_New_Word <= 1'b0;
			SPI_STAT     <= SPI_PR;
		   end
		else 
		 begin
			if(Addr_Counter <= 8'd24) 
			 begin
				case(SPI_STAT)
				SPI_PR:  begin
					case(Addr_Counter) 
					8'd0: begin
						SPI_Addr <= 8'h00;
						SND_DATA <= CHIP_PORT_CONFIG;
						SPI_STAT <= SPI_REQ;
						SPI_New_Word <= 1'b1;
						
					end
					8'd1: begin
						SPI_Addr <= 8'h01;
						SND_DATA <= CHIP_ID;
						SPI_STAT <= SPI_REQ;
						SPI_New_Word <= 1'b1;
					end
					8'd2: begin
						SPI_Addr <= 8'h02;
						SND_DATA <= CHIP_GRADE;
						SPI_STAT <= SPI_REQ;
						SPI_New_Word <= 1'b1;
					end										
					8'd3: begin
						SPI_Addr <= 8'h04;
						SND_DATA <= DEVICE_INDEX2;
						SPI_STAT <= SPI_REQ;
						SPI_New_Word <= 1'b1;
					end										
					8'd4: begin
						SPI_Addr <= 8'h05;
						SND_DATA <= DEVICE_INDEX1;
						SPI_STAT <= SPI_REQ;
						SPI_New_Word <= 1'b1;
					end	
															
					8'd5: begin
						SPI_Addr <= 8'h08;
						SND_DATA <= Modes;
						SPI_STAT <= SPI_REQ;
						SPI_New_Word <= 1'b1;
					end										
					8'd6: begin
						SPI_Addr <= 8'h09;
						SND_DATA <= Clock;
						SPI_STAT <= SPI_REQ;
						SPI_New_Word <= 1'b1;
					end										
					8'd7: begin
						SPI_Addr <= 8'h0D;
						SND_DATA <= TEST_IO;
						SPI_STAT <= SPI_REQ;
						SPI_New_Word <= 1'b1;
					end										
					8'd8: begin
						SPI_Addr <= 8'h0F;
						SND_DATA <= FLEX_CHANNEL_INPUT;
						SPI_STAT <= SPI_REQ;
						SPI_New_Word <= 1'b1;
					end										
					8'd9: begin
						SPI_Addr <= 8'h10;
						SND_DATA <= FLEX_OFFSET;
						SPI_STAT <= SPI_REQ;
						SPI_New_Word <= 1'b1;
					end										
					8'd10: begin
						SPI_Addr <= 8'h11;
						SND_DATA <= FLEX_GAIN;
						SPI_STAT <= SPI_REQ;
						SPI_New_Word <= 1'b1;
					end		
					

													
					8'd11: begin
						SPI_Addr <= 8'h12;
						SND_DATA <= BIAS_CURRENT;
						SPI_STAT <= SPI_REQ;
						SPI_New_Word <= 1'b1;
					end										
					8'd12: begin
						SPI_Addr <= 8'h14;
						SND_DATA <= OUTPUT_MODE;
						SPI_STAT <= SPI_REQ;
						SPI_New_Word <= 1'b1;
					end										
					8'd13: begin
						SPI_Addr <= 8'h15;
						SND_DATA <= OUTPUT_ADJUST;
						SPI_STAT <= SPI_REQ;
						SPI_New_Word <= 1'b1;
					end										
					8'd14: begin
						SPI_Addr <= 8'h16;
						SND_DATA <= OUTPUT_PHASE;
						SPI_STAT <= SPI_REQ;
						SPI_New_Word <= 1'b1;
					end		

																
					8'd15: begin
						SPI_Addr <= 8'h19;
						SND_DATA <= USER_PATT1_LSB;
						SPI_STAT <= SPI_REQ;
						SPI_New_Word <= 1'b1;
					end										
					8'd16: begin
						SPI_Addr <= 8'h1A;
						SND_DATA <= USER_PATT1_MSB;
						SPI_STAT <= SPI_REQ;
						SPI_New_Word <= 1'b1;
					end										
					8'd17: begin
						SPI_Addr <= 8'h1B;
						SND_DATA <= USER_PATT2_LSB;
						SPI_STAT <= SPI_REQ;
						SPI_New_Word <= 1'b1;
					end										
					8'd18: begin
						SPI_Addr <= 8'h1C;
						SND_DATA <= USER_PATT2_MSB;
						SPI_STAT <= SPI_REQ;
						SPI_New_Word <= 1'b1;
					end										
					8'd19: begin
						SPI_Addr <= 8'h21;
						SND_DATA <= SERIAL_CONTROL;
						SPI_STAT <= SPI_REQ;
						SPI_New_Word <= 1'b1;
					end										
					8'd20: begin
						SPI_Addr <= 8'h22;
						SND_DATA <= SERIAL_CH_STAT;
						SPI_STAT <= SPI_REQ;
						SPI_New_Word <= 1'b1;
					end										
					8'd21: begin
						SPI_Addr <= 8'h2B;
						SND_DATA <= FLEX_FILTER;
						SPI_STAT <= SPI_REQ;
						SPI_New_Word <= 1'b1;
					end										
					8'd22: begin
						SPI_Addr <= 8'h2C;
						SND_DATA <= ANALOG_INPUT;
						SPI_STAT <= SPI_REQ;
						SPI_New_Word <= 1'b1;
					end										
					8'd23: begin
						SPI_Addr <= 8'h2D;
						SND_DATA <= CROSS_POINT_SWITCH;
						SPI_STAT <= SPI_REQ;
						SPI_New_Word <= 1'b1;
					end	
					

					8'd24: begin
						SPI_Addr <= 8'hFF;
						SND_DATA <= DEVICE_UPDATE_EN;
						SPI_STAT <= SPI_REQ;
						SPI_New_Word <= 1'b1;
					end			

					

							/*	
																		
					8'd15: begin
						SPI_Addr <= 8'h18;
						SND_DATA <= FLEX_VREF;
						SPI_STAT <= SPI_REQ;
						SPI_New_Word <= 1'b1;
					end				
					
					*/

					/*
					// delay for ch A
					8'd27: begin
						SPI_Addr <= 8'h04;
						SND_DATA <= 8'h00;
						SPI_STAT <= SPI_REQ;
						SPI_New_Word <= 1'b1;
					end										
					8'd28: begin
						SPI_Addr <= 8'h05;
						SND_DATA <= 8'h0F;
						SPI_STAT <= SPI_REQ;
						SPI_New_Word <= 1'b1;
					end																		
					8'd29: begin
						SPI_Addr <= 8'h16;
						SND_DATA <= DELAY_A;
						SPI_STAT <= SPI_REQ;
						SPI_New_Word <= 1'b1;
					end		
					
					8'd30: begin
						SPI_Addr <= 8'hFF;
						SND_DATA <= DEVICE_UPDATE_EN;
						SPI_STAT <= SPI_REQ;
						SPI_New_Word <= 1'b1;
					end			
					8'd31: begin
						SPI_Addr <= 8'hFF;
						SND_DATA <=DEVICE_UPDATE_DIS; 
						SPI_STAT <= SPI_REQ;
						SPI_New_Word <= 1'b1;
					end						
					*/			
						
					
					default: begin
						SPI_Addr <= 8'h01;
						SND_DATA <= CHIP_ID;   //read only
						//Addr_Counter <= 8'd0;     //continue 
						SPI_RW <= ~SPI_RW;
						SPI_STAT <= SPI_PR;
						SPI_New_Word <= 1'b0;
					end	
																	
				endcase
				end
				
				SPI_REQ:begin
					SPI_New_Word <= 1'b0;
					SPI_STAT <= SPI_WAIT; 
				end
				
				SPI_WAIT:begin
					if(SPI_Over) begin
						SPI_STAT <= SPI_END; 
					end
				end
				
				SPI_END:begin
					SPI_STAT <= SPI_PR; 
					Addr_Counter <= Addr_Counter + 1'b1;
				end
				
				default:begin
					SPI_STAT <= SPI_PR; 
				end
				
			endcase
		end
		else begin
	
			SPI_Addr <= 8'd0; 
			SPI_STAT <= SPI_PR; 
			SPI_New_Word <= 1'b0;
			SPI_STAT <= SPI_PR;
		end
	end
	end



	SPI_AD SPI_AD_Inst(
		.SPI_CLK(SPI_CLK),
		.New_Word(SPI_New_Word),
		.Addr({5'b0,SPI_Addr}),
		.Data(SND_DATA),
		.q(),
		.RW(SPI_RW),           //1 Write; 0 :read
		.SPI_CS(SPI_CS),
		.SPI_Data(SPI_Data),
		.Over(SPI_Over)
	);





endmodule
