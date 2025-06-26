module password_checker_tb();

logic clk;
logic rst_n;
logic empty;
logic [7:0]code;

localparam PASSWORD_WIDTH = 4;

localparam T = 8'h2c;
localparam E = 8'h24;
localparam S = 8'h1B;
localparam R = 8'h3c;

logic[PASSWORD_WIDTH-1:0][7:0] password = { T, E, S, T};
logic[PASSWORD_WIDTH-1:0] leds;
password_checker dut(
    .clk(clk),
    .rst_n(rst_n),
    .empty(empty),
    .code(code),
    .password(password),
    .leds(leds)
);

initial begin
    empty <= 0;
    leds <= 4'b0000;
    rst_n <= 1;
    clk <= 0;
    forever #10 clk = ~clk;
end

initial begin
    @(posedge clk);
    code <= R;
    assert (leds == 4'b0000);
    @(posedge clk);
    code <= T;
    assert (leds == 4'b1000);
    @(posedge clk);
    code <= E;
    assert (leds == 4'b1100);
    @(posedge clk);
    code <= S;
    assert (leds == 4'b1110);
    @(posedge clk);
    code <= T;
    assert (leds == 4'b1111);
    @(posedge clk);
    @(posedge clk);
end

endmodule