module top_transmitter(
    input system_clock,
    input rst_n,
    input start,
    input [7:0] data_to_send,
    input [14:0] num_bytes_to_send,
//    input [1:0] delay,
    output reg [15:0] data_counter,
    output tx
    
    ,output busy,
    output done
);



wire busy_uart;
wire start_uart;
wire [7:0] urt_tx_data;
wire clock_enable;

// instnace clock divider for baud rate
clock_divider clk_div(.system_clock(system_clock), .rst_n(rst_n), .clock_enable(clock_enable));

// instance uart
uart_fsm_1 UART_FSM(.system_clock(system_clock), .clock_enable(clock_enable), .rst_n(rst_n), 
.center_push(start_uart), .data_in(urt_tx_data), .tx_busy(busy_uart), .Tx(tx) );
// .delay(delay),

// instance FSM transmitter
transmitter control_fsm(.system_clock(system_clock), .clock_enable(clock_enable),.rst_n(rst_n),
    .start(start),.data_in(data_to_send),.num_bytes(num_bytes_to_send),
    //
    .busy_uart(busy_uart),.start_uart(start_uart), .urt_tx_data(urt_tx_data),.done(done),
    .busy(busy), .data_counter(data_counter)

);










endmodule