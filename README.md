# Box-Muller-Transform
This project is based on ASIC design and verification.  
The objective of this project is to implement the Box-Muller transform to convert two random numbers to a Gaussian random number distribution.   
Floating point adder and multiplier are designed and synchronized by pipelining the design (with push/stop model) up to 45 pipeline stages to accomplish the goal. This design works on 220 MHz & 300 MHz. Design is simulated, synthesized and optimized along with RTL and gate level simulation to meet timing constraints.    
Testing is done by using Scan Chain Method.   
Functional design is done in Verilog. RTL simulation is done in VCS simulator.    
Pre-synthesis and post-synthesis are done in Synopsys Design Compiler and Design Vision.      
Application of this project is that it is used in random number generation for generating test cases in testability.   
I have attached all Verilog files for this project which are designed.   

Tools: Synopsys VCS, Design Compiler, Design Vision or any other EDA tools.  
Programming language: Verilog    

Top module: randist.v
Design modules: fpmul.v, fpadd.v, sqrtln.v, sin.v, DW02_mult_5_stage.v
Simulation script: ./runrandist
Synthesis script: synthesis.script
testbench: trand.v
Synthesis result file: synres.txt
Simulation result file: simres.txt

All done with smile.... :) :) 

 
