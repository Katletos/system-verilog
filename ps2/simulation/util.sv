// need data and clk signal
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
