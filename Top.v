`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/26/2019 12:21:45 AM
// Design Name: 
// Module Name: Top
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


module Top(
    input clk, rst,
    input [1:0] MMvalues, // Moisture meter values
    input [2:0] IPS,  
    input SensorA,        // SEN pins on the HBridge
    input SensorB,        // SEN pins on the HBridge
    input IR,
    output [3:0] HBridgeIN,
    output [1:0] HBridgeEN,
    output [6:0] seg,
    output [3:0] an,
    output [3:0] Servo
    );
    // Databus of all the PWM's done signals
    wire [5:0] PeriodFinished;
    
    // Done signal of the active servo PWM
    wire ActivePeriodFinished,IRModuleDone,EnableIRModule,ResetIRModule;

    // Duty cycles for the HBridge EN pins
    wire [11:0] DutyA, DutyB;

    // Duty cycle of the active servo PWM
    wire [20:0] ActiveServoDuty;

    // All of the duty cycles for the four servos in one flattened databus
    wire [83:0] ServoDuty;

    // HBridge IN pins
    wire [3:0] Direction;

    // Select bit into ServoMUX
    wire [1:0] ServoNum;

    assign HBridgeIN = Direction;
    
//       assign led = sw;

//       assign ServoDuty = (sw[2:0] == 3'b001) ? 20'd200000 :

//                          (sw[2:0] == 3'b010) ? 20'd150000 :

//                          (sw[2:0] == 3'b100) ? 20'd100000 : 20'd100000;


// PWMS
    // HBridge EN PWMs
    // LEFT
//--------------------------------
//If the 4000 is to move this direction for 4000 units of time, you should change to detection by
//  IPS, not time. 
    PWM #(12,4000) u0 (
        .clock(clk),
        .duty(DutyA),
        .reset(rst),
        .PWM(HBridgeEN[0]),
        .done(PeriodFinished[0])
    );

    // RIGHT
    PWM #(12,4000) u1 (
        .clock(clk),
        .duty(DutyB),
        .reset(rst),
        .PWM(HBridgeEN[1]),
        .done(PeriodFinished[1])
    );

    // Servo PWMs
    // ARM    
    
//---------------------------------
//Parameter issue? Calling 21,2000000 but parameter in PWM module is set to SIZE=12 PERIOD=4000
    PWM #(21,2000000) u2 (
        .clock(clk),
        .duty(ServoDuty[20:0]),
        .reset(rst),
        .PWM(Servo[0]),
        .done(PeriodFinished[2])
    );

    // LEFT
    PWM #(21,2000000) u3 (
        .clock(clk),
        .duty(ServoDuty[41:21]),
        .reset(rst),
        .PWM(Servo[1]),
        .done(PeriodFinished[3])
    );

    // MIDDLE
    PWM #(21,2000000) u4 (
        .clock(clk),
        .duty(ServoDuty[62:42]),
        .reset(rst),
        .PWM(Servo[2]),
        .done(PeriodFinished[4])
    );

    // RIGHT
    PWM #(21,2000000) u5 (
        .clock(clk),
        .duty(ServoDuty[83:63]),
        .reset(rst),
        .PWM(Servo[3]),
        .done(PeriodFinished[5])
    );    

    SevenSegment u6 (
        .clock(clk),
        .SensorA(SensorA),
        .SensorB(SensorB),
        .DirectionS(Direction),
        .an(an),
        .seg(seg)
    );

    IPSMovement u7 (
        .Clock(clk),
        .Reset(rst),
        .IPS(IPS),
        .Direction(Direction),
        .DutyA(DutyA),
        .DutyB(DutyB),
        .IR(IR),
        .EnableIRModule(EnableIRModule),
        .IRModuleDone(IRModuleDone),
        .ResetIRModule(ResetIRModule)
    );

    IRsensor u8 (
      .MMvalues(MMvalues),
      .Clock(clk),
      .Reset(ResetIRModule),
      .ServoNum(ServoNum),
      .ActivePeriodFinished(ActivePeriodFinished),
      .ActiveServoDuty(ActiveServoDuty),
      .EnableIRModule(EnableIRModule),
      .IRModuleDone(IRModuleDone)
    );

      ServoMUX u9 (
      .ServoDuty(ServoDuty),
      .PeriodFinished(PeriodFinished[5:2]),
      .ActivePeriodFinished(ActivePeriodFinished),
      .ServoNum(ServoNum)
    );
endmodule

//////////////////////////////////////////////////////////////////////////////////

// Company: 

// Engineer: 

// 

// Create Date: 10/16/2019 05:36:31 PM

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

//module PWM #(parameter SIZE=12, PERIOD=4000)(



//    input [SIZE-1:0] duty,

//    input clock,

//    input reset,

//    output reg PWM,

//    output done // Activates when the period is finished

//    );

    

//   reg [SIZE-1:0] counter; 

//    assign done = (counter == PERIOD) ? 1 : 0;

    

//    initial begin

//        counter = 0;

//    end

    

//    always@(posedge clock) begin

//        if (counter >= PERIOD)

//           counter = 0;

//        else

        

//        begin

//            counter=counter+1;

//            PWM = (counter < duty)? 1:0;

//        end

                     

//        end

//endmodule

