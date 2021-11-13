`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/11/18 14:41:09
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


module key (clk,reset,row,col,SSD);
input clk,reset;
input [3:0] row;
output [3:0] col;
output [6:0] SSD;
reg [3:0] col;
reg [6:0] SSD;
//reg [5:0] count;//delay_20ms
reg [2:0] state;  //״̬��־
reg key_flag;   //������־λ
//reg clk_1000khz;  //1000KHZʱ���ź�
reg [3:0] col_reg;  //�Ĵ�ɨ����ֵ
reg [3:0] row_reg;  //�Ĵ�ɨ����ֵ

/* always @(posedge clk)
if(reset) begin clk_1000khz<=0; count<=0; end
else
begin
if(count>=50) begin clk_1000khz<=~clk_1000khz;count<=0;end
else count<=count+1;
end
*/
always @(posedge clk)
if(reset) begin col<=4'b1111;state<=0;end
else
begin
case (state)
0:
 begin
col[3:0]<=4'b1111;
key_flag<=1'b0;
if(row[3:0]!=4'b0000) begin state<=1;col[3:0]<=4'b0001;end //�м����£�ɨ���һ��
else state<=0;
end
1: 
begin
if(row[3:0]!=4'b0000) begin state<=5;end   //�ж��Ƿ��ǵ�һ��
else  begin state<=2;col[3:0]<=4'b0010;end  //ɨ��ڶ���
end
2:
begin   
if(row[3:0]!=4'b0000) begin state<=5;end    //�ж��Ƿ��ǵڶ���
else  begin state<=3;col[3:0]<=4'b0100;end  //ɨ�������
end
3:
begin   
if(row[3:0]!=4'b0000) begin state<=5;end   //�ж��Ƿ��ǵ���һ��
else  begin state<=4;col[3:0]<=4'b1000;end  //ɨ�������
end
4:
begin   
if(row[3:0]!=4'b0000) begin state<=5;end  //�ж��Ƿ��ǵ�һ��
else  state<=0;
end
5:
begin 
if(row[3:0]!=4'b0000)
begin
col_reg<=col;  //����ɨ����ֵ
row_reg<=row;  //����ɨ����ֵ
state<=5;
key_flag<=1'b1;  //�м�����
end            
else
begin state<=0;end
end   
endcase
end          

always @(clk or col_reg or row_reg)
begin
if(key_flag==1'b1)
begin
case ({col_reg,row_reg})
8'b0001_0001:SSD = 7'b0000001;
8'b0001_0010:SSD = 7'b1001111;
8'b0001_0100:SSD = 7'b0010010;
8'b0001_1000:SSD = 7'b0000110;
8'b0010_0001:SSD = 7'b1001100;
8'b0010_0010:SSD = 7'b0100100;
8'b0010_0100:SSD = 7'b0100000;
8'b0010_1000:SSD = 7'b0001111;
8'b0100_0001:SSD = 7'b0000000;
8'b0100_0010:SSD = 7'b0000100;
8'b0100_0100:SSD = 7'b0001000;
8'b0100_1000:SSD = 7'b1100000;
8'b1000_0001:SSD = 7'b0110001;
8'b1000_0010:SSD = 7'b1000010;
8'b1000_0100:SSD = 7'b0110000;
8'b1000_1000:SSD = 7'b0111000;    
endcase
end  
end      
endmodule
