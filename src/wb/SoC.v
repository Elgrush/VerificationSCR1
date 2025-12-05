module SoC # (
	parameter PATH_TO_MEM = "src/data"
) (
	input clk,
	input rst_n,
	output [31:0] gpio, gpio1,
	output [31:0] opcode
	
);

	reg [31:0] irq = 0;

	reg [15:0] count_cycle = 0;
	always @(posedge clk) count_cycle <= !rst_n ? count_cycle + 1 : 0;


	wire [31:0] 	wb_adr_scr_instr, wb_adr_scr_data,	wb_adr_ram,	wb_adr_array,	wb_adr_gpio;
	wire [31:0] 	wb_dat_o_scr_instr, wb_dat_o_scr_data,	wb_dat_o_ram,	wb_dat_o_array,	wb_dat_o_gpio;
	wire [3:0] 	wb_sel_scr_instr, wb_sel_scr_data,	wb_sel_ram,	wb_sel_array,	wb_sel_gpio;
	wire 		wb_we_scr_instr, wb_we_scr_data,	wb_we_ram,	wb_we_array,	wb_we_gpio;
	wire 		wb_cyc_scr_instr, wb_cyc_scr_data,	wb_cyc_ram,	wb_cyc_array,	wb_cyc_gpio;
	wire 		wb_stb_scr_instr, wb_stb_scr_data,	wb_stb_ram,	wb_stb_array,	wb_stb_gpio;
	wire [31:0] 	wb_dat_i_scr_instr, wb_dat_i_scr_data,	wb_dat_i_ram,	wb_dat_i_array,	wb_dat_i_gpio;
	wire 		wb_ack_scr_instr, wb_ack_scr_data,	wb_ack_ram,	wb_ack_array,	wb_ack_gpio;
	
	wb_ram #(.ADDRESS_WIDTH (12),.MEMFILE($sformatf("%s/%s", PATH_TO_MEM, "firmware.mem"))) 
	ram ( // Wishbone interface
		.wb_clk_i(clk),
		.wb_rst_n_i(rst_n),

		.wb_adr_i(wb_adr_ram),
		.wb_dat_i(wb_dat_i_ram),
		.wb_stb_i(wb_stb_ram),
		.wb_cyc_i(wb_cyc_ram),
		.wb_dat_o(wb_dat_o_ram),
		.wb_ack_o(wb_ack_ram),
		.wb_sel_i(wb_sel_ram),
		.wb_we_i(wb_we_ram)
	);
	
	wb_ram #(.ADDRESS_WIDTH (12),.MEMFILE($sformatf("%s/%s", PATH_TO_MEM, "array.mem")), .instr_MASK(32'hFFFF_0000)) 
	array_ram ( // Wishbone interface
		.wb_clk_i(clk),
		.wb_rst_n_i(rst_n),

		.wb_adr_i(wb_adr_array),
		.wb_dat_i(wb_dat_i_array),
		.wb_stb_i(wb_stb_array),
		.wb_cyc_i(wb_cyc_array),
		.wb_dat_o(wb_dat_o_array),
		.wb_ack_o(wb_ack_array),
		.wb_sel_i(wb_sel_array),
		.wb_we_i(wb_we_array)
	);
	
	wb_gpio #(.GPIO_instr(32'h1001_0000)) wb_gpio
	(
		.clk_i(clk),         // clock
  		.rst_n_i(rst_n),         // rst_n (asynchronous active low)
  		.cyc_i(wb_cyc_gpio),         // cycle
  		.stb_i(wb_stb_gpio),         // strobe
  		.adr_i(wb_adr_gpio),         // instress adr_i[1]
  		.we_i(wb_we_gpio),          // write enable
  		.data_i(wb_dat_i_gpio),         // data output
  		.data_o(wb_dat_o_gpio),         // data input
  		.ack_o(wb_ack_gpio),        // normal bus termination
		.gpio(gpio),
		.gpio1(gpio1)
  	);

  	
	
	wb_scr1 uut (
		.irq (irq),
		.wb_clk_i(clk),
		.wb_rst_n_i(rst_n),

		.wbm_adr_instr_o(wb_adr_scr_instr),
		.wbm_dat_instr_i(wb_dat_i_scr_instr),
		.wbm_stb_instr_o(wb_stb_scr_instr),
		.wbm_ack_instr_i(wb_ack_scr_instr),
		.wbm_cyc_instr_o(wb_cyc_scr_instr),
		.wbm_dat_instr_o(wb_dat_o_scr_instr),
		.wbm_we_instr_o(wb_we_scr_instr),
		.wbm_sel_instr_o(wb_sel_scr_instr),

		.wbm_adr_data_o(wb_adr_scr_data),
		.wbm_dat_data_i(wb_dat_i_scr_data),
		.wbm_stb_data_o(wb_stb_scr_data),
		.wbm_ack_data_i(wb_ack_scr_data),
		.wbm_cyc_data_o(wb_cyc_scr_data),
		.wbm_dat_data_o(wb_dat_o_scr_data),
		.wbm_we_data_o(wb_we_scr_data),
		.wbm_sel_data_o(wb_sel_scr_data)

	);
	
	//wishbone interconnect crossbar
	wbxbar
	#(	.NM(2),.NS(3),.AW(32),.DW(32),
		.SLAVE_instr({32'h0000_0000, 32'h0001_0000, 32'h1001_0000}),
		.SLAVE_MASK({32'hFFFF_0000, 32'hFFFF_0000, 32'hFFFF_F000}) 
	)
	crossbar
	(
		//
		.i_clk(clk), 
		.i_rst_n(rst_n),
		//
		// Here are the bus inputs from each of the WB bus masters
		.i_mcyc({wb_cyc_scr_instr, wb_cyc_scr_data}), 
		.i_mstb({wb_stb_scr_instr, wb_stb_scr_data}),
		.i_mwe({wb_we_scr_instr, wb_we_scr_data}),
		.i_maddr({wb_adr_scr_instr, wb_adr_scr_data}),
		.i_mdata({wb_dat_o_scr_instr, wb_dat_o_scr_data}),//rev
		.i_msel({wb_sel_scr_instr, wb_sel_scr_data}),
		// .... and their return data
		//.o_mstall(),
		.o_mack({wb_ack_scr_instr, wb_ack_scr_data}),
		.o_mdata({wb_dat_i_scr_instr, wb_dat_i_scr_data}),//rev
		//.o_merr(),
		//
		//-----------------------------------
		//
		// Here are the output ports, used to control each of the
		// various slave ports that we are connected to
		.o_scyc({	wb_cyc_ram, wb_cyc_array,	wb_cyc_gpio }), 
		.o_sstb({	wb_stb_ram,	wb_stb_array,	wb_stb_gpio }), 
		.o_swe({	wb_we_ram,	wb_we_array,	wb_we_gpio }),
		.o_saddr({	wb_adr_ram,	wb_adr_array,	wb_adr_gpio }),
		.o_sdata({	wb_dat_i_ram,	wb_dat_i_array,	wb_dat_i_gpio }),//rev
		.o_ssel({	wb_sel_ram,	wb_sel_array,	wb_sel_gpio }),
		// ... and their return data back to us.
		//.i_sstall({}), 
		.i_sack({	wb_ack_ram,	wb_ack_array,	wb_ack_gpio }),
		.i_sdata({	wb_dat_o_ram,	wb_dat_o_array,	wb_dat_o_gpio })//rev
		//.i_serr({})
		// 
	);
		
endmodule
