`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/11/18 17:25:45
// Design Name: 
// Module Name: 1
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module divider (clk_out,clk_in);
    input clk_in;
    output clk_out;
    reg clk_out;
    reg [12:0] counter;
    
    always @ (posedge clk_in)
        begin
        if(counter == 13'd5000)
        begin
        clk_out <= ~clk_out;
        counter <= 13'd0;
        end
    else counter<=counter+1'd1;
    end
endmodule

//-----------------keypad scanner--------------------------------------

module keypad_scanner(col, code, reg_load, clk, reset, row);
    input clk, reset;
    input [3:0] row;
    output reg_load;
    output [3:0] code, col;
    //output[3:0] state 
    //output[3:0] 
    reg [3:0] state;
    wire or_row;
    
    parameter s0=4'b0000;
    parameter s1=4'b0001;
    parameter s2=4'b0010;
    parameter s3=4'b0011;
    parameter s4=4'b0100;
    parameter s5=4'b0101;
    parameter s6=4'b0110;
    parameter s7=4'b0111;
    parameter s8=4'b1000;
    parameter s9=4'b1001;
    
    assign or_row=row[0]|row[1]|row[2]|row[3];
    
    always @ (posedge clk or posedge reset)
    if (reset == 1)
        begin
            state <= s0;
        end
        
    else
        begin 
            case (state)
                  s0: if (or_row == 0)  state <= s0;
                      else if (or_row == 1)  state <= s1;
                      else state <= s0;
                  s1: if (or_row == 0)  state <= s2;
                      else if (or_row == 1)  state <= s5;
                      else state <= s0;
                  s2: if (or_row == 0)  state <= s3;
                      else if (or_row == 1)  state <= s6;
                      else state <= s0;
                  s3: if (or_row == 0)  state <= s4;
                      else if (or_row == 1)  state <= s7;
                      else state <= s0;
                  s4: if (or_row == 0)  state <= s0;
                      else if (or_row == 1)  state <= s8;
                      else state <= s0;
                  s5: state <= s9;
                  s6: state <= s9;
                  s7: state <= s9;
                  s8: state <= s9;
                  s9: if (or_row == 0)  state <= s0;
                      else if (or_row == 1)  state <= s9;
                      else state <= s0;
                  default: state <= s0;
                endcase
                
        end
   
   //output assignment
    assign col[0] = ((state == s0)||(state == s1)||(state == s5 || state == s9));
    assign col[1] = ((state == s0)||(state == s2)||(state == s6 || state == s9));
    assign col[2] = ((state == s0)||(state == s3)||(state == s7 || state == s9));
    assign col[3] = ((state == s0)||(state == s4)||(state == s8 || state == s9));
    assign reg_load = ((state == s5)||(state == s6)||(state == s7 || state == s8));
    assign code[0] = (col[1] || col[3]);
    assign code[1] = (col[2] || col[3]);
    assign code[2] = (row[1] || row[3]);
    assign code[3] = (row[2] || row[3]);

endmodule

//--------------------4 bit register------------------------------------

module register_4_bit (reset, code, reg_load, clk, tossd);
    input [3:0] code;
    input reg_load, clk, reset;
    output [3:0] tossd;
    reg [3:0] tossd=4'b0000;
    
    always @ (posedge clk)
        if (reset == 1) tossd = 4'b0000;
        else begin
        if (reg_load == 1)
            tossd <= code;
        else 
            tossd <= tossd;
        end
 
endmodule

//------------------ssd----------------------
module ssd (reset, clk, ssdin, ssdout);
input clk, reset;
input [3:0] ssdin;
output [6:0] ssdout;
reg [6:0] ssdout;

    always @ (ssdin or reset)
        begin
            if (reset == 1) ssdout = 7'b0000001;
            else begin
            case (ssdin)
                4'b0000: ssdout = 7'b0000001;
                4'b0001: ssdout = 7'b1001111;
                4'b0010: ssdout = 7'b0010010;
                4'b0011: ssdout = 7'b0000110;
                4'b0100: ssdout = 7'b1001100;
                4'b0101: ssdout = 7'b0100100;
                4'b0110: ssdout = 7'b0100000;
                4'b0111: ssdout = 7'b0001111;
                4'b1000: ssdout = 7'b0000000;
                4'b1001: ssdout = 7'b0000100;
                4'b1010: ssdout = 7'b0001000;
                4'b1011: ssdout = 7'b1100000;
                4'b1100: ssdout = 7'b0110001;
                4'b1101: ssdout = 7'b1000010;
                4'b1110: ssdout = 7'b0110000;
                4'b1111: ssdout = 7'b0111000;
            endcase
            end
        end
        
endmodule



//-------------------------whole design------------------------

module lab6 (row, clk, reset, col, dis);
    input [3:0] row;
    input clk, reset;
    output [3:0] col;
    output [6:0] dis;
    //output [3:0] ssdin;
   // output[3:0]cstate;
    //output[3:0]ns;
    
    wire clk_1w, reg_load;
    wire [3:0] code, ssdin;
    
    //change the clock
    divider sychronizer (clk_1w, clk);
    
    //scanning
    keypad_scanner scanner (col, code, reg_load, clk_1w, reset, row);
    
    //register
    register_4_bit register (reset, code, reg_load, clk_1w, ssdin);
    
    //ssd
    ssd SSD (reset, clk_1w, ssdin, dis);

    
endmodule
