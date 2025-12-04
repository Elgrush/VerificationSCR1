module wb_ram 
#(
	parameter BYTE_WIDTH = 8,
	parameter ADDRESS_WIDTH = 16,
	parameter [ADDRESS_WIDTH-1:0] DEPTH = 2**(ADDRESS_WIDTH-1),
	parameter NUM_BYTES = 4,
	parameter MEMFILE = "",
	parameter VERBOSE = 0,
	parameter ADDR_MASK = 32'hffff_0000
) 
(
	input wb_clk_i,
	input wb_rst_n_i,

	input [ADDRESS_WIDTH-1:0] wb_adr_i,
	input [BYTE_WIDTH*NUM_BYTES-1:0] wb_dat_i,
	input [NUM_BYTES-1:0] wb_sel_i,
	input wb_we_i,
	input wb_cyc_i,
	input wb_stb_i,

	output logic wb_ack_o,
	output logic [BYTE_WIDTH*NUM_BYTES-1:0] wb_dat_o
);

	logic [31:0] adr_r;
	wire valid = wb_cyc_i & wb_stb_i;

	always @(posedge wb_clk_i) begin
		// Ack generation
		adr_r <= wb_adr_i;
		wb_ack_o <= valid & !wb_ack_o;
		if (!wb_rst_n_i)
		begin
			adr_r <= '0;
			wb_ack_o <= 1'b0;
		end
	end

	wire ram_we = wb_we_i & valid & wb_ack_o & (((adr_r & ~(ADDR_MASK)) >> 2) < DEPTH);

	wire [31:0] waddr;
	assign waddr = (adr_r & ~(ADDR_MASK)) >> 2;
	wire [31:0] raddr;
	assign raddr = (adr_r & ~(ADDR_MASK)) >> 2;
	wire we = ram_we & (|wb_sel_i);


	logic [NUM_BYTES-1:0][BYTE_WIDTH-1:0] mem[0:DEPTH-1]; 


	always @(posedge wb_clk_i) begin
		if ((waddr) < DEPTH) begin
			if(we) begin
				if(wb_sel_i[0]) mem[waddr][0] <= wb_dat_i[0*BYTE_WIDTH +: BYTE_WIDTH];
				if(wb_sel_i[1]) mem[waddr][1] <= wb_dat_i[1*BYTE_WIDTH +: BYTE_WIDTH];
				if(wb_sel_i[2]) mem[waddr][2] <= wb_dat_i[2*BYTE_WIDTH +: BYTE_WIDTH];
				if(wb_sel_i[3]) mem[waddr][3] <= wb_dat_i[3*BYTE_WIDTH +: BYTE_WIDTH];
			end
		end

		if ((raddr) < DEPTH) wb_dat_o <= mem[raddr];
	end

	initial 
	begin
		if (MEMFILE != "")
			$readmemh(MEMFILE, mem);
	end
endmodule
