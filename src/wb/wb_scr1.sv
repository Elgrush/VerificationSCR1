`include "scr1_arch_description.svh"
`include "scr1_arch_types.svh"
`include "scr1_memif.svh"

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
	logic imem2core_req_ack;        // IMEM request acknowledge
	logic core2imem_req;            // IMEM request
	logic [`SCR1_IMEM_AWIDTH-1:0] core2imem_addr;           // IMEM address
	logic [`SCR1_IMEM_DWIDTH-1:0] imem2core_rdata;          // IMEM read data
	type_scr1_mem_resp_e imem2core_resp;           // IMEM response

	// Data Memory Interface
	logic dmem2core_req_ack;        // DMEM request acknowledge
	logic core2dmem_req;            // DMEM request
	type_scr1_mem_cmd_e core2dmem_cmd;            // DMEM command
	type_scr1_mem_width_e core2dmem_width;          // DMEM data width
	logic [`SCR1_IMEM_AWIDTH-1:0] core2dmem_addr;           // DMEM address
	logic core2dmem_wdata;          // DMEM write data
	logic [`SCR1_IMEM_DWIDTH-1:0] dmem2core_rdata;          // DMEM read data
	type_scr1_mem_resp_e dmem2core_resp;            // DMEM response

	scr1_core_top scr1_core (

		.pwrup_rst_n(wb_rst_n_i),                // Power-Up reset
		.rst_n(wb_rst_n_i),                      // Regular reset
		.cpu_rst_n(wb_rst_n_i),                  // CPU reset
		.test_mode('0),                  // DFT Test Mode
		.test_rst_n('0),                 // DFT Test Reset
		.clk(wb_clk_i),                        // Core clock
		.core_rst_n_o(wb_rst_n_i),               // Core reset
		.core_rdc_qlfy_o('0),            // Core RDC qualifier

		// Instruction Memory Interface
		.imem2core_req_ack_i(imem2core_req_ack),        // IMEM request acknowledge
		.core2imem_req_o(core2imem_req),            // IMEM request
		.core2imem_cmd_o(core2imem_cmd),            // IMEM command
		.core2imem_addr_o(core2imem_addr),           // IMEM address
		.imem2core_rdata_i(imem2core_rdata),          // IMEM read data
		.imem2core_resp_i(imem2core_resp),           // IMEM response

		// Data Memory Interface
		.dmem2core_req_ack_i(dmem2core_req_ack),        // DMEM request acknowledge
		.core2dmem_req_o(core2dmem_req),            // DMEM request
		.core2dmem_cmd_o(core2dmem_cmd),            // DMEM command
		.core2dmem_width_o(core2dmem_width),          // DMEM data width
		.core2dmem_addr_o(core2dmem_addr),           // DMEM address
		.core2dmem_wdata_o(core2dmem_wdata),          // DMEM write data
		.dmem2core_rdata_i(dmem2core_rdata),          // DMEM read data
		.dmem2core_resp_i(dmem2core_resp)            // DMEM response

	);

	wb_master_scr instr_master (
		.wb_rst_i(wb_rst_i),
		.wb_clk_i(wb_clk_i),

		.wbm_adr_o(wbm_adr_instr_o),
		.wbm_dat_o(wbm_dat_instr_o),
		.wbm_dat_i(wbm_dat_instr_i),
		.wbm_we_o (wbm_we_instr_o),
		.wbm_sel_o(wbm_sel_instr_o),
		.wbm_stb_o(wbm_stb_instr_o),
		.wbm_ack_i(wbm_ack_instr_i),
		.wbm_cyc_o(wbm_cyc_instr_o)
	), data_master(
		.wb_rst_i(wb_rst_i),
		.wb_clk_i(wb_clk_i),

		.wbm_adr_o(wbm_adr_data_o),
		.wbm_dat_o(wbm_dat_data_o),
		.wbm_dat_i(wbm_dat_data_i),
		.wbm_we_o (wbm_we_data_o), 	
		.wbm_sel_o(wbm_sel_data_o),
		.wbm_stb_o(wbm_stb_data_o),
		.wbm_ack_i(wbm_ack_data_i),
		.wbm_cyc_o(wbm_cyc_data_o)
	);
endmodule
