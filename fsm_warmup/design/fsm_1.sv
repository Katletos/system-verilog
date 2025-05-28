module fsm_1(
    input logic A,
    input logic B,
    input logic reset,
    input logic clk,
    output logic Q
);
    
typedef enum {
    st_0,
    st_1,
    st_2
} fsm_state;
fsm_state state;

always_ff @(posedge clk) begin
    Q     <= 0;
    if (~reset) begin 
        state <= st_0;
    end else begin
        unique case (state)
            st_0: state <= A ? st_1 : st_0;
            st_1: if (B) begin 
                    state <= st_2;
                    Q <= 1;
                end else begin
                    state <= st_0;
                end
            st_2: state <= st_0;
        endcase
    end   
end
endmodule
