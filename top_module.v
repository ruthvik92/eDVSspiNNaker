`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:25:47 10/30/2016 
// Design Name: 
// Module Name:    top_module 
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
module top_module(
      input clk,
		input reset,
		input wire rx_in,
		output wire vld_out,
		output[31:0] packet,
		output wire big_vld_out,
		output [71:0] spike,
		
		output [71:0] buffered_data_out, 
	   output wire to_spinlink_vld_out,  
		input wire frm_spinlink_rdy_in,
		output wire byte_dropped_out 
  );
	 
	 
	 wire subsample_pulse_in;
	 wire baud_pulse_out;
	 spio_uart_rx spio_uart_rx_i( .CLK_IN(clk),  .RESET_IN(reset),	                                                                 								 
								          .RX_IN(rx_in), .DATA_OUT(packet),
											 .VLD_OUT(vld_out), .SUBSAMPLE_PULSE_IN(subsample_pulse_in),
											 .BIG_VLD_OUT(big_vld_out), .SPIKE(spike), .BUFFERED_DATA_OUT(buffered_data_out),
											 .TO_SPINLINK_VLD_OUT(to_spinlink_vld_out), .FRM_SPINLINK_RDY_IN(frm_spinlink_rdy_in),
											 .BYTE_DROPPED_OUT(byte_dropped_out)
											 
	 );
	 
	 

    spio_uart_baud_gen spio_uart_baud_gen_i( .CLK_IN(clk), .RESET_IN(reset),
															.BAUD_PULSE_OUT(baud_pulse_out),
															.SUBSAMPLE_PULSE_OUT(subsample_pulse_in)

     );	 
endmodule
  
