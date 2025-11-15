

module tb_chip_top;


logic system_clock, cpu_rst_n, start;

logic [1:0] delay;
logic [1:0] num_bytes_to_send;
logic [7:0] data_to_send;
logic tx, led_toggle;
// logic [14:0] data_counter;
logic busy, done;

logic [6:0] cathodes_out;
logic [7:0] anode_out;
logic [7:0] delay_latch;

Chip_Top_TX DUT(
    .system_clock(system_clock),
    .cpu_rst_n(cpu_rst_n),

    .start_push(start),
    .delay(delay),
    .data_to_send(data_to_send),
    .num_bytes_to_send(num_bytes_to_send),
    .tx(tx),
    .led_toggle(led_toggle),
    // .data_counter(data_counter),
    .busy(busy),
    .done(done),

    .cathodes_out(cathodes_out),
    .anode_out(anode_out)
    ,.delay_latch(delay_latch) // temporary

);

// instances clock divider for baud rate
clock_divider clk_dut(.system_clock(system_clock), .rst_n(cpu_rst_n),
.clock_enable(CE));

// num_bytes_to_send
// 00 - > 1
// 01 - > 10
// 10 - > 128
// 11 - > 256

// delay :
// 00 - > 0
// 00 - > 50ms not working yet
// 00 - > 100ms not working yet
// 00 - > 200ms not working yet

always #5 system_clock = ~system_clock;

initial begin

    system_clock = 0;
    cpu_rst_n = 1;
    data_to_send = 0;
    start = 0;
    @(negedge system_clock) cpu_rst_n = 0;
    @(negedge system_clock) cpu_rst_n = 1;

    repeat(30) @(posedge CE);
    // ---------------- TEST 1: Send 10 Bytes ------------------
    data_to_send = 8'h51;
    num_bytes_to_send = 2'b01; // send 10
    @(posedge CE);
    start = 1;
    repeat(100) @(posedge CE);
    start = 0;

    // ------------------ TEST 2: Send 128 bytes ---------------
    @(negedge busy);
    repeat(100) @(posedge CE);
    data_to_send = 123;
    num_bytes_to_send = 2;
    start = 1;
    repeat(200) @(posedge CE);
    start = 0;

    @(negedge busy);
    repeat (100) @(posedge CE);
    $finish;

end

endmodule