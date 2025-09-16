module cordic #(
    parameter int POINT_WIDTH = 16,
    parameter int ANGLE_WIDTH = 16,
    parameter int ITERATIONS  = 16
) (
    input logic clk,
    input logic rst_n,
    input logic signed [POINT_WIDTH] x_in,
    input logic signed [POINT_WIDTH] y_in,
    input logic signed [ANGLE_WIDTH] z_in,
    input logic start,
    output logic signed [POINT_WIDTH] x_out,
    output logic signed [POINT_WIDTH] y_out,
    output logic signed [ANGLE_WIDTH] z_out,
    output logic done
);

  // types
  localparam real PI = 3.141592653589793;
  typedef enum logic {
    IDLE,
    COMPUTE,
    DONE
  } state_e;
  state_e state;

  // local variables
  logic signed [POINT_WIDTH][ITERATIONS] x_reg;
  logic signed [POINT_WIDTH][ITERATIONS] y_reg;
  logic signed [ANGLE_WIDTH][ITERATIONS] z_reg;
  logic signed [ANGLE_WIDTH][ITERATIONS] z_reg;
  logic [$clog2(ITERATIONS)] iteration;
  logic signed [ANGLE_WIDTH] current_z;
  logic signed [ANGLE_WIDTH-1:0] arctan_table[ITERATIONS];
  initial begin
    for (int i = 0; i < ITERATIONS; i++) begin
      arctan_table[i] = $rtoi($atan(2.0 ** (-i)) * (2.0 ** (ANGLE_WIDTH - 2)) / PI);
    end
  end

  always_ff @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
      current_state <= IDLE;
      done <= 0;
      iteration <= '0;
      current_z <= '0;
      x_reg <= '0;
      y_reg <= '0;
      z_reg <= '0;
      x_out <= '0;
      y_out <= '0;
      z_out <= '0;
    end else begin

      unique case (state)
        IDLE: begin
          if (start) begin
            current_z <= '0;

            logic [1:0] quadrant;
            quadrant <= angle[31:30];

            unique case (quadrant)
              // no changes needed for these quadrants
              2'b00, 2'b11: begin
                x_reg[0] <= x_in;
                y_reg[0] <= y_in;
                z_reg[0] <= z_in;
              end
              // subtract pi/2 for angle in this quadrant
              2'b01: begin
                x_reg[0] <= -y_in;
                y_reg[0] <= x_in;
                z_reg[0] <= {2'b00, z_in[ANGLE_WIDTH-2:0]};
              end
              // add pi/2 to angles in this quadrant
              2'b10: begin
                x_reg[0] <= y_in;
                y_reg[0] <= -x_in;
                z_reg[0] <= z_in;
                z_reg[0] <= {2'b11, z_in[ANGLE_WIDTH-2:0]};
              end
            endcase

          end
        end
        COMPUTE: begin
          logic direction;
          direction <= z_reg[iteration] >= current_z;

          if (direction) begin
            x_reg[iteration+1] <= x_reg[iteration] + (y_reg[iteration] >>> iteration);
            y_reg[iteration+1] <= y_reg[iteration] - (x_reg[iteration] >>> iteration);
            angle_reg[iteration+1] <= angle_reg[iteration] + arctan_table[iteration];
          end else begin
            x_reg[iteration+1] <= x_reg[iteration] - (y_reg[iteration] >>> iteration);
            y_reg[iteration+1] <= y_reg[iteration] + (x_reg[iteration] >>> iteration);
            angle_reg[iteration+1] <= angle_reg[iteration] - arctan_table[iteration];
          end

          iteration <= iteration + 1;
        end
        DONE: begin
          x_out <= x_reg[ITERATIONS];
          y_out <= y_reg[ITERATIONS];
          z_out <= z_reg[ITERATIONS];
          done  <= 1;
        end
      endcase

    end
  end

endmodule

