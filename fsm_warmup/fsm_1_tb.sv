module fsm_1_tb();


logic clk;
logic A;
logic B;
logic Q;
logic reset;

fsm_1 dut (.*);

initial begin 
    clk <= 0;
    A <= 0;
    B <= 0;
    Q <= 0;
    
    forever #10 clk = ~clk;
end

initial begin 
    reset <= 0;
    #15;
    @(posedge clk);
    reset <= 1;
    #2;
    A <= 1;
    @(posedge clk);
    A <= 1;
    @(posedge clk);
    B <= 0;
    @(posedge clk);
    B <= 1;
    @(posedge clk);
    B <= 1;
end

endmodule
