



`timescale 1ns/1ps

module tb_Top_RCA();

logic [7:0] a;
logic [7:0] b;
logic cin;

logic [7:0] behav_sum;
logic behav_cout;

logic [7:0] struct_sum;
logic struct_cout;

// instanciate

Top_RCA dut(.a(a), .b(b), .cin(cin), .sum(struct_sum), .cout(struct_cout));

FA_behav dut_behav(.a(a), .b(b), .cin(cin), .sum(behav_sum), .cout(behav_cout));

initial begin
    $monitor("Time: %t | a: %d | b: %d | beh sum: %d | beh cout: %d| struc sum: %d | struc cout: %d",
    $time,a,b,behav_sum,behav_cout,struct_sum,struct_cout);

    // initial conditions    
    a = 0;
    b = 0;
    cin = 0;
    #10;

    // CASE 1 - No Carry-out
    a = 8'h05;
    b = 8'h03;
    #0.01 assert (struct_sum == 8'h08 && behav_sum == 8'h08) $display("ASSERT 1 : No Carry-out SUCCEED!"); 
    else $display("ASSERT 1 : No Carry-out FAILD!");

    #10;
    // CASE 2 - with carry-out
    a = 8'hC0;
    b = 8'h40;
    #0.01 assert(behav_cout == 1 && struct_cout == 1) $display("ASSERT 2 : No Carry-out SUCCEED!");
    else $display("ASSERT 2 : No Carry-out FAILD!");
    #10;
    // CASE 3 - no carry_out, max value
    a = 8'h0F;
    b = 8'hF0;
    #0.01 assert((behav_sum == 8'hFF && struct_sum == 8'hFF) && (behav_cout == 0 && struct_cout == 0))
    $display("ASSERT 3 : no carry_out, max value SUCCEED!"); else 
    $display("ASSERT 3: no carry_out, max value FAILD!");
    #10;
    // CASE 4 - max overflow
    a = 8'hFF;
    b = 8'hFF;
    cin = 1'b1;
    #0.01 assert((behav_sum == 8'hFF && struct_sum == 8'hFF) && (behav_cout == 1 && struct_cout == 1))
    $display("ASSERT 4 : max overflow SUCCEED!"); else 
    $display("ASSERT 4 : max overflow FAILD!");
    #10;
    // CASE 5 - no carry-out
    cin = 1'b0;
    a = 120;
    b = 56; // sum needs to be 176;
    #0.01 assert(behav_sum == 176 && struct_sum == 176) $display("ASSERT 5 : no carry-out SUCCEED!");
    else $display("ASSERT 5 : no carry_out FAILD!");

    #10;
    $display("SIMULATION COMPLETED SECCSSESFULLY!");
    $finish;

end




endmodule
