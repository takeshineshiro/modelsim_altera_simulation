module Transmit(
	input             Transmit_CLK,     //100MHz
	input [7:0]       Line_Num,         //Line Num,256 Lines totally,0~255
	input [1:0]       Focus_Num,        //Focus_num ,3 totally
	input             Pr_Gate,          //prepare for everythings
	input             RX_Gate,          // Start Transmit
	output reg        Sample_Gate,      //
	output reg [15:0] P,
	output reg [15:0] N,
	
	output reg        HV_SW_CLR,
	output reg        HV_SW_LE,
	output reg        HV_SW_CLK,
	output reg        HV_SW_DOUT,
	
	output reg [3:0]  AX,
	output reg [2:0]  AY,
	output reg        MT_CS,
	output reg        MT_Strobe,
	output reg        MT_Data
	
);


	wire [7:0] Delay_CH1,Delay_CH2, Delay_CH3, Delay_CH4, Delay_CH5, Delay_CH6, Delay_CH7, Delay_CH8;
	
	wire [7:0] Delay_CH9,Delay_CH10,Delay_CH11,Delay_CH12,Delay_CH13,Delay_CH14,Delay_CH15,Delay_CH16;
	
	


	reg [5:0] EMIT_WIDTH;
	
	
	always @(*) begin
		case(Focus_Num[1:0])
			2'b00:  //20mm
				EMIT_WIDTH <= 6'd14;    //4MHz
			2'b01:  //40mm
				EMIT_WIDTH <= 6'd14;   //3.5MHz
			2'b10:  //80mm
				EMIT_WIDTH <= 6'd16;   //3MHz
			2'b11:  //80mm
				EMIT_WIDTH <= 6'd16;  //3MHz
		endcase
	end
  
	
	//replace rom for saving M9K ram
	
	wire [7:0] Test_q;

	Test_Line	Test_Line_inst (
	.address   (1'b0 ),
	.clock     (Pr_Gate),
	.q         (Test_q )
	);
	
	
	
	 reg [127:0] Delay_ALL;
	 
	always @(posedge Pr_Gate) begin
	
	/*
		case(Test_q[2:0] )
		
		    //R=60mm
		    //20mm
			3'b00: begin
			    
				if(Line_Num[0]) // odd
					Delay_ALL <= 128'h8000070D1215181A1A1A1815120D0700;
				else            // even
					Delay_ALL <= 128'h00070D1215181A1A1A1815120D070080;


			end	
			

				
		    
		   // 40mm
			3'b001:  begin
				if(Line_Num[0]) // odd
					Delay_ALL <= 128'h800004080B0D0F1011100F0D0B080400;
				else            // even
					Delay_ALL <= 128'h0004080B0D0F1011100F0D0B08040080;				



			end

            //60mm
			3'b010:  begin

			
			    
				if(Line_Num[0]) // odd
					Delay_ALL <= 128'h80000406090B0C0D0D0D0C0B09060400;
				else            // even
					Delay_ALL <= 128'h000406090B0C0D0D0D0C0B0906040080;	

	            
			end		
            
            //80mm
			3'b011:  begin

			
			    
				if(Line_Num[0]) // odd
					Delay_ALL <= 128'h8000030608090B0B0C0B0B0908060300;
				else            // even
					Delay_ALL <= 128'h00030608090B0B0C0B0B090806030080;	

	            
			end						
			
			
			//100mm
			3'b100:  begin
			   if(Line_Num[0]) // odd
					Delay_ALL <= 128'h8000030507090A0A0B0A0A0907050300;
				else            // even
					Delay_ALL <= 128'h00030507090A0A0B0A0A090705030080;	
			
	
			end			                     

			//120mm
			3'b101:  begin
			   if(Line_Num[0]) // odd
					Delay_ALL <= 128'h800003050708090A0A0A090807050300;
				else            // even
					Delay_ALL <= 128'h0003050708090A0A0A09080705030080;	
			
	
			end			                     



		endcase	
       */

		case(Focus_Num[1:0] )
		
		    
		    //20mm
			2'b00: begin
			    
				if(Line_Num[0]) // odd
					Delay_ALL <= 128'h8000070D1215181A1A1A1815120D0700;
				else            // even
					Delay_ALL <= 128'h00070D1215181A1A1A1815120D070080;


			end	
			

				
		    
		   // 40mm
			2'b01:  begin
				if(Line_Num[0]) // odd
					Delay_ALL <= 128'h800004080B0D0F1011100F0D0B080400;
				else            // even
					Delay_ALL <= 128'h0004080B0D0F1011100F0D0B08040080;				



			end


            
            //80mm    outside 
			2'b10:  begin	
			
			    
			    
				if(Line_Num[0]) // odd
					Delay_ALL <= 128'h800004080B0D0F1011100F0D0B080400;
				else            // even
					Delay_ALL <= 128'h0004080B0D0F1011100F0D0B08040080;	
					
					
				/*
			    // 80mm
				if(Line_Num[0]) // odd
					Delay_ALL <= 128'h8000030608090B0B0C0B0B0908060300;
				else            // even
					Delay_ALL <= 128'h00030608090B0B0C0B0B090806030080;	
				*/	
					
			end						
			
			
			//80mm       inside 
			2'b11:  begin
			    
				
				if(Line_Num[0]) // odd
					Delay_ALL <= 128'h800004080B0D0F1011100F0D0B080400;
				else            // even
					Delay_ALL <= 128'h0004080B0D0F1011100F0D0B08040080;	
					
				/*	
			   // 80mm
			   if(Line_Num[0]) // odd
					Delay_ALL <= 128'h8000030608090B0B0C0B0B0908060300;
				else            // even
					Delay_ALL <= 128'h00030608090B0B0C0B0B090806030080;	
			    */
			end			                     



		endcase	
		
																	
	end
	
		
	assign Delay_CH1=(Pr_Gate)?Delay_ALL[127:120]:Delay_CH1;
	
	assign Delay_CH2=(Pr_Gate)?Delay_ALL[119:112]:Delay_CH2;
	
	assign Delay_CH3=(Pr_Gate)?Delay_ALL[111:104]:Delay_CH3;
	
	assign Delay_CH4=(Pr_Gate)?Delay_ALL[103:96]:Delay_CH4;
	
	assign Delay_CH5=(Pr_Gate)?Delay_ALL[95:88]:Delay_CH5;
	
	assign Delay_CH6=(Pr_Gate)?Delay_ALL[87:80]:Delay_CH6;
	
	assign Delay_CH7=(Pr_Gate)?Delay_ALL[79:72]:Delay_CH7;
	
	assign Delay_CH8=(Pr_Gate)?Delay_ALL[71:64]:Delay_CH8;
	
	assign Delay_CH9=(Pr_Gate)?Delay_ALL[63:56]:Delay_CH9;
	
	assign Delay_CH10=(Pr_Gate)?Delay_ALL[55:48]:Delay_CH10;
	
	assign Delay_CH11=(Pr_Gate)?Delay_ALL[47:40]:Delay_CH11;
	
	assign Delay_CH12=(Pr_Gate)?Delay_ALL[39:32]:Delay_CH12;
	
	assign Delay_CH13=(Pr_Gate)?Delay_ALL[31:24]:Delay_CH13;
	
	assign Delay_CH14=(Pr_Gate)?Delay_ALL[23:16]:Delay_CH14;
	
	assign Delay_CH15=(Pr_Gate)?Delay_ALL[15:8]:Delay_CH15;
	
	assign Delay_CH16=(Pr_Gate)?Delay_ALL[7:0]:Delay_CH16;		
	
													

  reg  [7:0]  Delay_Counter;
  
  reg        Sec_HW_Gate  ;
  
  
  always @(posedge Transmit_CLK or negedge RX_Gate)
  begin
  	if(~RX_Gate) begin
  		  Delay_Counter <= 8'd0;
		  Sample_Gate   <= 1'b0;
		  Sec_HW_Gate   <= 1'b0;
  	end
  	else
  		begin
  		  if(Delay_Counter < Delay_CH8 )                //longest path 
		     begin
  				Delay_Counter <= Delay_Counter + 1'b1;
				Sample_Gate   <= 1'b0;
				Sec_HW_Gate   <= 1'b0;
		   end
		  else if(Delay_Counter < (Delay_CH8 + 8'd5) ) begin  //about 50ns width
				Delay_Counter <= Delay_Counter + 1'b1;
				Sample_Gate   <= 1'b1;
				Sec_HW_Gate   <= 1'b0;
		  end
		   else if(Delay_Counter < (Delay_CH8 + {EMIT_WIDTH[5:0],2'b0} +EMIT_WIDTH[5:0] ) ) begin  //wait finish emit
				Delay_Counter  <= Delay_Counter + 1'b1;
				Sample_Gate    <= 1'b0;
				Sec_HW_Gate    <= 1'b0;
		  end
		   else if(Delay_Counter < (Delay_CH8 + {EMIT_WIDTH[5:0],2'b0}+EMIT_WIDTH[5:0]+8'd5) ) begin  //switch to inner 
				Delay_Counter <= Delay_Counter + 1'b1;
				Sample_Gate   <= 1'b0;
				Sec_HW_Gate   <= 1'b1;
		  end		  
		  else begin
				Sample_Gate <= 1'b0;
				Sec_HW_Gate<= 1'b0;
		  end
		end
  end
	

		
	wire [15:0] TXP;
	
	wire [15:0] TXN;
	
	
	
	
	EmitOneCH EmitOneCH1
	(
	.Transmit_CLK(Transmit_CLK),               //100MHz            
	.RX_Gate     (RX_Gate),                    //Transmit Enable
	.EmitDelay   (Delay_CH1),                 //7th bit for Transmit Enable, 6:0 for Delay                   
    .Emit_Width (EMIT_WIDTH),               //Emit pulse width
	.TXP         (TXP[0]),
	.TXN         (TXN[0])
  );  

	EmitOneCH EmitOneCH2
	(
	.Transmit_CLK(Transmit_CLK),               //100MHz            
	.RX_Gate     (RX_Gate),                    //Transmit Enable
	.EmitDelay   (Delay_CH2),            //7th bit for Transmit Enable, 6:0 for Delay                   
   .Emit_Width  (EMIT_WIDTH),           //Emit pulse width
	.TXP         (TXP[1]),
	.TXN         (TXN[1])
  );  	

	EmitOneCH EmitOneCH3
	(
	.Transmit_CLK(Transmit_CLK),               //100MHz            
	.RX_Gate(RX_Gate),                    //Transmit Enable
	.EmitDelay(Delay_CH3),            //7th bit for Transmit Enable, 6:0 for Delay                   
    .Emit_Width(EMIT_WIDTH),           //Emit pulse width
	.TXP(TXP[2]),
	.TXN(TXN[2])
  );  	

	EmitOneCH EmitOneCH4
	(
	.Transmit_CLK(Transmit_CLK),               //100MHz            
	.RX_Gate(RX_Gate),                    //Transmit Enable
	.EmitDelay(Delay_CH4),            //7th bit for Transmit Enable, 6:0 for Delay                   
    .Emit_Width(EMIT_WIDTH),           //Emit pulse width
	.TXP(TXP[3]),
	.TXN(TXN[3])
	);  	

	EmitOneCH EmitOneCH5
	(
	.Transmit_CLK(Transmit_CLK),               //100MHz            
	.RX_Gate(RX_Gate),                    //Transmit Enable
	.EmitDelay(Delay_CH5),            //7th bit for Transmit Enable, 6:0 for Delay                   
    .Emit_Width(EMIT_WIDTH),           //Emit pulse width
	.TXP(TXP[4]),
	.TXN(TXN[4])
	);  	

	EmitOneCH EmitOneCH6
	(
	.Transmit_CLK(Transmit_CLK),               //100MHz            
	.RX_Gate(RX_Gate),                    //Transmit Enable
	.EmitDelay(Delay_CH6),            //7th bit for Transmit Enable, 6:0 for Delay                   
    .Emit_Width(EMIT_WIDTH),           //Emit pulse width
	.TXP(TXP[5]),
	.TXN(TXN[5])
	);  	


	EmitOneCH EmitOneCH7
	(
	.Transmit_CLK(Transmit_CLK),               //100MHz            
	.RX_Gate(RX_Gate),                    //Transmit Enable
	.EmitDelay(Delay_CH7),            //7th bit for Transmit Enable, 6:0 for Delay                   
    .Emit_Width(EMIT_WIDTH),           //Emit pulse width
	.TXP(TXP[6]),
	.TXN(TXN[6])
	);  	
	

	EmitOneCH EmitOneCH8
	(
	.Transmit_CLK(Transmit_CLK),               //100MHz            
	.RX_Gate(RX_Gate),                    //Transmit Enable
	.EmitDelay(Delay_CH8),            //7th bit for Transmit Enable, 6:0 for Delay                   
    .Emit_Width(EMIT_WIDTH),           //Emit pulse width
	.TXP(TXP[7]),
	.TXN(TXN[7])
	); 
	
	EmitOneCH EmitOneCH9
	(
	.Transmit_CLK(Transmit_CLK),               //100MHz            
	.RX_Gate(RX_Gate),                    //Transmit Enable
	.EmitDelay(Delay_CH9),            //7th bit for Transmit Enable, 6:0 for Delay                   
    .Emit_Width(EMIT_WIDTH),           //Emit pulse width
	.TXP(TXP[8]),
	.TXN(TXN[8])
	);  	
	
	EmitOneCH EmitOneCH10
	(
	.Transmit_CLK(Transmit_CLK),               //100MHz            
	.RX_Gate(RX_Gate),                    //Transmit Enable
	.EmitDelay(Delay_CH10),            //7th bit for Transmit Enable, 6:0 for Delay                   
    .Emit_Width(EMIT_WIDTH),           //Emit pulse width
	.TXP(TXP[9]),
	.TXN(TXN[9])
	);  	

	
	EmitOneCH EmitOneCH11
	(
	.Transmit_CLK(Transmit_CLK),               //100MHz            
	.RX_Gate(RX_Gate),                    //Transmit Enable
	.EmitDelay(Delay_CH11),            //7th bit for Transmit Enable, 6:0 for Delay                   
    .Emit_Width(EMIT_WIDTH),           //Emit pulse width
	.TXP(TXP[10]),
	.TXN(TXN[10])
	);  		
	 	
	EmitOneCH EmitOneCH12
	(
	.Transmit_CLK(Transmit_CLK),               //100MHz            
	.RX_Gate(RX_Gate),                    //Transmit Enable
	.EmitDelay(Delay_CH12),            //7th bit for Transmit Enable, 6:0 for Delay                   
    .Emit_Width(EMIT_WIDTH),           //Emit pulse width
	.TXP(TXP[11]),
	.TXN(TXN[11])
	);  		
	 	
	EmitOneCH EmitOneCH13
	(
	.Transmit_CLK(Transmit_CLK),               //100MHz            
	.RX_Gate(RX_Gate),                    //Transmit Enable
	.EmitDelay(Delay_CH13),            //7th bit for Transmit Enable, 6:0 for Delay                   
    .Emit_Width(EMIT_WIDTH),           //Emit pulse width
	.TXP(TXP[12]),
	.TXN(TXN[12])
	);  		
	 		 	
	EmitOneCH EmitOneCH14
	(
	.Transmit_CLK(Transmit_CLK),               //100MHz            
	.RX_Gate(RX_Gate),                    //Transmit Enable
	.EmitDelay(Delay_CH14),            //7th bit for Transmit Enable, 6:0 for Delay                   
    .Emit_Width(EMIT_WIDTH),           //Emit pulse width
	.TXP(TXP[13]),
	.TXN(TXN[13])
	);  		
	 	
	EmitOneCH EmitOneCH15
	(
	.Transmit_CLK(Transmit_CLK),               //100MHz            
	.RX_Gate(RX_Gate),                    //Transmit Enable
	.EmitDelay(Delay_CH15),            //7th bit for Transmit Enable, 6:0 for Delay                   
    .Emit_Width(EMIT_WIDTH),           //Emit pulse width
	.TXP(TXP[14]),
	.TXN(TXN[14])
	);  		

	EmitOneCH EmitOneCH16
	(
	.Transmit_CLK(Transmit_CLK),               //100MHz            
	.RX_Gate(RX_Gate),                    //Transmit Enable
	.EmitDelay(Delay_CH16),            //7th bit for Transmit Enable, 6:0 for Delay                   
    .Emit_Width(EMIT_WIDTH),           //Emit pulse width
	.TXP(TXP[15]),
	.TXN(TXN[15])
	);  		
	 	


  /////////////////////////////
  //// Seq_adjust
  
  
	always @( posedge Transmit_CLK) begin  //start from 8 line
		case (Line_Num[4:1]+4'd8)                      //??//
		
		4'd0:    
			begin
				P[15:0] <= TXP[15:0];
				N[15:0] <= TXN[15:0];
			end
		4'd1:  
			begin
			    P[15:0] <= {TXP[14:0],TXP[15]};
			    N[15:0] <= {TXN[14:0],TXN[15]};
			end
		4'd02:  
			begin
			    P[15:0] <= {TXP[13:0],TXP[15:14]};
			    N[15:0] <= {TXN[13:0],TXN[15:14]};
			end
		4'd03:  
			begin
			    P[15:0] <= {TXP[12:0],TXP[15:13]};
			    N[15:0] <= {TXN[12:0],TXN[15:13]};
			end			
		4'd04:  
			begin
			    P[15:0] <= {TXP[11:0],TXP[15:12]};
			    N[15:0] <= {TXN[11:0],TXN[15:12]};
			end			
		4'd05:  
			begin
			    P[15:0] <= {TXP[10:0],TXP[15:11]};
			    N[15:0] <= {TXN[10:0],TXN[15:11]};
			end	
		4'd06:  
			begin
			    P[15:0] <= {TXP[9:0],TXP[15:10]};
			    N[15:0] <= {TXN[9:0],TXN[15:10]};
			end			
		4'd07:  
			begin
			    P[15:0] <= {TXP[8:0],TXP[15:9]};
			    N[15:0] <= {TXN[8:0],TXN[15:9]};
			end		
		4'd08:  
			begin
			    P[15:0] <= {TXP[7:0],TXP[15:8]};
			    N[15:0] <= {TXN[7:0],TXN[15:8]};
			end		
		4'd09:  
			begin
			    P[15:0] <= {TXP[6:0],TXP[15:7]};
			    N[15:0] <= {TXN[6:0],TXN[15:7]};
			end															
		4'd10:  
			begin
			    P[15:0] <= {TXP[5:0],TXP[15:6]};
			    N[15:0] <= {TXN[5:0],TXN[15:6]};
			end																							
						
		4'd11:  
			begin
			    P[15:0] <= {TXP[4:0],TXP[15:5]};
			    N[15:0] <= {TXN[4:0],TXN[15:5]};
			end																							
					
		4'd12:  
			begin
			    P[15:0] <= {TXP[3:0],TXP[15:4]};
			    N[15:0] <= {TXN[3:0],TXN[15:4]};
			end																							
																																
		4'd13:  
			begin
			    P[15:0] <= {TXP[2:0],TXP[15:3]};
			    N[15:0] <= {TXN[2:0],TXN[15:3]};
			end																							

		4'd14:  
			begin
			    P[15:0] <= {TXP[1:0],TXP[15:2]};
			    N[15:0] <= {TXN[1:0],TXN[15:2]};
			end																							
					
		4'd15:  
			begin
			    P[15:0] <= {TXP[0],TXP[15:1]};
			    N[15:0] <= {TXN[0],TXN[15:1]};
			end																							
		endcase
	end


				
		
	wire [127:0]  HW_SW_value;  
    reg [7:0] HW_Addr;
	 
    always @(*) 
	  begin
		if(Focus_Num == 2'b00) //20mm
			HW_Addr <={1'b0,Line_Num[7:1]};
		else if(Focus_Num == 2'b01) //40mm
			HW_Addr <={1'b0,Line_Num[7:1]};
		else if(Focus_Num == 2'b11) //80mm        //inner 16ch
			HW_Addr <={1'b0,Line_Num[7:1]};	
		else if(Focus_Num == 2'b10) //80mm       //outside 16ch
			if(Sec_HW_Gate)
				HW_Addr <={1'b1,Line_Num[7:1]};	 // outside 16ch 
			else 
				HW_Addr <={1'b0,Line_Num[7:1]};	 //transmit inner 16CH
	end
	
	
	
	
	
	HW_SW	HW_SW_inst (
	.address    (HW_Addr ),
	.clock      (Transmit_CLK ),
	.q          (HW_SW_value )
	);
	
	
	/////////////////////////////////////////
	///shift the value to HW switch
	

	
	reg [7:0]   Shift_Counter;
	
	reg [1:0]   State_Counter;
	
	reg [127:0] Shift_HW_SW;

	wire        Pr_Gate_Trigger;
	
	reg         Pr_Gate_Reg1,Pr_Gate_Reg2,Pr_Gate_Reg3,Pr_Gate_Reg4;
	
	
	always @(posedge Transmit_CLK)
    begin
		Pr_Gate_Reg4 <= Pr_Gate_Reg3;
		Pr_Gate_Reg3 <= Pr_Gate_Reg2;
		Pr_Gate_Reg2 <= Pr_Gate_Reg1;
		Pr_Gate_Reg1 <= Pr_Gate;
	 end
	
	
	assign Pr_Gate_Trigger = Pr_Gate_Reg1 & (~Pr_Gate_Reg4);
	
	

    always @(posedge Transmit_CLK or posedge Pr_Gate_Trigger) 
	 begin
		if(Pr_Gate_Trigger) 
		   begin
			HV_SW_CLR     <= 1'b0;
			HV_SW_LE      <= 1'b1;
			HV_SW_CLK     <= 1'b0;
			HV_SW_DOUT    <= 1'b0;
			Shift_Counter <= 8'd0;
			State_Counter <= 8'd0;
			Shift_HW_SW   <= HW_SW_value;
			HV_SW_LE      <= 1'b1;
			
		   end
		else 
		 begin
		   if(Sec_HW_Gate) 
			  begin
					HV_SW_CLR     <= 1'b0;
					HV_SW_LE      <= 1'b1;
					HV_SW_CLK     <= 1'b0;
					HV_SW_DOUT    <= 1'b0;
					Shift_Counter <= 8'd0;
					State_Counter <= 8'd0;
					Shift_HW_SW   <= HW_SW_value;
					HV_SW_LE      <= 1'b1;		
			end			
		
			else begin
					if(Shift_Counter <8'd128) 
					  begin
						  HV_SW_LE <= 1'b1;
						if(State_Counter ==2'b00) begin             //set data
							HV_SW_DOUT    <= Shift_HW_SW[0];
							HV_SW_CLK     <= 1'b0;
							State_Counter <= State_Counter + 1'b1;
						end
						else if(State_Counter ==2'b01) begin        //shift the value
							Shift_HW_SW   <= Shift_HW_SW >>1;
							HV_SW_CLK     <= 1'b0;
							State_Counter <= State_Counter + 1'b1;
						end
						else if(State_Counter ==2'b10) begin        // data period == 25M 
							HV_SW_CLK     <= 1'b1;
							State_Counter <= State_Counter + 1'b1;
						end
						else if(State_Counter ==2'b11) begin           // set next shift counter
							HV_SW_CLK     <= 1'b1;
							State_Counter <= State_Counter + 1'b1;
							Shift_Counter <= Shift_Counter + 1'b1;
						end	
						  HV_SW_CLR <= 1'b0;			
					end
					else if(Shift_Counter <8'd130) begin
						HV_SW_LE      <= 1'b0;
						HV_SW_CLK     <= 1'b0;
						HV_SW_CLR     <= 1'b0;
						Shift_Counter <= Shift_Counter + 1'b1;
					end
					else begin
						HV_SW_LE     <= 1'b1;
						HV_SW_CLK    <= 1'b0;
						HV_SW_CLR    <= 1'b0;
					end
				end
		end
	end
	
	
  
    reg [7:0] R_SEQ_Addr;
	 
	 
    always @(*) begin
		if(Focus_Num == 2'b00) //20mm
			R_SEQ_Addr <={1'b0,Line_Num[7:1]};
		else if(Focus_Num == 2'b01) //40mm
			R_SEQ_Addr <={1'b0,Line_Num[7:1]};
		else if(Focus_Num == 2'b11) //80mm       //inner 16ch
			R_SEQ_Addr <={1'b0,Line_Num[7:1]};	
		else if(Focus_Num == 2'b10) //80mm      //outside 16ch
			R_SEQ_Addr <={1'b1,Line_Num[7:1]};	// Receive outside 16CH

	end   
	
	wire [127:0]  SEQ_value;   //SEQ & FOLD
	
	R_SEQ	R_SEQ_inst (
	.address  (R_SEQ_Addr ),
	.clock    (Transmit_CLK ),
	.q       (SEQ_value )
	);
	
	reg [7:0]   SEL_Counter;
	
	reg [2:0]   ST_Counter;  //10MHz
	
	reg [127:0] Shift_SEQ;
	
	reg [3:0]   AX_Decode;
	
	always @(*)                                      //correspond   mt8816
	 begin
		case(SEL_Counter[6:3]) 
		4'b0000:
			AX_Decode <= 4'b0000;
		4'b0001:
			AX_Decode <= 4'b0001;
		4'b0010:
			AX_Decode <= 4'b0010;
		4'b0011:
			AX_Decode <= 4'b0011;
		4'b0100:
			AX_Decode <= 4'b0100;
		4'b0101:
			AX_Decode <= 4'b0101;
		4'b0110:
			AX_Decode <= 4'b1000;
		4'b0111:
			AX_Decode <= 4'b1001;
		4'b1000:
			AX_Decode <= 4'b1010;
		4'b1001:
			AX_Decode <= 4'b1011;
		4'b1010:
			AX_Decode <= 4'b1100;
		4'b1011:
			AX_Decode <= 4'b1101;																															
		4'b1100:
			AX_Decode <= 4'b0110;	
		4'b1101:
			AX_Decode <= 4'b0111;
		4'b1110:
			AX_Decode <= 4'b1110;
		4'b1111:
			AX_Decode <= 4'b1111;									
		endcase
	end

	
	
	
    always @(posedge Transmit_CLK or negedge Pr_Gate)
	 begin
		if(~Pr_Gate) 
		   begin
			MT_CS 		   <= 1'b0;
			MT_Strobe      <= 1'b0;
			MT_Data      	<= 1'b0;
			SEL_Counter    <= 8'd0;
			ST_Counter     <= 4'd0;
			Shift_SEQ      <= SEQ_value;			
		   end
		else 
		begin
			if(SEL_Counter <8'd128) 
			begin
				MT_CS <= 1'b1;
				if(ST_Counter <=3'd1) 
				   begin             //set Address,attention: Address and Data can't set at the same time
					MT_Strobe   <= 1'b0;
					AX[3:0]     <= AX_Decode[3:0];
					AY[2:0]     <= SEL_Counter[2:0];
					ST_Counter  <= ST_Counter + 1'b1;
				   end
				else if(ST_Counter <=3'd2) 
				   begin        //set up strobe
					MT_Strobe   <= 1'b1;
					ST_Counter  <= ST_Counter + 1'b1;
				   end				
				else if(ST_Counter <=3'd3) 
				   begin        //shift the value
					MT_Data     <= Shift_SEQ[127];
					MT_Strobe   <= 1'b1;
					ST_Counter  <= ST_Counter + 1'b1;
				   end
				else if(ST_Counter <=3'd4) 
				   begin        //shift data
					MT_Strobe   <= 1'b1;
					ST_Counter  <= ST_Counter + 1'b1;
					Shift_SEQ   <= Shift_SEQ <<1;
				   end
				else if(ST_Counter <=3'd5) 
				   begin        //wait
					MT_Strobe   <= 1'b1;
					ST_Counter  <= ST_Counter + 1'b1;
				   end				
				else if(ST_Counter <=3'd6) 
				   begin           // set next shift counter
					MT_Strobe   <= 1'b0;
					ST_Counter  <= ST_Counter + 1'b1;
					SEL_Counter <= SEL_Counter + 1'b1;
				   end		
				else if(ST_Counter <=3'd7) 
				   begin           //End
					MT_Strobe   <= 1'b0;
					MT_Data     <= 1'b0;
					ST_Counter  <= ST_Counter + 1'b1;
				   end							
			 end
			else 
			begin
				MT_Strobe  <= 1'b0;
				MT_CS 	  <= 1'b0;
				MT_Data    <= 1'b0;
			end
		end
	end	
	

endmodule
