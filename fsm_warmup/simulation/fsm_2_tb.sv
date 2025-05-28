module fsm_2_tb();

logic clk;
logic rst_n;
logic x;
logic z_1;
logic z_2;

fsm_2_1 dut_1(.z(z_1), .*);
fsm_2_2 dut_2(.z(z_2), .*);

initial begin 
    clk <= 0;
    forever #10 clk = ~clk;  
end

initial begin
    x <= 0;
    rst_n <= 1;    
    @(posedge clk);
    rst_n <= 0;

    @(posedge clk);
    @(posedge clk);
    x <= 1;
    @(posedge clk);
    x <= 0;
    @(posedge clk);
    x <= 1;
    @(posedge clk);
    x <= 1;
    @(posedge clk);
    x <= 0;
    @(posedge clk);
end
  
endmodule
