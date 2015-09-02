module Receive(
	input             AD_CLK,
	input [11:0]      Data_A,Data_B,Data_C,Data_D,Data_E,Data_F,Data_G,Data_H,
	input [7:0]       Line_Num,         //Line Num,256 Lines totally,0~255
	input [1:0]       Focus_Num,        //Focus_num ,4 totally
	input             Pr_Gate,          //prepare for everythings
	input             RX_Gate,          // Start Transmit
	input             Sample_Gate,
	input             End_Gate,
	output reg        So_Gate,         //output Enable
	output reg [14:0] DAS_Value,
	output [7:0]      Coheren_Coff

);
  
  
	reg [15:0] Wr_addr;
	
	reg [15:0] Rd_addr;
	
	reg        Wr_En;
	
	localparam  MAX_COARSE_DELAY = 16'd400;
		

		
	always @(posedge AD_CLK or posedge Sample_Gate) begin  //
		if(Sample_Gate)
	   	begin
			  Wr_addr <= 16'd2;
			  Wr_En <= 1'b0;
		   end
		else begin
		    
			if(Wr_addr <= 16'd15000) begin                 //  300us
			 	 Wr_En <= 1'b1;
				if(End_Gate) 
					Wr_addr <= 16'd16000;
				else
					Wr_addr <= Wr_addr + 1'b1;
			end
			else begin
					
				Wr_En <= 1'b0;
			end
			
			if(Wr_addr >MAX_COARSE_DELAY && Wr_addr <= 16'd15000) begin
				So_Gate <= 1'b1;
			end
			else begin
				So_Gate <= 1'b0;
			end	
			
				
		end
	end
	
	
	reg [15:0] Rd_Addr1;
	
	reg [15:0] Rd_Addr2;
	
	reg [15:0] Rd_Addr3;
	
	reg [15:0] Rd_Addr4;
	
	reg [15:0] Rd_Addr5;
	
	reg [15:0] Rd_Addr6;
	
	reg [15:0] Rd_Addr7;
	
	reg [15:0] Rd_Addr8;
	
	wire [12:0] AD_CH1;
	
	wire [12:0] AD_CH2;
	
	wire [12:0] AD_CH3;
	
	wire [12:0] AD_CH4;
	
	wire [12:0] AD_CH5;
	
	wire [12:0] AD_CH6;
	
	wire [12:0] AD_CH7;
	
	wire [12:0] AD_CH8;		

	reg [20:0] AD_CH1_Valid;
	
	reg [20:0] AD_CH2_Valid;
	
	reg [20:0] AD_CH3_Valid;
	
	reg [20:0] AD_CH4_Valid;
	
	reg [20:0] AD_CH5_Valid;
	
	reg [20:0] AD_CH6_Valid;
	
	reg [20:0] AD_CH7_Valid;
	
	reg [20:0] AD_CH8_Valid;			
	
	
	
	//combine 3 for 1, save M9K 
	
    
	DPRAM	DPRAM_inst1 (
		.data      (Data_A ),
		.rdaddress (Rd_Addr1[8:0]),
		.rdclock   (!AD_CLK ),
		.wraddress ( Wr_addr[8:0] ),     //512,circle loop 
		.wrclock   (!AD_CLK  ),
		.wren      (Wr_En ),
		.q         (AD_CH1 )
	);
	
	DPRAM	DPRAM_inst2 (
		.data      (Data_B ),
		.rdaddress (Rd_Addr2[8:0]),
		.rdclock   (!AD_CLK  ),
		.wraddress ( Wr_addr[8:0] ),
		.wrclock   (!AD_CLK  ),
		.wren      (Wr_En ),
		.q         (AD_CH2 )
	);

	DPRAM	DPRAM_inst3 (
		.data      (Data_C ),
		.rdaddress (Rd_Addr3[8:0]),
		.rdclock   (!AD_CLK  ),
		.wraddress (Wr_addr[8:0] ),
		.wrclock   (!AD_CLK  ),
		.wren      (Wr_En ),
		.q         (AD_CH3 )
	);

	DPRAM	DPRAM_inst4 (
		.data      (Data_D ),
		.rdaddress (Rd_Addr4[8:0]),
		.rdclock   (!AD_CLK  ),
		.wraddress (Wr_addr[8:0] ),
		.wrclock   (!AD_CLK  ),
		.wren      (Wr_En ),
		.q         (AD_CH4 )
	);

	DPRAM	DPRAM_inst5 (
		.data      (Data_E ),
		.rdaddress (Rd_Addr5[8:0]),
		.rdclock   (!AD_CLK  ),
		.wraddress (Wr_addr[8:0] ),
		.wrclock   (!AD_CLK  ),
		.wren      (Wr_En ),
		.q         (AD_CH5 )
	);

	DPRAM	DPRAM_inst6 (
		.data      (Data_F ),
		.rdaddress (Rd_Addr6[8:0]),
		.rdclock   (!AD_CLK  ),
		.wraddress (Wr_addr[8:0] ),
		.wrclock   (!AD_CLK  ),
		.wren      (Wr_En ),
		.q         (AD_CH6 )
	);
	

	DPRAM	DPRAM_inst7 (
		.data      (Data_G ),
		.rdaddress (Rd_Addr7[8:0]),
		.rdclock   (!AD_CLK),
		.wraddress (Wr_addr[8:0] ),
		.wrclock   (!AD_CLK  ),
		.wren      (Wr_En ),
		.q         (AD_CH7 )
	);

	DPRAM	DPRAM_inst8 (
		.data      (Data_H ),
		.rdaddress (Rd_Addr8[8:0]),
		.rdclock   (!AD_CLK  ),
		.wraddress (Wr_addr[8:0] ),
		.wrclock   (!AD_CLK  ),
		.wren      (Wr_En ),
		.q         (AD_CH8 )
	);

	
	
	wire [7:0] Dynamic_Pace;
	
	reg [14:0] Dynamic_Addr;
	
	always @(*) 
	 begin
		if(Focus_Num == 2'b10)
		
			Dynamic_Addr <= {1'b1,Rd_addr[13:0]};
		else 
		
			Dynamic_Addr <= {1'b0,Rd_addr[13:0]};
	end
	
	
	
	DynamicFocus	DynamicFocus_inst (
		.address (Dynamic_Addr ),  //even/odd,addr,  
		.clock   (!AD_CLK  ),
		.q       (Dynamic_Pace )
	);
	
	
	//save M9K  use logic cell
	
	reg [127:0] DynamicDelay_Start;  
	
	always @(*) begin
		if(Focus_Num == 2'b10)
	   	begin
			DynamicDelay_Start <= 128'h00FB00EB00DB00CA00BA00AA009A0089;  //outside 16ch
		  end
		else 
		  begin
			DynamicDelay_Start <= 128'h00790069005900490038002800180008;  //center 16ch
		 end
	end
	

	
	
	/*
	//for F=70, fixed delay
	reg [127:0] DynamicDelay_Start;  
	always @(*) begin
		if(Focus_Num == 2'b10) begin
			DynamicDelay_Start <= 128'h001A0014000E000A0006000300010000;  //outside 16ch
		end
		else begin
			DynamicDelay_Start <= 128'h001A0014000E000A0006000300010000;  //center 16ch
		end
	end
	*/



	
	
	//hanning coff
	//hanning 9  33  71  116  163  205  237  254  
	//half hanning 146 170 192 212  229 242  251 255
	//hamming   20 31 59 102 151 197 234 253	


	//assign Line_Num = Line_Num_Pre -1'b1;
   
	wire [7:0] w1,w2,w3,w4,w5,w6,w7,w8;
	
	
	parameter 
	  //W_OUTSIDE = 64'h006B7C8D9DACBBC9;
	 // W_OUTSIDE =   64'hFFFFFFFFFFFFFFFF;
	  W_OUTSIDE =   64'hB2BBC4CCD4DBE2E8;
	  
	
	wire [63:0] W_CENTER;
	
	wire [10:0] Apod_Addr;
	
	assign Apod_Addr = (Rd_addr<16'd2048)?Rd_addr[10:0]:11'd2047;
	
	
	Apod Apod_Inst 
	(
		.address(Apod_Addr),
		.clock  (AD_CLK),
		.q     (W_CENTER)
	);
	
	//assign {w1,w2,w3,w4,w5,w6,w7,w8} =(Focus_Num == 2'b11 || Focus_Num == 2'b10)?W_OUTSIDE:W_CENTER;
	assign {w1,w2,w3,w4,w5,w6,w7,w8} =(Focus_Num == 2'b10)?W_OUTSIDE:W_CENTER;
	
	
	mult12_8 mult12_8_Inst1(
		.clock(AD_CLK),
		.dataa(AD_CH1),
		.datab(w1),
		.result(AD_CH1_Valid)
	);
	
	mult12_8 mult12_8_Inst2(
		.clock(AD_CLK),
		.dataa(AD_CH2),
		.datab(w2),
		.result(AD_CH2_Valid)
	);

	mult12_8 mult12_8_Inst3(
		.clock(AD_CLK),
		.dataa(AD_CH3),
		.datab(w3),
		.result(AD_CH3_Valid)
	);

	mult12_8 mult12_8_Inst4(
		.clock(AD_CLK),
		.dataa(AD_CH4),
		.datab(w4),
		.result(AD_CH4_Valid)
	);

	mult12_8 mult12_8_Inst5(
		.clock(AD_CLK),
		.dataa(AD_CH5),
		.datab(w5),
		.result(AD_CH5_Valid)
	);

	mult12_8 mult12_8_Inst6(
		.clock(AD_CLK),
		.dataa(AD_CH6),
		.datab(w6),
		.result(AD_CH6_Valid)
	);

	mult12_8 mult12_8_Inst7(
		.clock(AD_CLK),
		.dataa(AD_CH7),
		.datab(w7),
		.result(AD_CH7_Valid)
	);

	mult12_8 mult12_8_Inst8(
		.clock(AD_CLK),
		.dataa(AD_CH8),
		.datab(w8),
		.result(AD_CH8_Valid)
	);			
		
	wire [15:0] DAS_RF_Value;
	reg [15:0] DAS_Value_IN;
	reg [18:0] DAS_tmp;
	
	
	DAS_RF	DAS_RF_inst (
		.clock ( AD_CLK ),
		.data ( DAS_Value_IN ),
		.rdaddress ( Rd_addr +16'd1 ),  //delay for write in and read out
		.wraddress ( Rd_addr ),
		.wren ((Focus_Num == 2'b10)),
		.q ( DAS_RF_Value )
	);
	
	//wire [7:0] Coff;
	Coherent_Coff Coherent_Coff_Inst(
		.clk(AD_CLK),
		.Data_A(AD_CH1),
		.Data_B(AD_CH2),
		.Data_C(AD_CH3),
		.Data_D(AD_CH4),
		.Data_E(AD_CH5),
		.Data_F(AD_CH6),
		.Data_G(AD_CH7),
		.Data_H(AD_CH8),
		.Coff(Coheren_Coff)
	);		
	
	
	always @(posedge AD_CLK or posedge RX_Gate) begin
		if(RX_Gate) begin
		   
		   /*
			Rd_Addr1 <= CoarseDelay[63:56];
			Rd_Addr2 <= CoarseDelay[55:48];
			Rd_Addr3 <= CoarseDelay[47:40];
			Rd_Addr4 <= CoarseDelay[39:32];
			Rd_Addr5 <= CoarseDelay[31:24];
			Rd_Addr6 <= CoarseDelay[23:16];
			Rd_Addr7 <= CoarseDelay[15:8];
			Rd_Addr8 <= CoarseDelay[7:0];	
			*/
			
			
			Rd_Addr1 <= DynamicDelay_Start[127:112];
			Rd_Addr2 <= DynamicDelay_Start[111:96];
			Rd_Addr3 <= DynamicDelay_Start[95:80];
			Rd_Addr4 <= DynamicDelay_Start[79:64];
			Rd_Addr5 <= DynamicDelay_Start[63:48];
			Rd_Addr6 <= DynamicDelay_Start[47:32];
			Rd_Addr7 <= DynamicDelay_Start[31:16];
			Rd_Addr8 <= DynamicDelay_Start[15:0];
			
			Rd_addr  <= 16'd0; 	
					

		end
		else begin

						
			if(So_Gate) begin
			
			    Rd_addr  <= Rd_addr + 1'b1;
			    
			    
				Rd_Addr1 <= Rd_Addr1 + Dynamic_Pace[7];
				Rd_Addr2 <= Rd_Addr2 + Dynamic_Pace[6];
				Rd_Addr3 <= Rd_Addr3 + Dynamic_Pace[5];
				Rd_Addr4 <= Rd_Addr4 + Dynamic_Pace[4];
				Rd_Addr5 <= Rd_Addr5 + Dynamic_Pace[3];
				Rd_Addr6 <= Rd_Addr6 + Dynamic_Pace[2];
				Rd_Addr7 <= Rd_Addr7 + Dynamic_Pace[1];
				Rd_Addr8 <= Rd_Addr8 + Dynamic_Pace[0];		
				
				/*
				Rd_Addr1 <= Rd_Addr1 + 1'b1;
				Rd_Addr2 <= Rd_Addr2 + 1'b1;
				Rd_Addr3 <= Rd_Addr3 + 1'b1;
				Rd_Addr4 <= Rd_Addr4 + 1'b1;
				Rd_Addr5 <= Rd_Addr5 + 1'b1;
				Rd_Addr6 <= Rd_Addr6 + 1'b1;
				Rd_Addr7 <= Rd_Addr7 + 1'b1;
				Rd_Addr8 <= Rd_Addr8 + 1'b1;	
				*/
			            
                //DAS_Value_IN <= AD_CH1_Valid[20:8] + AD_CH2_Valid[20:8] + AD_CH3_Valid[20:8] + AD_CH4_Valid[20:8]+AD_CH1_Valid[20:8] + AD_CH2_Valid[20:8] + AD_CH3_Valid[20:8] + AD_CH4_Valid[20:8]; 
				
				DAS_Value_IN <= AD_CH1_Valid[20:8] + AD_CH2_Valid[20:8] + AD_CH3_Valid[20:8] + AD_CH4_Valid[20:8] + AD_CH5_Valid[20:8] + AD_CH6_Valid[20:8] + AD_CH7_Valid[20:8] + AD_CH8_Valid[20:8]; 
				
				if((Focus_Num == 2'b11))  begin
					//DAS_Value <= DAS_Value_IN;
					DAS_Value <=DAS_Value_IN[15:0]+ DAS_RF_Value[15:0]; 
				end
				else begin
					DAS_Value <= DAS_Value_IN;
				end
		    end
			else
					DAS_Value <= 16'd0;

			end
	
	end
	





endmodule
