//
// This is a simple version of a 64 bit floating point multiplier 
// used in EE287 as a homework problem.
// This is a reduced complexity floating point.  There is no NaN
// overflow, underflow, or infinity values processed.
//
// Inspired by IEEE 754-2008 (Available from the SJSU library to students)
//
// 63  62:52 51:0
// S   Exp   Fract (assumed high order 1)
// 
// Note: all zero exp and fract is a zero 
// 
//

module fpmul(clk, rst, pushin, a, b, c, pushout, r);
input pushin; 	        // A valid a,b,c
input [63:0] a,b,c;	// the a,b and c inputs
output [63:0] r;	// the results from this multiply
output pushout;
input clk,rst;		// indicates we have an answer this cycle

reg sA,sB,sC;		// the signs of the a and b inputs
reg [10:0] expA, expB, expC;		// the exponents of each
reg [52:0] fractA, fractB, fractC;	// the fraction of A and B  present
reg zeroA,zeroB,zeroC;	// a zero operand (special case for later)
// result of the multiplication, rounded result, rounding constant
reg [159:0] rres,rconstant;	

reg signres;		// sign of the result
reg [10:0] expres;	// the exponent result
reg [63:0] resout;	// the output value from the always block




reg [52:0] fractC1,fractC2,fractC3,fractC4,fractC1t,fractC2t,fractC3t,fractC4t;

reg zeroA1,zeroB1,zeroC1,zeroA1t,zeroB1t,zeroC1t,zeroA2,zeroB2,zeroC2,zeroA2t,zeroB2t,zeroC2t,zeroA3,zeroB3,zeroC3,zeroA3t,zeroB3t,zeroC3t,zeroA4,zeroB4,zeroC4,zeroA4t,zeroB4t,zeroC4t,zeroA5,zeroB5,zeroC5,zeroA5t,zeroB5t,zeroC5t,zeroA6,zeroB6,zeroC6,zeroA6t,zeroB6t,zeroC6t,zeroA7,zeroB7,zeroC7,zeroA7t,zeroB7t,zeroC7t,zeroA8,zeroB8,zeroC8,zeroA8t,zeroB8t,zeroC8t,zeroA9,zeroB9,zeroC9,zeroA9t,zeroB9t,zeroC9t;

reg signres1,signres1t,signres2,signres2t,signres3,signres3t,signres4,signres4t,signres5,signres5t,signres6,signres6t,signres7,signres7t,signres8,signres8t,signres9,signres9t;

reg [10:0] expres1,expres1t,expres2,expres2t,expres3,expres3t,expres4,expres4t,expres5,expres5t,expres6,expres6t,expres7,expres7t,expres8,expres8t,expres9,expres9t;

reg pushin1,pushin2,pushin3,pushin4,pushin5,pushin6,pushin7,pushin8,pushin9;

wire [105:0] x1;
wire [158:0] y1;
reg [158:0] mres,mres9t;



assign r = resout;
assign pushout = pushin9;



always @ (posedge (clk) or posedge (rst)) begin
    if(rst) begin
//stage1   
	fractC1<=0;
	zeroA1<=0;
	zeroB1<=0;
	zeroC1<=0;
	signres1<=0;
	expres1<=0;
	pushin1<=0;   
//stage2
	fractC2<=0;
	zeroA2<=0;
	zeroB2<=0;
	zeroC2<=0;
	signres2<=0;
	expres2<=0;
	pushin2<=0;
//stage3
	fractC3<=0;
	zeroA3<=0;
	zeroB3<=0;
	zeroC3<=0;
	signres3<=0;
	expres3<=0;
	pushin3<=0;
//stage4
	fractC4<=0;
	zeroA4<=0;
	zeroB4<=0;
	zeroC4<=0;
	signres4<=0;
	expres4<=0;
	pushin4<=0;
//stage5
	zeroA5<=0;
	zeroB5<=0;
	zeroC5<=0;
	signres5<=0;
	expres5<=0;
	pushin5<=0;
//stage6
	zeroA6<=0;
	zeroB6<=0;
	zeroC6<=0;
	signres6<=0;
	expres6<=0;
	pushin6<=0;
//stage7
	zeroA7<=0;
	zeroB7<=0;
	zeroC7<=0;
	signres7<=0;
	expres7<=0;
	pushin7<=0;
//stage8
	zeroA8<=0;
	zeroB8<=0;
	zeroC8<=0;
	signres8<=0;
	expres8<=0;
	pushin8<=0;
//stage9
	zeroA9<=0;
	zeroB9<=0;
	zeroC9<=0;
	signres9<=0;
	expres9<=0;
	pushin9<=0;
	mres<=0;


  
    end else begin
 //stage1   
	fractC1<=fractC;
	zeroA1<=zeroA;
	zeroB1<=zeroB;
	zeroC1<=zeroC;
	signres1<=signres;
	expres1<=expres;
	pushin1<=pushin;
//stage2
	fractC2<=fractC1t;
	zeroA2<=zeroA1t;
	zeroB2<=zeroB1t;
	zeroC2<=zeroC1t;
	signres2<=signres1t;
	expres2<=expres1t;
	pushin2<=pushin1;
//stage3
	fractC3<=fractC2t;
	zeroA3<=zeroA2t;
	zeroB3<=zeroB2t;
	zeroC3<=zeroC2t;
	signres3<=signres2t;
	expres3<=expres2t;
	pushin3<=pushin2;
//stage4
	fractC4<=fractC3t;
	zeroA4<=zeroA3t;
	zeroB4<=zeroB3t;
	zeroC4<=zeroC3t;
	signres4<=signres3t;
	expres4<=expres3t;
	pushin4<=pushin3;
//stage5
	zeroA5<=zeroA4t;
	zeroB5<=zeroB4t;
	zeroC5<=zeroC4t;
	signres5<=signres4t;
	expres5<=expres4t;
	pushin5<=pushin4;
//stage6
	zeroA6<=zeroA5t;
	zeroB6<=zeroB5t;
	zeroC6<=zeroC5t;
	signres6<=signres5t;
	expres6<=expres5t;
	pushin6<=pushin5;
//stage7
	zeroA7<=zeroA6t;
	zeroB7<=zeroB6t;
	zeroC7<=zeroC6t;
	signres7<=signres6t;
	expres7<=expres6t;
	pushin7<=pushin6;
//stage8
	zeroA8<=zeroA7t;
	zeroB8<=zeroB7t;
	zeroC8<=zeroC7t;
	signres8<=signres7t;
	expres8<=expres7t;
	pushin8<= pushin7;
//stage9
	zeroA9<=zeroA8t;
	zeroB9<=zeroB8t;
	zeroC9<=zeroC8t;
	signres9<=signres8t;
	expres9<=expres8t;
	pushin9<= pushin8;
	mres<=y1;
    
    end
end


always @(*) begin

fractC1t=fractC1;
zeroA1t=zeroA1;
zeroB1t=zeroB1;
zeroC1t=zeroC1;
signres1t=signres1;
expres1t=expres1;

fractC2t=fractC2;
zeroA2t=zeroA2;
zeroB2t=zeroB2;
zeroC2t=zeroC2;
signres2t=signres2;
expres2t=expres2;

fractC3t=fractC3;
zeroA3t=zeroA3;
zeroB3t=zeroB3;
zeroC3t=zeroC3;
signres3t=signres3;
expres3t=expres3;

fractC4t=fractC4;
zeroA4t=zeroA4;
zeroB4t=zeroB4;
zeroC4t=zeroC4;
signres4t=signres4;
expres4t=expres4;

zeroA5t=zeroA5;
zeroB5t=zeroB5;
zeroC5t=zeroC5;
signres5t=signres5;
expres5t=expres5;

zeroA6t=zeroA6;
zeroB6t=zeroB6;
zeroC6t=zeroC6;
signres6t=signres6;
expres6t=expres6;

zeroA7t=zeroA7;
zeroB7t=zeroB7;
zeroC7t=zeroC7;
signres7t=signres7;
expres7t=expres7;

zeroA8t=zeroA8;
zeroB8t=zeroB8;
zeroC8t=zeroC8;
signres8t=signres8;
expres8t=expres8;

end



always @(*) begin
  sA = a[63];
  sB = b[63];
  sC = c[63];
  expA = a[62:52];
  expB = b[62:52];
  expC = c[62:52];
  fractA = { 1'b1, a[51:0]};
  fractB = { 1'b1, b[51:0]};
  fractC = { 1'b1, c[51:0]};
  zeroA = (a[62:0]==0)?1:0;
  zeroB = (b[62:0]==0)?1:0;
  zeroC = (c[62:0]==0)?1:0;
  //mres= fractA*fractB;
  expres = expA+expB+expC-11'd2045;
  signres=sA^sB^sC;
end 


DW02_mult_5_stage #(53,53) d1(fractA,fractB,1'b0,clk,x1);

DW02_mult_5_stage #(106,53) d2(x1,fractC4t,1'b0,clk,y1);


always @ (*) begin
zeroA9t=zeroA9;
zeroB9t=zeroB9;
zeroC9t=zeroC9;
signres9t=signres9;
expres9t=expres9;
mres9t=mres;
  
  rconstant=0;
  if (mres9t[158]==1) rconstant[105]=1; else if(mres9t[157]==1'b1) rconstant[104]=1; else rconstant[103]=1;
  rres=mres9t+rconstant;
  if((zeroA9t==1) || (zeroB9t==1) || (zeroC9t == 1)) begin // sets a zero result to a true 0
    rres = 0;
    expres9t = 0;
    signres9t=0;
    resout=64'b0;
  end else begin
    if(rres[158]==1'b1) begin
      expres9t=expres9t+1;
      resout={signres9t,expres9t,rres[157:106]};
    end else if(rres[157]==1'b0) begin // less than 1/2
      expres9t=expres9t-1;
      resout={signres9t,expres9t,rres[155:104]};
    end else begin 
      resout={signres9t,expres9t,rres[156:105]};
    end
  end
end

endmodule




