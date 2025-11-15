module button_counter(
    input clk, 
    input CE,
    input reset_n,
    input center_button,

    input [7:0] data,
    input [1:0] delay,
    input [1:0] bytes2send,
    output reg start_latch,
    output reg [7:0] data_latch,
    output reg [14:0] bytes_to_send,
    output reg [7:0] delay_latch
    );

reg [14:0] count;

always @(posedge clk or negedge reset_n) begin  // clk 3200Hz
    if(!reset_n) begin
        count <= 0;   
        data_latch <= 0;
        bytes_to_send <= 0;
        delay_latch <= 0;
        start_latch <= 0;
    end else if(CE) begin
        if (center_button) begin
            if (count == 5) begin
                count <= 0;
                data_latch <= data;
                // delay_latch <= delay;
                start_latch <= center_button;
                case(delay) 
                    2'b00:  delay_latch = 0;
                    2'b01:  delay_latch = 50;
                    2'b10:  delay_latch = 100; 
                    2'b11:  delay_latch = 200;
                    default: delay_latch = 0;
                endcase
                case (bytes2send)
                    2'b00:  bytes_to_send = 1;
                    2'b01:  bytes_to_send = 10;
                    2'b10:  bytes_to_send = 128; 
                    2'b11:  bytes_to_send = 256;
                    default: bytes_to_send = 1;
                endcase

            end else begin
                count <= count+1;
                start_latch <= 0;
            end
        end else begin 
            start_latch <= 0;
            count <=0;
        end
    end end

endmodule