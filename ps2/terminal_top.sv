`timescale 1ns / 1ps

module terminal_top #(
    PASSWORD_WIDTH = 4  
) (
    input  logic rst_n,
    input  logic data,
    input  logic sys_clk,
    input  logic keyboard_clk,
    output logic[PASSWORD_WIDTH-1:0] leds
);

logic [7:0] decoded_code;
logic done_decoding;
ps2_keyboard_decoder keyboard_decoder(
    .rst_n(rst_n),
    .data(data),
    .clk(keyboard_clk),
    .code(decoded_code),
    .done(done_decoding)
);

logic full, empty;
logic [7:0] data_out;
asynchronous_fifo #(
    .DEPTH(PASSWORD_WIDTH),
    .DATA_WIDTH(8)
) fifoinst (
    .w_en(done_decoding),
    .r_en(1),
    .wclk(keyboard_clk),
    .rclk(sys_clk),
    .wrst_n(rst_n),
    .rrst_n(rst_n),
    .data_in(decoded_code),
    .data_out(data_out),
    .empty(empty),
    .full(full)    
);

logic[PASSWORD_WIDTH-1:0][7:0] password = { 4'h2c, 4'h24, 4'h1B, 4'h2c };
terminal_logic terminal_logic (
    .rst_n(rst_n),
    .clk(sys_clk),
    .empty(empty),
    .code(data_out),
    .password(password)
);   
endmodule

module terminal_logic #(parameter PASSWORD_WIDTH = 4) (
    input  logic clk, rst_n, empty,
    input  logic[7:0] code,
    input  logic[PASSWORD_WIDTH-1:0][7:0] password,
    output logic[PASSWORD_WIDTH-1:0] leds
);

typedef enum { FIRST, SECOND, THIRD, FOURTH } state;
state st;

always_ff @(posedge clk)
    if (~rst_n) begin 
        st <= FIRST;
        leds <= {PASSWORD_WIDTH{1'b0}};
    end else begin
        if (!empty) begin 
            unique case (st)
                FIRST:  begin if (password[0] == code) st <= SECOND; leds[0] = 1; end
                SECOND: begin if (password[1] == code) st <= THIRD;  leds[1] = 1; end
                THIRD:  begin if (password[2] == code) st <= FOURTH; leds[2] = 1; end
                FOURTH: begin if (password[3] == code) st <= FIRST;  leds[3] = 1; end
            endcase       
        end
    end
endmodule


module ps2_keyboard_decoder(
    input  logic clk, data, rst_n,
    output logic[7:0] code,
    output logic done
);

typedef enum { START, 
               DATA0, DATA1, DATA2, DATA3, DATA4, DATA5, DATA6, DATA7,
               PARITY,
               STOP
} state;
state st;

always_ff @(posedge clk, negedge rst_n) begin
    if (~rst_n) begin 
        st <= START;
        code <= 8'b0;
    end else begin
        unique case (st)
            START:  if(data == 0) begin done <= 0; st <= DATA0; end
            DATA0:  begin code[0] <= data; st <= DATA1;  end
            DATA1:  begin code[1] <= data; st <= DATA2;  end
            DATA2:  begin code[2] <= data; st <= DATA3;  end
            DATA3:  begin code[3] <= data; st <= DATA4;  end
            DATA4:  begin code[4] <= data; st <= DATA5;  end
            DATA5:  begin code[5] <= data; st <= DATA6;  end
            DATA6:  begin code[6] <= data; st <= DATA7;  end
            DATA7:  begin code[7] <= data; st <= PARITY; end
            PARITY: st <= ~^code == data ? STOP : START;    
            STOP:   if (data == 1) begin done <= 1; st <= START; end
        endcase
    end
end

endmodule 


