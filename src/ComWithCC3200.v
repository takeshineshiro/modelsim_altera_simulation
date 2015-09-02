module ComWithCC3200(
	input               CC3200_SPI_CLK,
	input               CC3200_SPI_CS,
	output reg          CC3200_SPI_DIN,
	input               CC3200_SPI_DOUT,
	input               Envelop,
	output reg [7:0]    Line_Num, 
	output reg          Enable,
	output reg [1:0]    Zoom,
	output reg [5:0]    Gain,
	input  [7:0]        Trans_Data,
	output reg [8:0]    Trans_Addr

);

	 reg [15:0] Config_Data_Shift;
	 
    reg [3:0] SPI_Counter;
	 
    reg [7:0] Shift_Data;
    
    
    //write   
    
	always @(posedge CC3200_SPI_CLK or negedge CC3200_SPI_CS )
	begin
		if(~CC3200_SPI_CS) 
		    begin
			//Enable <= Config_Data_Shift[7];
			Line_Num  <= Config_Data_Shift[7:0];
			Zoom      <= Config_Data_Shift[15:14];
			Gain      <= Config_Data_Shift[13:8];
		 end
		else begin
			if(Trans_Addr == 9'd1 ) begin // wr
				Config_Data_Shift[15:8] <={Config_Data_Shift[14:8],CC3200_SPI_DOUT};
			end
			else if(Trans_Addr == 9'd2 ) begin //wr
				Config_Data_Shift[7:0] <={Config_Data_Shift[6:0],CC3200_SPI_DOUT} ;
			end
		end
	end
	
	
	
    //read
    
	always @(negedge CC3200_SPI_CLK or negedge CC3200_SPI_CS ) begin
		if(~CC3200_SPI_CS) begin
			SPI_Counter <= 8'd0;
			Shift_Data <=Trans_Data;	
		end
		else begin
			if(~Envelop) begin   //rd
				SPI_Counter <= SPI_Counter + 1'b1;
				CC3200_SPI_DIN <= Shift_Data[7];
				Shift_Data <= Shift_Data <<1;
			end
		end
	end	
	
	
	always @(posedge CC3200_SPI_CS or posedge Envelop) begin       //cs  8 bit once
		if(Envelop) begin
			Trans_Addr  <= 9'd0;
		end
		else begin
			Trans_Addr <= Trans_Addr + 1'b1;
		end
	end	
	

	
	
endmodule
