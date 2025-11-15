module transmitter(
    input system_clock,
    input clock_enable,
    input rst_n,
    input start,
    input [7:0] data_in,
    input [14:0] num_bytes,
    // uart input & outputs
    input busy_uart,
    output reg start_uart,
    output reg [7:0] urt_tx_data,

    output reg done,
    output reg busy,
    output reg [15:0] data_counter
    
);

typedef enum logic [2:0] {IDLE,START, UART, SPECIAL_CHAR} state_e;
state_e current_state, next_state;

reg [15:0] num_bytes_counter;
reg [15:0] line_counter;

// wire clock_enable;


//-------------          ------------------------------
always @(posedge system_clock or negedge rst_n) begin
    if (!rst_n) current_state <= IDLE;
    else if(clock_enable) current_state <= next_state;
end


//-------------          ------------------------------
always @(posedge system_clock or negedge rst_n) begin
    if(!rst_n) begin
        num_bytes_counter <= 0;
        line_counter <= 0;
        data_counter <= 0;
        urt_tx_data <= 1;
        start_uart <= 0;
        busy <= 0;
    end else if(clock_enable) begin
        case (next_state)
            IDLE:
                begin
                    start_uart <= 0;
                    done <= 0;
                    busy <= 0;
                    data_counter <= 0;
                    num_bytes_counter <= 0;
                    line_counter <= 1;
                    urt_tx_data <= data_in;
                end
            START:
                begin
                    start_uart <= 1;
                    busy <= 1;
                   $display("UART %d START WITH DATA: %h Actual DATA: %d",num_bytes_counter, urt_tx_data,data_counter);
                end
            UART:
                begin
                    start_uart <= 0;
                end
            SPECIAL_CHAR:
                begin
                    
                    start_uart <= 0;
                    num_bytes_counter <= num_bytes_counter + 1;
                    line_counter <= line_counter+1; 
                    if(line_counter == (num_bytes*2-1)) begin // NEW LINE
                        urt_tx_data <= 8'h0D;
                    end else if(line_counter == num_bytes*2) begin
                        urt_tx_data <= 8'h0A;
                        line_counter <= 0;
                    end else if((line_counter[0] == 1) && (line_counter != num_bytes*2) && (line_counter != num_bytes*2-2) ) begin // SPACE
                        urt_tx_data <= 8'h20; // SPACE
                    end else begin 
                        urt_tx_data <= data_in;
                        data_counter <= data_counter + 1;
                    end
                    if((data_counter == num_bytes*num_bytes-1)) done <= 1;
                    // num_bytes_counter <= num_bytes_counter + 1;
                end
            default: start_uart <= 0;
        endcase
    end
end

//-------------          ------------------------------
always @(*) begin
    case (current_state)
        IDLE: next_state = (start == 1) ? START : IDLE;
        START: next_state = UART;
        UART: next_state = (busy_uart == 0) ? SPECIAL_CHAR : UART;
        SPECIAL_CHAR: next_state = (data_counter == num_bytes*num_bytes) ? IDLE : START;
        default: next_state = IDLE;
    endcase
end
endmodule