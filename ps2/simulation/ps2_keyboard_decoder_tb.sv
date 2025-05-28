module ps2_keyboard_decoder_tb();
 
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
    rst_n <= 0;
    clk   <= 0;  
    forever #10 clk = ~clk;
end

initial begin
    generate_keypress(
        .packed_data(packed_data)
    );
end    
    
    
task generate_keypress(
    input  logic[7:0] packed_data
);
  @(posedge clk);
  data <= 0;
  @(posedge clk);
  data <= packed_data[0];
  @(posedge clk);
  data <= packed_data[1];
  @(posedge clk);
  data <= packed_data[2];
  @(posedge clk);
  data <= packed_data[3];
  @(posedge clk);
  data <= packed_data[4];
  @(posedge clk);
  data <= packed_data[5];
  @(posedge clk);
  data <= packed_data[6];
  @(posedge clk);
  data <= packed_data[7];
  @(posedge clk);
  data <= ~^packed_data;
  @(posedge clk);
  data <= 1;
endtask
    
endmodule
