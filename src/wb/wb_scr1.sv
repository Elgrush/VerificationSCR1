module wb_scr1 (
	// Wishbone interfaces
	input wb_rst_n_i,
	input wb_clk_i,

	output reg [31:0] wbm_adr_instr_o,
	output reg [31:0] wbm_dat_instr_o,
	input [31:0] wbm_dat_instr_i,
	output reg wbm_we_instr_o,
	output reg [3:0] wbm_sel_instr_o,
	output reg wbm_stb_instr_o,
	input wbm_ack_instr_i,
	output reg wbm_cyc_instr_o,

	output reg [31:0] wbm_adr_data_o,
	output reg [31:0] wbm_dat_data_o,
	input [31:0] wbm_dat_data_i,
	output reg wbm_we_data_o,
	output reg [3:0] wbm_sel_data_o,
	output reg wbm_stb_data_o,
	input wbm_ack_data_i,
	output reg wbm_cyc_data_o,

	// IRQ interface
	input  [31:0] irq,
	output [31:0] eoi,

	// Trace Interface
	output        trace_valid,
	output [35:0] trace_data
	
);
	wire        mem_valid;
	wire [31:0] mem_addr;
	wire [31:0] mem_wdata;
	wire [ 3:0] mem_wstrb;
	reg         mem_ready;
	reg [31:0] mem_rdata;

	scr1_core_top scr1_core (

    .pwrup_rst_n(),                // Power-Up reset
    .rst_n(),                      // Regular reset
    .cpu_rst_n(),                  // CPU reset
    .test_mode(),                  // DFT Test Mode
    .test_rst_n(),                 // DFT Test Reset
    .clk(),                        // Core clock
    .core_rst_n_o(),               // Core reset
    .core_rdc_qlfy_o(),            // Core RDC qualifier

// Instruction Memory Interface
    .imem2core_req_ack_i(),        // IMEM request acknowledge
    .core2imem_req_o(),            // IMEM request
    .core2imem_cmd_o(),            // IMEM command
    .core2imem_addr_o(),           // IMEM address
    .imem2core_rdata_i(),          // IMEM read data
    .imem2core_resp_i(),           // IMEM response

// Data Memory Interface
    .dmem2core_req_ack_i(),        // DMEM request acknowledge
    .core2dmem_req_o(),            // DMEM request
    .core2dmem_cmd_o(),            // DMEM command
    .core2dmem_width_o(),          // DMEM data width
    .core2dmem_addr_o(),           // DMEM address
    .core2dmem_wdata_o(),          // DMEM write data
    .dmem2core_rdata_i(),          // DMEM read data
    .dmem2core_resp_i()            // DMEM response

);

	localparam IDLE = 2'b00;
	localparam WBSTART = 2'b01;
	localparam WBEND = 2'b10;

	reg [1:0] state;

	wire we;
	assign we = (mem_wstrb[0] | mem_wstrb[1] | mem_wstrb[2] | mem_wstrb[3]);

	always @(posedge wb_clk_i) begin
		if (!wb_rst_n_i) begin
			wbm_adr_o <= 0;
			wbm_dat_o <= 0;
			wbm_we_o <= 0;
			wbm_sel_o <= 0;
			wbm_stb_o <= 0;
			wbm_cyc_o <= 0;
			state <= IDLE;
		end else begin
			case (state)
				IDLE: begin
					if (mem_valid) begin
						wbm_adr_o <= mem_addr;
						wbm_dat_o <= mem_wdata;
						wbm_we_o <= we;
						wbm_sel_o <= mem_wstrb;

						wbm_stb_o <= 1'b1;
						wbm_cyc_o <= 1'b1;
						state <= WBSTART;
					end else begin
						mem_ready <= 1'b0;

						wbm_stb_o <= 1'b0;
						wbm_cyc_o <= 1'b0;
						wbm_we_o <= 1'b0;
					end
				end
				WBSTART:begin
					if (wbm_ack_i) begin
						mem_rdata <= wbm_dat_i;
						mem_ready <= 1'b1;

						state <= WBEND;

						wbm_stb_o <= 1'b0;
						wbm_cyc_o <= 1'b0;
						wbm_we_o <= 1'b0;
					end
				end
				WBEND: begin
					mem_ready <= 1'b0;

					state <= IDLE;
				end
				default:
					state <= IDLE;
			endcase
		end
	end
endmodule

module wb_master (
    
);
    
endmodule
