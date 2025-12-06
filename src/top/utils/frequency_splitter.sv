module frequency_splitter #(
    parameter N = 2
) (
    input           clk_in,
    input           rst_n,
    output logic    clk_out
);

localparam[$clog2(N)-1:0] n = N;
logic[$clog2(N)-1:0] cnt;

always_ff @(posedge clk_in or negedge rst_n) begin
    if(~rst_n)
    begin
        clk_out <=   '0;
        cnt     <=   '0;
    end
    else
	 begin
	 if(cnt == n)    begin
        clk_out <= ~clk_out;
        cnt     <=       '0;
    end
    else
        cnt <=  cnt +   1'b1;        
    end
end
    
endmodule
