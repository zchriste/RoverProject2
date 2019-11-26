//-----------------------------------------------------------------------------
// Title         : Top
// Project       : Project Lab 1
//-----------------------------------------------------------------------------
// File          : Top.v
// Author        : Rice  <rice@rice-manjaro>
// Created       : 26.11.2019
// Last modified : 26.11.2019
//-----------------------------------------------------------------------------
// Description :
// Top module for Eli, Zo, and Abu's group in Project Lab 1. 
//-----------------------------------------------------------------------------
// Copyright (c) 2019 by Texas Tech University This model is the confidential and
// proprietary property of Texas Tech University and the possession or use of this
// file requires a written license from Texas Tech University.
//------------------------------------------------------------------------------
// Modification history :
// 26.11.2019 : created
//-----------------------------------------------------------------------------



module Top
  (/*AUTOARG*/
   // Outputs
   seg, an, HBridgeIN, HBridgeEN, Servo,
   // Inputs
   clk, SensorB, SensorA, MMvalues, IR, IPS
   );
   /*AUTOINPUT*/
   // Beginning of automatic inputs (from unused autoinst inputs)
   input [2:0]          IPS;                    // To u7 of IPSMovement.v
   input                IR;                     // To u7 of IPSMovement.v
   input [1:0]          MMvalues;               // To u8 of IRSensor.v
   input                SensorA;                // To u6 of SevenSegment.v
   input                SensorB;                // To u6 of SevenSegment.v
   input                clk;                    // To u0 of PWM.v, ...
   // End of automatics
   output [3:0] HBridgeIN;
   output [1:0] HBridgeEN;
   output [3:0] Servo;

   /*AUTOOUTPUT*/
   // Beginning of automatic outputs (from unused autoinst outputs)
   output [3:0]         an;                     // From u6 of SevenSegment.v
   output [6:0]         seg;                    // From u6 of SevenSegment.v
   // End of automatics
   wire [3:0]           ServoPeriodFinished;    // From u2, u3, u4, u5 of PWM.v
   /*AUTOWIRE*/
   // Beginning of automatic wires (for undeclared instantiated-module outputs)
   wire                 ActivePeriodFinished;   // From u9 of ServoMUX.v
   wire [20:0]          ActiveServoDuty;        // From u8 of IRSensor.v
   wire [3:0]           Direction;              // From u7 of IPSMovement.v
   wire [11:0]          DutyA;                  // From u7 of IPSMovement.v
   wire [11:0]          DutyB;                  // From u7 of IPSMovement.v
   wire                 EnableIRModule;         // From u7 of IPSMovement.v
   wire                 IRModuleDone;           // From u8 of IRSensor.v
   wire                 PeriodFinished;         // From u0 of PWM.v, ...
   wire                 ResetIRModule;          // From u7 of IPSMovement.v
   wire [83:0]          ServoDuty;              // From u9 of ServoMUX.v
   wire [1:0]           ServoNum;               // From u8 of IRSensor.v
   // End of automatics
   //--------------------------------
   //If the 4000 is to move this direction for 4000 units of time, you should change to detection by
   //  IPS, not time.
   // ^^ That's not what the 4000 is. It's a parameter that determines the period of the PWM signal.
   // The period is the time it takes for the Basys 3 to count that many clock cycles, in this case 4000
   // clock cycles. Each clock cycle takes 10 ns. So the period is 4000 x 10ns, producing a 25kHz signal.

   PWM #(12,4000) u0 
     (.width(DutyA[11:0]),
      .PWM(HBridgeEN[0]),
      /*AUTOINST*/
      // Outputs
      .PeriodFinished                   (PeriodFinished),
      // Inputs
      .clk                              (clk));

   // RIGHT
   PWM #(12,4000) u1
     (.width(DutyB[11:0]),
      .PWM(HBridgeEN[1]),
      /*AUTOINST*/
      // Outputs
      .PeriodFinished                   (PeriodFinished),
      // Inputs
      .clk                              (clk));

   // Servo PWMs
   // ARM    
   //---------------------------------
   //Parameter issue? Calling 21,2000000 but parameter in PWM module is set to SIZE=12 PERIOD=4000
   // ^^ That's just the default. If you do not call the parameters from outside the module, it defaults to that value.
   // Changing the value from outside the module is perfectly valid.
   PWM #(21,2000000) u2 
     (.width(ServoDuty[20:0]),
      .PWM(Servo[0]),
      .PeriodFinished(ServoPeriodFinished[0]),
      /*AUTOINST*/
      // Inputs
      .clk                              (clk));

   // LEFT
   PWM #(21,2000000) u3 
     (.width(ServoDuty[41:21]),
      .PWM(Servo[1]),
      .PeriodFinished(ServoPeriodFinished[1]),
      /*AUTOINST*/
      // Inputs
      .clk                              (clk));

   // MIDDLE
   PWM #(21,2000000) u4 
     (.width(ServoDuty[62:42]),
      .PWM(Servo[2]),
      .PeriodFinished(ServoPeriodFinished[2]),
      /*AUTOINST*/
      // Inputs
      .clk                              (clk));

   // RIGHT
   PWM #(21,2000000) u5 
     (.width(ServoDuty[83:63]),
      .PWM(Servo[3]),
      .PeriodFinished(ServoPeriodFinished[3]),
      /*AUTOINST*/
      // Inputs
      .clk                              (clk));    

   SevenSegment u6 
     (/*AUTOINST*/
      // Outputs
      .an                               (an[3:0]),
      .seg                              (seg[6:0]),
      // Inputs
      .Direction                        (Direction[3:0]),
      .SensorA                          (SensorA),
      .SensorB                          (SensorB),
      .clk                              (clk));

   IPSMovement u7 
     (/*AUTOINST*/
      // Outputs
      .Direction                        (Direction[3:0]),
      .DutyA                            (DutyA[11:0]),
      .DutyB                            (DutyB[11:0]),
      .EnableIRModule                   (EnableIRModule),
      .ResetIRModule                    (ResetIRModule),
      // Inputs
      .IPS                              (IPS[2:0]),
      .IR                               (IR),
      .IRModuleDone                     (IRModuleDone),
      .clk                              (clk));

   IRSensor u8
     (/*AUTOINST*/
      // Outputs
      .ActiveServoDuty                  (ActiveServoDuty[20:0]),
      .IRModuleDone                     (IRModuleDone),
      .ServoNum                         (ServoNum[1:0]),
      // Inputs
      .ActivePeriodFinished             (ActivePeriodFinished),
      .EnableIRModule                   (EnableIRModule),
      .MMvalues                         (MMvalues[1:0]),
      .ResetIRModule                    (ResetIRModule),
      .clk                              (clk));

   ServoMUX u9 
     (/*AUTOINST*/
      // Outputs
      .ActivePeriodFinished             (ActivePeriodFinished),
      .ServoDuty                        (ServoDuty[83:0]),
      // Inputs
      .ActiveServoDuty                  (ActiveServoDuty[20:0]),
      .ServoNum                         (ServoNum[1:0]),
      .ServoPeriodFinished              (ServoPeriodFinished[3:0]));

endmodule
