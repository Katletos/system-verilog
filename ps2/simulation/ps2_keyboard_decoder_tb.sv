module ps2_keyboard_decoder_tb();
`include "util.sv"

logic[7:0] packed_data = 'b1010_1010;
    
logic data, clk, rst_n, done;
logic[7:0] code;

ps2_keyboard_decoder dut(
    .rst_n(rst_n),
    .data(data),
    .clk(clk),
    .code(code),
    .done(done)
);
    
initial begin
    clk   <= 0;  
    forever #10 clk = ~clk;
end

initial begin
    data <= 0;
    rst_n <= 0;
    @(posedge clk)
    
    generate_keypress(
        .packed_data(packed_data)
    );
end    
    
endmodule
