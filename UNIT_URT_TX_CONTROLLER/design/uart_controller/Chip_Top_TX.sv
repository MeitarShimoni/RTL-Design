module Chip_Top_TX(
    input system_clock,
    input cpu_rst_n,
    
    input start_push,
    input [1:0] delay,
    input [7:0] data_to_send,
    input [1:0] num_bytes_to_send,

    output tx,
    output led_toggle,
    // output [14:0] data_counter, // temporaty
    output busy,
    output done,

    output [6:0] cathodes_out,
    output [7:0] anode_out,
    output [7:0] delay_latch
    );

reg clk_32;
reg [7:0] data_latch;
// reg [7:0] delay_latch;
reg [14:0] bytes_to_send;
reg [15:0] data_counter;
assign led_toggle = data_counter[0];


// -------------------------------------- latch input ----------------------------------------------------
button_counter btn_instance(.clk(system_clock), .CE(clk_32), .reset_n(cpu_rst_n), 
.center_button(start_push), .data(data_to_send), .delay(delay),
.bytes2send(num_bytes_to_send), .start_latch(start_latch), .data_latch(data_latch), .bytes_to_send(bytes_to_send), 
.delay_latch(delay_latch));

// instnace the top module
top_transmitter UART_TX_CONTROLLER(.system_clock(system_clock), .rst_n(cpu_rst_n), .start(start_latch),
.data_to_send(data_latch), .num_bytes_to_send(bytes_to_send),  .data_counter(data_counter),
.tx(tx) , .busy(busy), .done(done) );
// .delay(delay_latch),

// ---------------------------------------- display ----------------------------------------------------
clock_divider32 clk_div3200(.sys_clk(system_clock), .reset_n(cpu_rst_n), .clk_32(clk_32));


top_seven_segment_controller display(.system_clock(system_clock), .clock_enable(clk_32),
.cpu_rst_n(cpu_rst_n), .value2disp({data_counter[7:0],bytes_to_send[7:0], delay_latch, data_latch}), .cathodes_out(cathodes_out), .anode_out(anode_out)
);



endmodule