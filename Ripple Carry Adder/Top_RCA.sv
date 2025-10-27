

`timescale 1ns/1ps

module Top_RCA(
    
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);

wire C0,C1,C2,C3,C4,C5,C6;
// instanciate the FAs

Full_Adder FA0(.A(a[0]), .B(b[0]), .Cin(cin), .S(sum[0]), .Cout(C0) );

Full_Adder FA1(.A(a[1]), .B(b[1]), .Cin(C0), .S(sum[1]), .Cout(C1) );

Full_Adder FA2(.A(a[2]), .B(b[2]), .Cin(C1), .S(sum[2]), .Cout(C2) );

Full_Adder FA3(.A(a[3]), .B(b[3]), .Cin(C2), .S(sum[3]), .Cout(C3) );

Full_Adder FA4(.A(a[4]), .B(b[4]), .Cin(C3), .S(sum[4]), .Cout(C4) );

Full_Adder FA5(.A(a[5]), .B(b[5]), .Cin(C4), .S(sum[5]), .Cout(C5) );

Full_Adder FA6(.A(a[6]), .B(b[6]), .Cin(C5), .S(sum[6]), .Cout(C6) );

Full_Adder FA7(.A(a[7]), .B(b[7]), .Cin(C6), .S(sum[7]), .Cout(cout) );



endmodule