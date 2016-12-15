/**
 * A UART receiver module including a byte buffer for incoming packets.
 */

`include "spio_uart_common.h"

module spio_uart_rx#( // The number of bits required to address the specified
                        // buffer size (i.e. the buffer will have size
                        // (1<<BUFFER_ADDR_BITS)-1).
                        parameter BUFFER_ADDR_BITS = 4
                        // The number of bits in a word in the buffer.
                      , parameter WORD_SIZE = 72
							 ,parameter HIGH_WATER_MARK = 8
                      ) 
							 
							 ( // Common clock for synchronous signals
                      input wire CLK_IN
                      // Asynchronous active-high reset
                    , input wire RESET_IN
                      // "Asynchronous" signals (incoming signals must be
                      // externally synchronised)
                        // Incoming serial stream
                    ,   input  wire RX_IN
                      // Synchronous signals
                        // Incoming 'bytes', no rdy signal: vld will appear for
                        // one cycle whenever a byte is received.
                    ,   output reg  [31:0] DATA_OUT
                    ,   output wire       VLD_OUT
                        // Single-cycle pulse from the baud generator 8 times
                        // per bit
                    ,   input wire SUBSAMPLE_PULSE_IN
						  ,   output wire BIG_VLD_OUT
						  ,   output wire [71:0] SPIKE
						  
						  
						  ,   output wire BYTE_DROPPED_OUT
						  
						  ,   output wire BUFFERED_DATA_OUT 
						  ,   output wire TO_SPINLINK_VLD_OUT  
						  ,   input wire FRM_SPINLINK_RDY_IN   
                    );

////////////////////////////////////////////////////////////////////////////////
// Counter
////////////////////////////////////////////////////////////////////////////////

// A continuous 0-7 counter to count bit times.
reg  [2:0] counter_i;

always @ (posedge CLK_IN, posedge RESET_IN)
	if (RESET_IN)
		counter_i <= 3'h0;
	else
		if (SUBSAMPLE_PULSE_IN)
			counter_i <= counter_i + 1;


////////////////////////////////////////////////////////////////////////////////
// Sub-sampling state machine
////////////////////////////////////////////////////////////////////////////////

// Waiting for the initial transition due to a start bit to arrive.
localparam STATE_IDLE = 9;

// Waiting half-a-bit into the start bit to ensure it is stable
localparam STATE_START = 10;

// Receiving the byte (states must be in ascending order)
localparam STATE_BIT0 = 0;
localparam STATE_BIT1 = 1;
localparam STATE_BIT2 = 2;
localparam STATE_BIT3 = 3;
localparam STATE_BIT4 = 4;
localparam STATE_BIT5 = 5;
localparam STATE_BIT6 = 6;
localparam STATE_BIT7 = 7;

// Receiving a stop bit (does not check its value). (State must follow STATE_BIT7.)
localparam STATE_STOP = 8;


// The counter value at the time of bit arrival
reg [2:0] bit_time_i;

// A signal asserted for a single cycle coinciding with SUBSAMPLE_PULSE_IN when
// the input should be sampled.
wire sample_now_i = SUBSAMPLE_PULSE_IN && counter_i == bit_time_i;

// State register
reg [3:0] state_i;

always @ (posedge CLK_IN, posedge RESET_IN)
	if (RESET_IN)
		state_i <= STATE_IDLE;
	else
		if (SUBSAMPLE_PULSE_IN)
			case (state_i)
				STATE_IDLE:
					if (RX_IN == `START_BIT)
						begin
							// Expected bit centre is half a bit time from the initial
							// transition.
							state_i <= STATE_START;
							bit_time_i <= counter_i + 3'd4;
						end
				
				STATE_START:
					if (RX_IN != `START_BIT)
						// If a non-start-bit is seen then we just encountered a glitch
						state_i <= STATE_IDLE;
					else if (sample_now_i)
						state_i <= STATE_BIT0;
				
				STATE_BIT0, STATE_BIT1, STATE_BIT2, STATE_BIT3,
				STATE_BIT4, STATE_BIT5, STATE_BIT6, STATE_BIT7:
					if (sample_now_i)
						state_i <= state_i + 1;
				
				STATE_STOP:
					if (sample_now_i)
						state_i <= STATE_IDLE;
				
				default:
					state_i <= STATE_IDLE;
			endcase


////////////////////////////////////////////////////////////////////////////////
// Shift register
////////////////////////////////////////////////////////////////////////////////

always @ (posedge CLK_IN, posedge RESET_IN)
	if (RESET_IN)
		DATA_OUT <= 8'hXX;
	else
		if (SUBSAMPLE_PULSE_IN && bit_time_i == counter_i)
			case (state_i)
				STATE_BIT0, STATE_BIT1, STATE_BIT2, STATE_BIT3,
				STATE_BIT4, STATE_BIT5, STATE_BIT6, STATE_BIT7:
					DATA_OUT <= {RX_IN, DATA_OUT[31:1]};
				
				default:
					DATA_OUT <= DATA_OUT;
			endcase


////////////////////////////////////////////////////////////////////////////////
// Output
////////////////////////////////////////////////////////////////////////////////

// The data is fully shifted into the register while the stop bit is being
// received.
assign VLD_OUT          = state_i == STATE_STOP && sample_now_i;



////////////////////////////////////////////////////////////////////////////////
//  SPIKE PACKET OUPUT.
////////////////////////////////////////////////////////////////////////////////

// If there are 4 valid signals, it means that we have all bytes to make a spiNNaker packet. Remember that the code assumes "!E2" option on eDVS.
// spiNNaker packet is 72 bit. 
reg  [2:0] vld_counter_i;
reg BIG_VLD_OUT_temp;
//reg [31:0] DATA_OUT_temp;

always @ (posedge CLK_IN, posedge RESET_IN)
	if (RESET_IN)
	   begin
			vld_counter_i <= 3'h0;
		end
	else
	  begin 
		if (VLD_OUT)
		   begin
				if (vld_counter_i == 3'b011)
					begin
					  // BIG_VLD_OUT_temp <= 1'b1;
						//DATA_OUT_temp <= DATA_OUT;
						vld_counter_i <= 3'b0;
					end
				else
					begin
						//BIG_VLD_OUT_temp <= 1'b0;
						vld_counter_i <= vld_counter_i + 1;
					end
			end
	  end

	  always @ (posedge CLK_IN)
	  begin 
		if (VLD_OUT && (vld_counter_i == 3'b011))
			BIG_VLD_OUT_temp <= 1'b1;
		else
			BIG_VLD_OUT_temp <= 1'b0;
	  end

assign BIG_VLD_OUT    = BIG_VLD_OUT_temp;

  reg [7:0] xaddr;
  reg [7:0] yaddr;
  reg polarity;
  reg [7:0] timestamp1;
  reg [7:0] timestamp2;


always@(posedge CLK_IN or posedge RESET_IN)
begin
  if(RESET_IN)
    begin
		 xaddr <= 8'd0;
		 yaddr <= 8'd0;
		 polarity <= 1'b0;
		 timestamp1 <= 8'd0;
		 timestamp2 <= 8'd0;
	 end
  else
    begin
    if(BIG_VLD_OUT)
	 begin
	   yaddr <= DATA_OUT[7:1];
		polarity <= DATA_OUT[8];
		xaddr <= DATA_OUT[15:9];
		timestamp1 <= DATA_OUT[23:16];
		timestamp2 <= DATA_OUT[31:24];
		end
	 end
end	

assign SPIKE ={ 16'd0, timestamp2, timestamp1, 8'd0, yaddr, 7'd0, xaddr, polarity, 8'd2};
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////// BUFFER SECTION//////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	//IN_RDY_OUT ----> Low if the buffer is full. 
	//IN_VLD_IN -----> To tell if incoming data from the camera is valid or not. 
	//OUT_RDY_IN------> Ready from spinn_link module.
	//OUT_VLD_OUT-----> Low if buffer is empty, spinn_link shouldn't read from the buffer.
	// IN_DATA_IN-----> Store the SPIKE in the buffer.
	
	
	
	
      wire data_vld_i = BIG_VLD_OUT;
		wire data_rdy_i;
		
		// Bytes are dropped whenever a byte is available but the FIFO is full.
		assign BYTE_DROPPED_OUT = data_vld_i && !data_rdy_i;
		
		// Drop CTS if the occupancy rises above the specified high-water mark.
		wire [BUFFER_ADDR_BITS-1:0] fifo_occupancy_i;
		assign CTS_OUT = !RESET_IN && fifo_occupancy_i < HIGH_WATER_MARK;
		
		// The FIFO to store the incoming bytes
		spio_uart_fifo #( .BUFFER_ADDR_BITS(BUFFER_ADDR_BITS)
		                , .WORD_SIZE(72)
		                )
		spio_uart_fifo_i( .CLK_IN       (CLK_IN)
		                , .RESET_IN     (RESET_IN)
		                , .OCCUPANCY_OUT(fifo_occupancy_i)
		                , .IN_DATA_IN   (SPIKE)
		                , .IN_VLD_IN    (data_vld_i)
		                , .IN_RDY_OUT   (data_rdy_i)
		                , .OUT_DATA_OUT (BUFFERED_DATA_OUT)
		                , .OUT_VLD_OUT  (TO_SPINLINK_VLD_OUT)
		                , .OUT_RDY_IN   (FRM_SPINLINK_RDY_IN)
		                );



endmodule

