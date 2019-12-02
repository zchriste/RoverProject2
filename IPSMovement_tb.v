module IPSMovement_tb;

   /*AUTOWIRE*/
   // Beginning of automatic wires (for undeclared instantiated-module outputs)
   wire [3:0]           Direction;              // From uut of IPSMovement.v
   wire [11:0]          DutyA;                  // From uut of IPSMovement.v
   wire [11:0]          DutyB;                  // From uut of IPSMovement.v
   wire                 EnableIRModule;         // From uut of IPSMovement.v
   wire                 ResetIRModule;          // From uut of IPSMovement.v
   // End of automatics
   /*AUTOREGINPUT*/
   // Beginning of automatic reg inputs (for undeclared instantiated-module inputs)
   reg [2:0]            IPS;                    // To uut of IPSMovement.v
   reg                  IR;                     // To uut of IPSMovement.v
   reg                  IRModuleDone;           // To uut of IPSMovement.v
   reg                  clk;                    // To uut of IPSMovement.v
   // End of automatics

   IPSMovement uut
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

   initial
     begin
        $dumpfile("IPSMovement_dmp.vcd");
        $dumpvars(0,IPSMovement_tb);
        IPS<=0;
        IR<=0;
        IRModuleDone<=0;
        clk<=0;
        #1000 $dumpflush;
        $finish;
     end // initial begin

   always #5 clk=~clk;
   always #100 IPS=IPS+1;
   
endmodule
