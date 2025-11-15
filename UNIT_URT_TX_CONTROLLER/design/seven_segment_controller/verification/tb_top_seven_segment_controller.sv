




module tb_top_seven_segment_controller;


logic system_clock;
logic clk_32;
logic cpu_rst_n;
logic [15:0] sw_in;
logic [6:0] cathodes_out;
logic [7:0] anode_out;
logic center_push;
logic down_push;

//typedef enum logic [1:0] {DECIMAL,HEXADECIMAL} state;
//state mode_e;


top_seven_segment_controller dut(.system_clock(system_clock),
         .cpu_rst_n(cpu_rst_n),
         .sw_in(sw_in),
         .center_push(center_push),
         .down_push(down_push),
         .cathodes_out(cathodes_out),
         .anode_out(anode_out),
         .clk_32(clk_32)
         );



// Clock generation
always #5 system_clock = ~system_clock;

initial begin
    system_clock = 1;
    cpu_rst_n = 0;
    center_push = 1;
    down_push = 0;
    
    @(negedge clk_32);
    cpu_rst_n = 1;
    sw_in = 16'hA2DF;
    repeat(50) @(posedge clk_32);
    sw_in = 5555;
    repeat(50) @(posedge clk_32);
    sw_in = 12345;
    // Toggle different modes
    repeat(12) @(posedge clk_32);
    center_push = 0;
    down_push = 1;
    repeat(8) @(posedge clk_32);
    center_push = 1;
    down_push = 0;
    // toggle different swiches?
    repeat(8) @(posedge clk_32);
//    sw_in = 16'hABCD;
    sw_in = 125;
    
    
    
    
    
    
    @(posedge clk_32);
    center_push = 1;
    #1500ms;
    center_push = 0;


   
    $display("Test completed");
    $finish;    


end






endmodule 