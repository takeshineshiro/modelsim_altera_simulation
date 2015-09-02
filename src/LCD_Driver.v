module LCD_Driver(
	input LCLK,  //LCD CLK
	input RST_n,
	output reg HS,
	output reg VS,
	output DE,
	output reg [9:0] Column,
	output reg [9:0] Row,
	output reg SPENA,
	output reg SPDA_OUT,
	input SPDA_IN,
	output reg WrEn,
	output reg SPCK,
	input [7:0] Brightness,
	input [7:0] Contrast
	
);


	reg [9:0] Column_Counter;
	reg [9:0] Row_Counter;


 	
	//������
	reg [9:0] Column_Reg;
	always @(posedge LCLK) begin
		if(VS & HS) begin
			Column <= Column_Reg;
		end
		else begin
			Column <= 10'd0;
		end
	end

	
	always @(posedge LCLK) begin
		if(Column_Counter <10'd1) begin
			Column_Counter <= Column_Counter + 1'b1;
			Column_Reg <= 10'd0;
		    HS <= 1'b0;
		end
		else if(Column_Counter <=10'd56) begin
			Column_Counter <= Column_Counter + 1'b1;
			Column_Reg <= 10'd0;
		    HS <= 1'b1;
		end		
		else if(Column_Counter <=10'd70) begin
			Column_Counter <= Column_Counter + 1'b1;
			Column_Reg <= Column_Reg + 1'b1;
		    HS <= 1'b1;
		end
		else if(Column_Counter <10'd390) begin
			Column_Counter <= Column_Counter + 1'b1;
			Column_Reg <= Column_Reg + 1'b1;
		    HS <= 1'b1;
		end
		else if(Column_Counter <10'd408) begin            
			Column_Counter <= Column_Counter + 1'b1;
			Column_Reg <= 10'd334;
		    HS <= 1'b1;
		end
		/*
		else if(Column_Counter <10'd800) begin            
			Column_Counter <= Column_Counter + 1'b1;
			Column_Reg <= 10'd334;
		    HS <= 1'b1;
		end
		*/
		else begin
			Column_Counter <= 10'd0;
		end
	end
	
	//������
	always @(posedge HS) begin
		if( Row_Counter < 10'd1) begin
			Row_Counter <= Row_Counter + 1'b1;
			Row <= 10'd0;
		    VS <= 1'b0;
		end
		else if( Row_Counter <= 10'd13) begin
			Row_Counter <= Row_Counter + 1'b1;
			Row <= 10'd0;
		    VS <= 1'b1;
		end
		else if( Row_Counter < 10'd253) begin
			Row_Counter <= Row_Counter + 1'b1;
			Row <= Row + 1'b1;
		    VS <= 1'b1;
		end
		else if( Row_Counter < 10'd263) begin
			Row_Counter <= Row_Counter + 1'b1;
			Row <= 10'd239;
		    VS <= 1'b1;
		end
		else begin
			Row_Counter <=10'D0;
			VS <= 1'b0;
		end
	end
	


	
	//parameter setting

   //  no use
	reg [7:0] SPCK_Counter;
	wire SPCK_tmp;
	always @(posedge LCLK) begin
		SPCK_Counter <= SPCK_Counter + 1'b1;
	end
	assign SPCK_tmp = SPCK_Counter[4];  //1.5MHz
	
	reg [7:0] SP_Counter;
	
	
	
	parameter 
		WAKEUP = 16'b00000010_00000011;
	
	wire [15:0] Snd_Data1;
	wire [15:0] Snd_Data2;

	
	assign Snd_Data1 ={8'h26,{1'b0,Brightness[7:1]}};
	assign Snd_Data2 = {8'h22,{3'b0,Contrast[7:3]}};	
		
	reg [16:0] SP_DATA;
	
	reg [15:0] Snd_Old1;
	reg [15:0] Snd_Old2;
	always @(posedge LCLK) begin
		SPCK <= (~SPCK_tmp) | SPENA;
	end
	
	always @ (posedge SPCK_tmp or negedge RST_n) begin
		if(~RST_n) begin
			SP_Counter <= 8'd0;
			SP_DATA <= WAKEUP;
			SPENA  <= 1'b1;
			Snd_Old1 <= {8'h26,8'd0};
			Snd_Old2 <= {8'h22,8'd0};
			WrEn <= 1'b1;			
		end
		else begin
			if(SP_Counter < 8'd6) begin
				SP_Counter 	<= SP_Counter + 1'b1;
				SPDA_OUT 		<= SP_DATA[15];
				SP_DATA         <={SP_DATA[14:0],1'b0};
				SPENA 		<= 1'b0;
				WrEn <= 1'b1;
			end	
			else if(SP_Counter == 8'd6) begin
				SP_Counter <= SP_Counter + 1'b1;
				SPENA <= 1'b0;
				SPDA_OUT 		<= SP_DATA[15];
				SP_DATA         <={SP_DATA[14:0],1'b0};
				if(SP_DATA[15] == 1'b1) begin  //wr mode
					WrEn <= 1'b1;
				end
				else begin
					WrEn <= 1'b0;
				end
			end	
			else if(SP_Counter < 8'd16) begin
				SP_Counter <= SP_Counter + 1'b1;
				SPDA_OUT 		<= SP_DATA[15];
				SP_DATA         <={SP_DATA[14:0],1'b0};
				SPENA <= 1'b0;
			end	
			else if(SP_Counter < 8'd32)begin
				SPENA <= 1'b1;
				SP_Counter <= SP_Counter + 1'b1;
			end
			else begin
				
				if(Snd_Data1 != Snd_Old1) begin
				    Snd_Old1 <= Snd_Data1;
					SP_DATA <= Snd_Data1;
					SP_Counter <= 8'd0;
					WrEn <= 1'b1;
				end
				else if(Snd_Data2 != Snd_Old2) begin
				    Snd_Old2 <= Snd_Data2;
					SP_DATA <= Snd_Data2;
					SP_Counter <= 8'd0;
					WrEn <= 1'b1;
				end
				else begin
					WrEn <= 1'b0;
				end
			end
		end
	end	
		
	
   /*	
	//parameter setting

   //  no use
	reg [7:0] SPCK_Counter;
	wire SPCK_tmp;
	always @(posedge LCLK) begin
		SPCK_Counter <= SPCK_Counter + 1'b1;
	end
	assign SPCK_tmp = SPCK_Counter[4];  //1.5MHz
	
	reg [7:0] SP_Counter;
	
	
	
	
	
	parameter
		WAKEUP = 16'b00000010_00000011;
	
	wire [15:0] Snd_Data1;
	wire [15:0] Snd_Data2;
	wire [15:0] Snd_Data3;
	wire  UD;  //0: down to up, 1 :up to down ,default :1;
	wire  LR;  //0: right to left,1:left to right , default :1;
	
	assign UD = 1'b0;
	assign LR = 1'b0;
	
	assign Snd_Data1 ={8'h26,{1'b0,Brightness[7:1]}};
	assign Snd_Data2 = {8'h22,{3'b0,Contrast[7:3]}};	
	assign Snd_Data3 = {8'h0A,{6'b0,UD,LR}};
		
	reg [16:0] SP_DATA;
	
	reg [15:0] Snd_Old1;
	reg [15:0] Snd_Old2;
	reg [15:0] Snd_Old3;
	always @(posedge LCLK) begin
		SPCK <= (~SPCK_tmp) | SPENA;
	end
	
	always @ (posedge SPCK_tmp or negedge RST_n) begin
		if(~RST_n) begin
			SP_Counter <= 8'd0;
			SP_DATA <= WAKEUP;
			SPENA  <= 1'b1;
			Snd_Old1 <= {8'h26,8'd0};
			Snd_Old2 <= {8'h22,8'd0};
			Snd_Old3 <= {8'h0A,8'd03};
			WrEn <= 1'b1;			
		end
		else begin
			if(SP_Counter < 8'd6) begin
				SP_Counter 	<= SP_Counter + 1'b1;
				SPDA_OUT 		<= SP_DATA[15];
				SP_DATA         <={SP_DATA[14:0],1'b0};
				SPENA 		<= 1'b0;
				WrEn <= 1'b1;
			end	
			else if(SP_Counter == 8'd6) begin
				SP_Counter <= SP_Counter + 1'b1;
				SPENA <= 1'b0;
				SPDA_OUT 		<= SP_DATA[15];
				SP_DATA         <={SP_DATA[14:0],1'b0};
				if(SP_DATA[15] == 1'b1) begin  //wr mode
					WrEn <= 1'b1;
				end
				else begin
					WrEn <= 1'b0;
				end
			end	
			else if(SP_Counter < 8'd16) begin
				SP_Counter <= SP_Counter + 1'b1;
				SPDA_OUT 		<= SP_DATA[15];
				SP_DATA         <={SP_DATA[14:0],1'b0};
				SPENA <= 1'b0;
			end	
			else if(SP_Counter < 8'd32)begin
				SPENA <= 1'b1;
				SP_Counter <= SP_Counter + 1'b1;
			end
			else begin
				
				if(Snd_Data1 != Snd_Old1) begin
				    Snd_Old1 <= Snd_Data1;
					SP_DATA <= Snd_Data1;
					SP_Counter <= 8'd0;
					WrEn <= 1'b1;
				end
				else if(Snd_Data2 != Snd_Old2) begin
				    Snd_Old2 <= Snd_Data2;
					SP_DATA <= Snd_Data2;
					SP_Counter <= 8'd0;
					WrEn <= 1'b1;
				end
				else if(Snd_Data3 != Snd_Old3) begin
				    Snd_Old3 <= Snd_Data3;
					SP_DATA <= Snd_Data3;
					SP_Counter <= 8'd0;
					WrEn <= 1'b1;
				end
				else begin
					WrEn <= 1'b0;
				end
			end
		end
	end	
	*/
	



endmodule
