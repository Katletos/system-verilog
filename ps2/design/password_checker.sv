module password_checker #(parameter PASSWORD_WIDTH = 4) (
    input  logic clk, rst_n, empty,
    input  logic[7:0] code,
    input  logic[PASSWORD_WIDTH-1:0][7:0] password,
    output logic[PASSWORD_WIDTH-1:0] leds
);

typedef enum { FIRST, SECOND, THIRD, FOURTH } state;
state st;

always_ff @(posedge clk, negedge rst_n)
    if (~rst_n) begin 
        st <= FIRST;
        leds <= {PASSWORD_WIDTH{1'b0}};
    end else begin
        if (~empty) begin 
            unique case (st)
                FIRST:  begin if (password[0] == code) st <= SECOND; leds[0] = 1; end
                SECOND: begin if (password[1] == code) st <= THIRD;  leds[1] = 1; end
                THIRD:  begin if (password[2] == code) st <= FOURTH; leds[2] = 1; end
                FOURTH: begin if (password[3] == code) st <= FIRST;  leds[3] = 1; end
            endcase       
        end
    end
endmodule