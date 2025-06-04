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


logic[PASSWORD_WIDTH-1:0][7:0] password = { 8'h2c, 8'h24, 8'h1B, 8'h2c };
password_checker pc(
    .rst_n(rst_n),
    .clk(sys_clk),
    .empty(empty),
    .code(data_out),
    .password(password)
);   
endmodule
