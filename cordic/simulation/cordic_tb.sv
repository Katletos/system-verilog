module cordic_tb ();
    localparam WIDTH = 16;
    localparam ITERATIONS = 16;
    localparam ANGLE_WIDTH = 16;
    
    logic clk;
    logic rst_n;
    logic start;
    logic [WIDTH-1:0] x_in;
    logic [WIDTH-1:0] y_in;
    logic [ANGLE_WIDTH-1:0] z_in;
    logic [WIDTH-1:0] x_out;
    logic [WIDTH-1:0] y_out;
    logic [ANGLE_WIDTH-1:0] z_out;
    logic done;
    logic busy;
    
    cordic #(
        .POINT_WIDTH(WIDTH),
        .ITERATIONS(ITERATIONS),
        .ANGLE_WIDTH(ANGLE_WIDTH)
    ) dut (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .x_in(x_in),
        .y_in(y_in),
        .z_in(z_in),
        .x_out(x_out),
        .y_out(y_out),
        .z_out(z_out),
        .done(done)
    );

  initial begin
    forever #10 clk = ~clk;
  end

  localparam real P = 1.64676;
  logic[ANGLE_WIDTH-1:0] expected_x, expected_y, expected_z;

  initial begin
        clk = 0;
        rst_n = 0;
        start = 0;
        x_in = 0;
        y_in = 0;
        z_in = 0;
        
        @(posedge clk);
	rst_n = 1;

	// [x, y, z] -> [P(x*cos(z) - y*sin(z)), P(y*cos(z) + x*sin(z)), 0]
        @(posedge clk);
        x_in = 1563;
        y_in = 60123;
        x_in = 15563;

        expected_x = ANGLE_WIDTH'($rtoi(P * (x_in * $cos(z_in) - y_in * $sin(z_in))));
	expected_y = ANGLE_WIDTH'($rtoi(P + (y_in * $cos(z_in) + x_in * $sin(z_in))));
	expected_z = '0;

        start = 1;
        @(posedge clk);
        wait(done);

	// [K, 0, a] -> [cos(a), sin(a), 0]
        @(posedge clk);
        x_in = 1563;
        y_in = 60123;
        x_in = 15563;

        expected_x = ANGLE_WIDTH'($rtoi(P * (x_in * $cos(z_in) - y_in * $sin(z_in))));
	expected_y = ANGLE_WIDTH'($rtoi(P + (y_in * $cos(z_in) + x_in * $sin(z_in))));
	expected_z = '0;

        start = 1;
        @(posedge clk);
        wait(done);
        
	// [x, 0, z] -> [P * x * cos(z), P * x * sin(z), 0]
        @(posedge clk);
        x_in = 1563;
        y_in = 60123;
        x_in = 15563;

        expected_x = ANGLE_WIDTH'($rtoi(P * (x_in * $cos(z_in) - y_in * $sin(z_in))));
	expected_y = ANGLE_WIDTH'($rtoi(P + (y_in * $cos(z_in) + x_in * $sin(z_in))));
	expected_z = '0;

        start = 1;
        @(posedge clk);
        wait(done);

        $finish;
  end

endmodule

