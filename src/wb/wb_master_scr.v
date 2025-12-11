`include "scr1_arch_description.svh"
`include "scr1_arch_types.svh"
`include "scr1_memif.svh"

module wb_master_scr (
    // Wishbone interfaces
	input wb_rst_n_i,
	input wb_clk_i,

	output reg [31:0] wbm_adr_o,
	output reg [31:0] wbm_dat_o,
	input [31:0] wbm_dat_i,
	output reg [31:0] mem_rdata,
	output reg wbm_we_o,
	output reg [3:0] wbm_sel_o,
	output reg wbm_stb_o,
	input wbm_ack_i,
	output reg wbm_cyc_o,

	input mem_valid,
	output reg mem_ready,
	output reg mem_ack,

	input [`SCR1_IMEM_AWIDTH-1:0] mem_addr_i,
	input [`SCR1_IMEM_DWIDTH-1:0] mem_wdata_i,
	input [3:0] mem_wstrb_i
);
    localparam IDLE = 2'b00;
	localparam WBSTART = 2'b01;
	localparam WBEND = 2'b10;

	reg [1:0] state;

	wire we;
	assign we = |mem_wstrb_i;

	assign mem_rdata = wbm_dat_i;

	always @(posedge wb_clk_i) begin
		if (!wb_rst_n_i) begin
			wbm_adr_o <= 0;
			wbm_dat_o <= 0;
			wbm_we_o <= 0;
			wbm_sel_o <= 0;
			wbm_stb_o <= 0;
			wbm_cyc_o <= 0;
			mem_ack <= 0;
			state <= IDLE;
		end else begin
			case (state)
				IDLE: begin
					if (mem_valid) begin
						wbm_adr_o <= mem_addr_i;
						wbm_dat_o <= mem_wdata_i;
						wbm_we_o <= we;
						wbm_sel_o <= mem_wstrb_i;

						wbm_stb_o <= 1'b1;
						wbm_cyc_o <= 1'b1;

						mem_ack <= 1;
						state <= WBSTART;
					end else begin
						mem_ready <= 1'b0;

						wbm_stb_o <= 1'b0;
						wbm_cyc_o <= 1'b0;
						wbm_we_o <= 1'b0;
					end
				end
				WBSTART:begin
					mem_ack <= 0;
					if (wbm_ack_i) begin
						state <= WBEND;
						mem_ready <= 1'b1;
					end
				end
				WBEND: begin
					mem_ready <= 1'b0;
					wbm_stb_o <= 1'b0;
					wbm_cyc_o <= 1'b0;
					wbm_we_o <= 1'b0;

					state <= IDLE;
				end
				default:
					state <= IDLE;
			endcase
		end
	end
endmodule
