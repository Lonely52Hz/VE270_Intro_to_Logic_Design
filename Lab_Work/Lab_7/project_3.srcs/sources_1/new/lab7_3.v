`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/12/03 01:13:12
// Design Name: 
// Module Name: lab7_3
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


module roll(a3, a2, a1, a0, clk);
input clk;
output [2:0] a3, a2, a1, a0;
reg [2:0] a3, a2, a1, a0;
always @ (posedge clk)
begin
a3 = a2;//next one
a2 = a1;//next one
a1 = a0;//next one
a0 = a0 + 1'b1;//next one
end
endmodule
//////////////////////////////////////////////////////////////////////////////////
module roll_dis(ssd, a);
input [2:0] a;
output [6:0] ssd;
reg [6:0] ssd;
always @ (a)
begin
case (a)
3'b000: ssd = 7'b1110001;//L
3'b001: ssd = 7'b0000001;//O
3'b010: ssd = 7'b1000001;//V
3'b011: ssd = 7'b0110000;//E
3'b100: ssd = 7'b0010010;//2
3'b101: ssd = 7'b0001111;//7
3'b110: ssd = 7'b0000001;//0
3'b111: ssd = 7'b1111111;//space
endcase
end
endmodule
//////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////
module number_dis(ssd1, ssd0, sum);
input [3:0] sum;
output [6:0] ssd1, ssd0;
reg [6:0] ssd1,ssd0;
always @ (sum)
begin
case (sum)
4'b0000: begin ssd0 = 7'b0000001; ssd1 = 7'b1111111;end//0
4'b0001: begin ssd0 = 7'b1001111; ssd1 = 7'b1111111;end//1
4'b0010: begin ssd0 = 7'b0010010; ssd1 = 7'b1111111;end//2
4'b0011: begin ssd0 = 7'b0000110; ssd1 = 7'b1111111;end//3
4'b0100: begin ssd0 = 7'b1001100; ssd1 = 7'b1111111;end//4
4'b0101: begin ssd0 = 7'b0100100; ssd1 = 7'b1111111;end//5
4'b0110: begin ssd0 = 7'b0100000; ssd1 = 7'b1111111;end//6
4'b0111: begin ssd0 = 7'b0001111; ssd1 = 7'b1111111;end//7
4'b1000: begin ssd0 = 7'b0000000; ssd1 = 7'b1111110;end//-8
4'b1001: begin ssd0 = 7'b0001111; ssd1 = 7'b1111110;end//-7
4'b1010: begin ssd0 = 7'b0100000; ssd1 = 7'b1111110;end//-6
4'b1011: begin ssd0 = 7'b0100100; ssd1 = 7'b1111110;end//-5
4'b1100: begin ssd0 = 7'b1001100; ssd1 = 7'b1111110;end//-4
4'b1101: begin ssd0 = 7'b0000110; ssd1 = 7'b1111110;end//-3
4'b1110: begin ssd0 = 7'b0010010; ssd1 = 7'b1111110;end//-2
4'b1111: begin ssd0 = 7'b1001111; ssd1 = 7'b1111110;end//-1
endcase

end
endmodule
//////////////////////////////////////////////////////////////////////////////////
module divider_ssddisplay (clk_out,clk_in);
input clk_in;
output clk_out;
reg clk_out;
reg [14:0] cnt;
always @ (posedge clk_in)
begin
if(cnt == 15'b110000110100111)
begin
clk_out=~clk_out;
cnt=15'b0;
end
else cnt=cnt+1'b1;
end
endmodule
//////////////////////////////////////////////////////////////////////////////////
/*module divider_synchronizer (clk_out,clk_in);
input clk_in;
output clk_out;
reg clk_out;
reg [12:0] counter;
always @ (posedge clk_in)
begin
if(counter == 13'd5000)
begin
clk_out = ~clk_out;
counter = 13'd0;
end
else counter=counter+1'd1;
end
endmodule*/
//////////////////////////////////////////////////////////////////////////////////
module divider_onesecond (clk_out,clk_in);
input clk_in;
output clk_out;
reg clk_out;
reg [25:0] cnt;
always @ (posedge clk_in)
begin
if(cnt == 26'b10111110101111000001111111)
begin
clk_out=~clk_out;
cnt=26'b0;
end
else cnt=cnt+1'b1;
end
endmodule
//////////////////////////////////////////////////////////////////////////////////
module lab7(ssd, anode, overflow, clk, equal, innum, state, reset);
input clk, equal, state, reset;
input [3:0] innum;
output [6:0] ssd;
output [3:0] anode;
output overflow;
reg [3:0] anode;
reg [6:0] ssd;
wire clk_syn, clk_ssd, clk_sec;
wire [2:0] a3, a2, a1, a0;
wire [6:0] ssd_r3, ssd_r2, ssd_r1, ssd_r0, ssd_n1, ssd_n0;
reg [3:0]  sum = 0;
reg overflow;
reg sign;
reg a;

//divider_synchronizer clk1 (clk_syn,clk);
divider_ssddisplay clk2 (clk_ssd,clk);
divider_onesecond clk3 (clk_sec,clk);
roll r1 (a3, a2, a1, a0, clk_sec);
roll_dis rd1 (ssd_r3, a3);
roll_dis rd2 (ssd_r2, a2);
roll_dis rd3 (ssd_r1, a1);
roll_dis rd4 (ssd_r0, a0);

always @ (posedge equal)//adder
begin 
            sign = (sum[3] && innum[3])||(~sum[3] && ~innum[3]);
            sum = sum + innum;
            if (sign)
                begin
                    if (sum[3] != innum[3])
                            overflow = 1;
                    else
                            overflow = 0;
                end
            else 
                overflow = 0;
end


number_dis nd1 (ssd_n1, ssd_n0, sum);

initial begin
anode = 4'b1110;
end
always @ (posedge clk_ssd)//anode change
begin 
if (anode == 4'b1110) anode = 4'b1101;
else if (anode == 4'b1101) anode = 4'b1011;
else if (anode == 4'b1011) anode = 4'b0111;
else if (anode == 4'b0111) anode = 4'b1110;
end
always @ (anode or state)//judge state if in roll or adder
if (state == 0)
begin
case (anode)//in roll
4'b1110: ssd = ssd_r0;
4'b1101: ssd = ssd_r1;
4'b1011: ssd = ssd_r2;
4'b0111: ssd = ssd_r3;
endcase
end
else
begin
case (anode)//in adder
4'b1110: ssd = ssd_n0;
4'b1101: ssd = ssd_n1;
4'b1011: ssd = 7'b1111111;
4'b0111: ssd = 7'b1111111;
endcase
end
endmodule
