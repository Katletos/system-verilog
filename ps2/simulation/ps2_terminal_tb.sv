module terminal_tb();
`include "util.sv"

localparam PASS_W = 4;
logic[PASS_W -1 :0] leds;
logic data;
logic rst_n;
logic clk;
logic sys_clk;

terminal_top #(PASS_W) dut(
    .rst_n(rst_n),
    .data(data),
    .sys_clk(sys_clk),
    .keyboard_clk(clk),
    .leds(leds)
);

initial begin 
    sys_clk <= 0;
    forever #1 sys_clk = ~sys_clk;
end

initial begin
    clk <= 0;
    forever #10 clk = ~clk;
end

logic[7:0] packed_data = 'b1010_1010;
initial begin
    rst_n <= 1;
    @(posedge clk);

    generate_keypress(
        .packed_data(packed_data)
    );
    
    #500;
end

endmodule