




module tb_decimal_convertor;


logic clk;
logic reset;
logic [7:0] an_sel;
logic [15:0] sw;
logic [3:0] opcode;
logic blank_dec;

logic [7:0] parallel_out;

// instance
decimal_convertor2 dut (
    .clk(clk),
    .reset(reset),
    .an_sel(parallel_out),
    .sw(sw),
    .opcode(opcode),
    .blank_dec(blank_dec)
);

rotate_register rot(.clk(clk), .reset(reset), .parallel_out(parallel_out));

// clock generation

always #5 clk = ~clk;
parameter int num  =8 ;
initial begin
    $monitor("Time=%0t | reset=%b | an_sel=%b | sw=%d | opcode=%h | blank_dec=%b",
             $time, reset, an_sel, sw, opcode, blank_dec);

    reset = 1;
    clk   = 0;
    #2;
    reset = 0;
    sw    = 16'd12345;
    @(negedge clk);                 // small delay
    reset = 1;          // <-- de-assert reset (active-low)
//    @(posedge clk);     // optional: wait a clock edge before driving an_sel

    // first state to load temp
    an_sel = 8'b1000_0000;

    repeat (num) begin
        @(posedge clk);
        an_sel = an_sel >> 1;
    end
    #5;
    an_sel = 8'b1000_0000;


    sw    = 16'd05123;
    
    repeat (num) begin
        @(posedge clk);
        an_sel = an_sel >> 1;
        #5;
    end
    #5;
    an_sel = 8'b1000_0000;

    sw    = 16'd00045;
    
    repeat (num) begin
        @(posedge clk);
        an_sel = an_sel >> 1;
        #5;
    end
    #5;
    an_sel = 8'b1000_0000;

    $finish;
end






endmodule