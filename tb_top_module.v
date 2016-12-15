`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   23:34:02 10/31/2016
// Design Name:   top_module
// Module Name:   C:/Users/muhammadlatif/Downloads/Ruthiv/OCT31/top_module/tb_top_module.v
// Project Name:  top_module
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: top_module
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb_top_module;

	// Inputs
	reg tb_clk;
	reg tb_reset;
	reg tb_rx_in;
   integer i;
	// Outputs
	wire tb_vld_out;
	wire [31:0] tb_packet;

	// Instantiate the Unit Under Test (UUT)
	top_module uut (
		.clk(tb_clk), 
		.reset(tb_reset), 
		.rx_in(tb_rx_in), 
		.vld_out(tb_vld_out), 
		.packet(tb_packet)
	);


	initial 
		tb_clk = 1'b1;
	always
		#5 tb_clk = ~tb_clk;
	 
	
	initial begin
		
////////////////////////////////////////////////////////////////////////////////////////////
///////////// 32 bit 1st PACKET START /////////////////////////////////////////////////////////////////
		tb_reset = 1;
		// Wait 100 ns for global reset to finish
		#100;
		tb_reset = 0;
		
		for(i=0;i<8;i=i+1) begin
				//Start bit for BYTE 1.
				#320 tb_rx_in = 0;
				 
				//Data byte 
				#320 tb_rx_in = 1;
						
				#320 tb_rx_in = 1;
				 
				#320 tb_rx_in = 0;
				 
				#320 tb_rx_in = 1;
				 
				#320 tb_rx_in = 1;
				
				#320 tb_rx_in = 1;
				
				#320 tb_rx_in = 0;
				 
				#320 tb_rx_in = 0;
				//stop byte
				#320 tb_rx_in = 1;
				
				
				//Start bit for BYTE 2.
				#320 tb_rx_in = 0;
				 
				//Data byte 
				#320 tb_rx_in = 1;
						
				#320 tb_rx_in = 0;
				 
				#320 tb_rx_in = 1;
				 
				#320 tb_rx_in = 0;
				 
				#320 tb_rx_in = 1;
				
				#320 tb_rx_in = 0;
				
				#320 tb_rx_in = 1;
				 
				#320 tb_rx_in = 0;
				//stop byte
				#320 tb_rx_in = 1;
				
				
				//Start bit for BYTE 3.
				#320 tb_rx_in = 0;
				 
				//Data byte 
				#320 tb_rx_in = 1;
						
				#320 tb_rx_in = 1;
				 
				#320 tb_rx_in = 1;
				 
				#320 tb_rx_in = 1;
				 
				#320 tb_rx_in = 0;
				
				#320 tb_rx_in = 0;
				
				#320 tb_rx_in = 0;
				 
				#320 tb_rx_in = 0;
				//stop byte
				#320 tb_rx_in = 1;
				#320
				
				//Start bit for BYTE 4.
				#320 tb_rx_in = 0;
				 
				//Data byte 
				#320 tb_rx_in = 1;
						
				#320 tb_rx_in = 1;
				 
				#320 tb_rx_in = 1;
				 
				#320 tb_rx_in = 1;
				 
				#320 tb_rx_in = 0;
				
				#320 tb_rx_in = 0;
				
				#320 tb_rx_in = 0;
				 
				#320 tb_rx_in = 0;
				//stop byte
				#320 tb_rx_in = 1;
				
				////////////////////////////////////////////////////////////////////////////////////////////
		///////////// 32 bit 2nd PACKET START /////////////////////////////////////////////////////////////////	
				
				//Start bit for BYTE 1
				#320 tb_rx_in = 0;
				 
				//Data byte 
				#320 tb_rx_in = 1;
						
				#320 tb_rx_in = 0;
				 
				#320 tb_rx_in = 1;
				 
				#320 tb_rx_in = 0;
				 
				#320 tb_rx_in = 1;
				
				#320 tb_rx_in = 0;
				
				#320 tb_rx_in = 1;
				 
				#320 tb_rx_in = 0;
				//stop byte
				#320 tb_rx_in = 1;
			

				
				//Start bit for BYTE 2.
				#320 tb_rx_in = 0;
				 
				//Data byte 
				#320 tb_rx_in = 1;
						
				#320 tb_rx_in = 1;
				 
				#320 tb_rx_in = 0;
				 
				#320 tb_rx_in = 0;
				
				#320 tb_rx_in = 1;
				
				#320 tb_rx_in = 1;
				
				#320 tb_rx_in = 0;
				 
				#320 tb_rx_in = 0;
				//stop byte
				#320 tb_rx_in = 1;
				
				
				//Start bit for BYTE 3.
				#320 tb_rx_in = 0;
				 
				//Data byte 
				#320 tb_rx_in = 1;
						
				#320 tb_rx_in = 1;
				 
				#320 tb_rx_in = 1;
				 
				#320 tb_rx_in = 1;
				 
				#320 tb_rx_in = 1;
				
				#320 tb_rx_in = 1;
				
				#320 tb_rx_in = 1;
				 
				#320 tb_rx_in = 1;
				//stop byte
				#320 tb_rx_in = 1;
				#320
				
				
				//Start bit for BYTE 4.
				#320 tb_rx_in = 0;
				 
				//Data byte 
				#320 tb_rx_in = 0;
						
				#320 tb_rx_in = 0;
				 
				#320 tb_rx_in = 0;
				 
				#320 tb_rx_in = 0;
				 
				#320 tb_rx_in = 1;
				
				#320 tb_rx_in = 1;
				
				#320 tb_rx_in = 1;
				 
				#320 tb_rx_in = 1;
				//stop byte
				#320 tb_rx_in = 1;
				
				////////////////////////////////////////////////////////////////////////////////////////////
		///////////// 32 bit 3rd PACKET START /////////////////////////////////////////////////////////////////	

				//Start bit for BYTE 1.
				#320 tb_rx_in = 0;
				 
				//Data byte 
				#320 tb_rx_in = 1;
						
				#320 tb_rx_in = 1;
				 
				#320 tb_rx_in = 0;
				 
				#320 tb_rx_in = 0;
				 
				#320 tb_rx_in = 1;
				
				#320 tb_rx_in = 1;
				
				#320 tb_rx_in = 0;
				 
				#320 tb_rx_in = 0;
				//stop byte
				#320 tb_rx_in = 1;
				
				
				
				//Start bit for BYTE 2.
				#320 tb_rx_in = 0;
				 
				//Data byte 
				#320 tb_rx_in = 1;
						
				#320 tb_rx_in = 1;
				 
				#320 tb_rx_in = 1;
				 
				#320 tb_rx_in = 1;
				 
				#320 tb_rx_in = 0;
				
				#320 tb_rx_in = 0;
				
				#320 tb_rx_in = 0;
				 
				#320 tb_rx_in = 0;
				//stop byte
				#320 tb_rx_in = 1;
				
				
				//Start bit for BYTE 3.
				#320 tb_rx_in = 0;
				 
				//Data byte 
				#320 tb_rx_in = 1;
						
				#320 tb_rx_in = 1;
				 
				#320 tb_rx_in = 1;
				 
				#320 tb_rx_in = 1;
				 
				#320 tb_rx_in = 0;
				
				#320 tb_rx_in = 0;
				
				#320 tb_rx_in = 0;
				 
				#320 tb_rx_in = 0;
				//stop byte
				#320 tb_rx_in = 1;
				
				
				//Start bit for BYTE 4.
				#320 tb_rx_in = 0;
				 
				//Data byte 
				#320 tb_rx_in = 1;
						
				#320 tb_rx_in = 1;
				 
				#320 tb_rx_in = 0;
				 
				#320 tb_rx_in = 0;
				 
				#320 tb_rx_in = 1;
				
				#320 tb_rx_in = 1;
				
				#320 tb_rx_in = 0;
				 
				#320 tb_rx_in = 0;
				//stop byte
				#320 tb_rx_in = 1;
		end
		#320
		
		
		$finish;		
    
	end
      
endmodule

