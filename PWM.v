`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/26/2019 12:34:34 AM
// Design Name: 
// Module Name: PWM
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


module PWM #(parameter SIZE=12, PERIOD=4000)(
    input [SIZE-1:0] duty,
    input clock,
    input reset,
    output reg PWM,
    output done // Activates when the period is finished
    );
    
    reg [SIZE-1:0] counter; 
    assign done = (counter == PERIOD) ? 1 : 0;

    initial begin
        counter = 0;
    end
    
    always@(posedge clock) begin
        if (counter >= PERIOD)
           counter = 0;
        else
        begin
            counter=counter+1;
            PWM = (counter < duty)? 1:0;
        end                     
        end
endmodule
