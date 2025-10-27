


`timescale 1ns/1ps

module FA_behav(
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
    );

assign {cout, sum} = a + b + cin;

endmodule

