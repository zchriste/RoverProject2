`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/26/2019 12:47:16 AM
// Design Name: 
// Module Name: ServoMUX
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

// Help from Rice
module ServoMUX(
    input [3:0]   ServoPeriodFinished,
    input [1:0]   ServoNum,
    input [20:0]  ActiveServoDuty,
    output        ActivePeriodFinished,
    output [83:0] ServoDuty
    );    
    assign ActivePeriodFinished = ServoPeriodFinished[ServoNum];
    assign ServoDuty = {21'd0, 21'd0, 21'd0, ActiveServoDuty}
            << 21 * ServoNum;
endmodule
