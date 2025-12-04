`timescale 1 ns / 1 ps

// synopsys translate_off
//`include "timescale.v"
// synopsys translate_on

module wb_gpio
#(parameter GPIO_ADDR = 32'h1001_0000)
(
  clk_i, i_rst_n, cyc_i, stb_i, adr_i, we_i, data_i, data_o, ack_o,gpio,gpio1
);

  //
  // Inputs & outputs
  //
  parameter io = 32;            // number of GPIOs

  // 8bit WISHBONE bus slave interface
  input         clk_i;         // clock
  input         i_rst_n;         // reset (asynchronous active low)
  input         cyc_i;         // cycle
  input         stb_i;         // strobe
  input  [31:0] adr_i;         // address adr_i[1]
  input         we_i;          // write enable
  input  [ 31:0] data_i;         // data output
  output reg [ 31:0] data_o;         // data input
  output reg       ack_o;         // normal bus termination

  // GPIO pins
  output reg  [31:0] gpio = 0;
  output reg  [31:0] gpio1 = 0;

  //
  // Module body
  //
  reg [io:1] ctrl, line;                  // ControlRegister, LineRegister
  reg [io:1] lgpio, llgpio;               // LatchedGPIO pins

  //
  // WISHBONE interface

  wire wb_acc = cyc_i & stb_i;            // WISHBONE access
  wire wb_wr  = wb_acc & we_i;            // WISHBONE write access

  always @(posedge clk_i or negedge i_rst_n)
  begin
    if (!i_rst_n)
      begin
          ctrl <= {{io}{1'b0}};
          line <= {{io}{1'b0}};
      end
    else if (wb_wr)
    begin
       if ( adr_i == GPIO_ADDR) gpio <= data_i;
       else if ( adr_i == (GPIO_ADDR+32'h4)) gpio1 <= data_i;
    end
   end



  //reg [7:0] dat_o;
  always @(posedge clk_i)
  begin
    if ( adr_i ) data_o <= gpio;
  end

  //reg ack_o;
  always @(posedge clk_i or negedge i_rst_n)
  begin
    if (!i_rst_n)
      ack_o <= 1'b0;
    else
      ack_o <= wb_acc & !ack_o;
  end
      
endmodule

