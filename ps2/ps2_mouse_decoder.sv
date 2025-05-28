module ps2_mouse_detector(
    input  logic clk, rst_n,
    input  logic[7:0] in,
    output logic out
);

typedef enum { FIND_FIRST, SECOND, THIRD } state;
state st;

always_ff @(posedge clk, negedge rst_n) begin
    if (rst_n) begin 
        st <= FIND_FIRST;
        out <= 0;
    end else begin
        unique case (st)
            FIND_FIRST: begin 
                if (in[3] == 1) st <= SECOND;
                out <= 0;
            end
            SECOND: st <= THIRD; 
            THIRD: begin
                st <= FIND_FIRST;
                out <= 1;
            end
        endcase
    end
end

endmodule
