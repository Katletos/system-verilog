`timescale 1ns / 1ps

module terminal_top #(
    PASSWORD_WIDTH = 4  
) (
    input  logic rst_n,
    input  logic data,
    input  logic sys_clk,
    input  logic keyboard_clk,
    output logic[PASSWORD_WIDTH-1:0] leds
);

logic [7:0] decoded_code;
logic done_decoding;
ps2_keyboard_decoder keyboard_decoder(
    .rst_n(rst_n),
    .data(data),
    .clk(keyboard_clk),
    .code(decoded_code),
    .done(done_decoding)
);

logic full, empty;
logic [7:0] data_out;
asynchronous_fifo #(
    .DEPTH(PASSWORD_WIDTH),
    .DATA_WIDTH(8)
) fifoinst (
    .w_en(done_decoding),
    .r_en(1),
    .wclk(keyboard_clk),
    .rclk(sys_clk),
    .wrst_n(rst_n),
    .rrst_n(rst_n),
    .data_in(decoded_code),
    .data_out(data_out),
    .empty(empty),
    .full(full)    
);

logic[PASSWORD_WIDTH-1:0][7:0] password = { 4'h2c, 4'h24, 4'h1B, 4'h2c };
terminal_logic terminal_logic (
    .rst_n(rst_n),
    .clk(sys_clk),
    .empty(empty),
    .code(data_out),
    .password(password)
);   
endmodule

module terminal_logic #(parameter PASSWORD_WIDTH = 4) (
    input  logic clk, rst_n, empty,
    input  logic[7:0] code,
    input  logic[PASSWORD_WIDTH-1:0][7:0] password,
    output logic[PASSWORD_WIDTH-1:0] leds
);

typedef enum { FIRST, SECOND, THIRD, FOURTH } state;
state st;

always_ff @(posedge clk)
    if (~rst_n) begin 
        st <= FIRST;
        leds <= {PASSWORD_WIDTH{1'b0}};
    end else begin
        if (!empty) begin 
            unique case (st)
                FIRST:  begin if (password[0] == code) st <= SECOND; leds[0] = 1; end
                SECOND: begin if (password[1] == code) st <= THIRD;  leds[1] = 1; end
                THIRD:  begin if (password[2] == code) st <= FOURTH; leds[2] = 1; end
                FOURTH: begin if (password[3] == code) st <= FIRST;  leds[3] = 1; end
            endcase       
        end
    end
endmodule
