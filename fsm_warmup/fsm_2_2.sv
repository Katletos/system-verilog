module fsm_2_2(
    output logic z,
    input logic clk, rst_n, x
);

typedef enum {
    INVERT,
    COPY
} fsm_state;
fsm_state state;

always_comb
    if (rst_n) begin 
        state  <= COPY;
        z      <= 0;
    end else begin 
        unique case (state)
            COPY   : begin
                state <= x ? INVERT : COPY;
                z <= x;
            end
            INVERT : z = ~x;
        endcase
    end
endmodule
