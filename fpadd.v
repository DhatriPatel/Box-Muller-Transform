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

module fpadd(clk, rst, pushin, a, b, pushout, r);
input pushin;
input clk,rst;
input [63:0] a,b;	// the a and b inputs
output [63:0] r;	// the results from this multiply
output pushout;		// indicates we have an answer this cycle

parameter fbw=104;

reg sA,sB;		// the signs of the a and b inputs
reg [10:0] expA, expB,expR;		// the exponents of each
reg [fbw:0] fractA, fractB,fractR,fractAdd,fractPreRound,denormB,
	f2,d2;	
	// the fraction of A and B  present
reg zeroA,zeroB;	// a zero operand (special case for later)
	

reg signres;		// sign of the result
reg [10:0] expres;	// the exponent result
reg [63:0] resout;	// the output value from the always block
integer iea,ieb,ied;	// exponent stuff for difference...
integer renorm;		// How much to renormalize...
parameter [fbw:0] zero=0;
reg stopinside;


//stage-1 variables
integer renorm1,renorm1l;
reg [10:0] expA1,expA1l;
reg sA1,sB1,sA1l,sB1l;
reg [fbw:0] fractA1, fractB1,fractA1l, fractB1l;
reg signres1,signres1l;
integer ied1,ied1l;
reg pushin1;


//stage-2 variables
integer renorm2,renorm2l;
reg sA2,sB2,sA2l,sB2l;
reg [fbw:0] fractA2, fractB2,fractR2,fractA2l, fractB2l,fractR2l;
reg signres2,signres2l;
integer ied2,ied2l;
reg pushin2;
reg [10:0] expR2,expR2l;

// stage-3
integer renorm3,renorm3l;
reg signres3,signres3l;
integer ied3,ied3l;
reg [10:0] expR3,expR3l;
reg pushin3;
reg [fbw:0] fractR3,fractR3l;

//stage-4 variables
integer renorm4,renorm4l;
reg signres4,signres4l;
integer ied4,ied4l;
reg [10:0] expR4,expR4l;
reg pushin4;
reg [fbw:0] fractR4,fractR4l;


assign r=resout;
assign pushout=pushin4;


always@(posedge clk or posedge rst)
  begin
    if(rst) 
      begin

//stage-1
        renorm1<=0;
        expA1<=0;
        sA1<=0;
        sB1<=0;
        fractA1<=0;
        fractB1<=0;
        signres1<=0;
        ied1<=0;
        pushin1<=0; 
//stage-2
        renorm2<=0;
        sA2<=0;
        sB2<=0;
        fractA2<=0;
        fractB2<=0;
        signres2<=0;
        ied2<=0;
        expR2<=0;
        fractR2<=0;
        pushin2<=0;
//stage-3
        renorm3<=0;
        signres3<=0;
        ied3<=0;
        expR3<=0;
        fractR3<=0;
        pushin3<=0;
//stage-4
        renorm4<=0;
        signres4<=0;
        ied4<=0;
        fractR4<=0;
        expR4<=0;
        pushin4<=0;
      end
    else
      begin
//stage-1
        renorm1<=renorm;
        expA1<=expA;
        sA1<=sA;
        sB1<=sB;
        fractA1<=fractA;
        fractB1<=fractB;
        signres1<=signres;
        ied1<=ied;
        pushin1<=pushin; 
//stage-2
        renorm2<=renorm1l;
        sA2<=sA1l;
        sB2<=sB1l;
        fractA2<=fractA1l;
        fractB2<=fractB1l;
        signres2<=signres1l;
        ied2<=ied1l;
        expR2<=expR;
        fractR2<=fractR;
        pushin2<=pushin1;
//stage-3
        renorm3<=renorm2l;
        signres3<=signres2l;
        ied3<=ied2l;
        expR3<=expR2l;
        fractR3<=fractR2l;
        pushin3<=pushin2;
//stage-4
        renorm4<=renorm3l;
        signres4<=signres3l;
        ied4<=ied3l;
        fractR4<=fractR3l;
        expR4<=expR3l;
        pushin4<=pushin3;
      end
  end


always @(*) begin
  zeroA = (a[62:0]==0)?1:0;
  zeroB = (b[62:0]==0)?1:0;
  renorm=0;
  if( b[62:0] > a[62:0] ) begin
    expA = b[62:52];
    expB = a[62:52];
    sA = b[63];
    sB = a[63];
    fractA = (zeroB)?0:{ 2'b1, b[51:0],zero[fbw:54]};
    fractB = (zeroA)?0:{ 2'b1, a[51:0],zero[fbw:54]};
    signres=sA;
  end else begin
    sA = a[63];
    sB = b[63];
    expA = a[62:52];
    expB = b[62:52];
    fractA = (zeroA)?0:{ 2'b1, a[51:0],zero[fbw:54]};
    fractB = (zeroB)?0:{ 2'b1, b[51:0],zero[fbw:54]};
    signres=sA;
  end
  iea=expA;
  ieb=expB;
  ied=expA-expB;
end

//--------------------------------------------------------------------------

always @(*) begin
  renorm1l=renorm1;
  expA1l=expA1;
  sA1l=sA1;
  sB1l=sB1;
  fractA1l=fractA1;
  fractB1l=fractB1;
  //fractR_22=fractR_1;
  signres1l=signres1;
  ied1l=ied1;
 // expR_22=expR_2;

  if(ied1l > 60) begin
    expR=expA1l;
    fractR=fractA1l;
  end else begin
    fractR=0;
    expR=expA1l;
    denormB=0;
    fractB1l=(ied1l[5])?{32'b0,fractB1l[fbw:32]}: {fractB1l};
    fractB1l=(ied1l[4])?{16'b0,fractB1l[fbw:16]}: {fractB1l};
    fractB1l=(ied1l[3])?{ 8'b0,fractB1l[fbw:8 ]}: {fractB1l};
    fractB1l=(ied1l[2])?{ 4'b0,fractB1l[fbw:4 ]}: {fractB1l};
    fractB1l=(ied1l[1])?{ 2'b0,fractB1l[fbw:2 ]}: {fractB1l};
    fractB1l=(ied1l[0])?{ 1'b0,fractB1l[fbw:1 ]}: {fractB1l};
end
end
//--------------------------------------------------------------------------

always @(*) begin
  renorm2l=renorm2;
  sA2l=sA2;
  sB2l=sB2;
  fractA2l=fractA2;
  fractB2l=fractB2;
  fractR2l=fractR2;
  signres2l=signres2;
  ied2l=ied2;
  expR2l=expR2;


 if(ied2l<61) begin
    if(sA2l == sB2l) fractR2l=fractA2l+fractB2l; else fractR2l=fractA2l-fractB2l;
    fractAdd=fractR2l;
    renorm2l=0;
    if(fractR2l[fbw]) begin
      fractR2l={1'b0,fractR2l[fbw:1]};
      expR2l=expR2l+1;
    end
end
end

//---------------------------------------------------------------------------

always @(*) begin
  renorm3l=renorm3;
  signres3l=signres3;
  ied3l=ied3;
  fractR3l=fractR3;
  expR3l=expR3;

 if(ied3l<61) begin
    if(fractR3l[fbw-1:fbw-32]==0) begin 
	renorm3l[5]=1; fractR3l={ 1'b0,fractR3l[fbw-33:0],32'b0 }; 
    end
    if(fractR3l[fbw-1:fbw-16]==0) begin 
	renorm3l[4]=1; fractR3l={ 1'b0,fractR3l[fbw-17:0],16'b0 }; 
    end
    if(fractR3l[fbw-1:fbw-8]==0) begin 
	renorm3l[3]=1; fractR3l={ 1'b0,fractR3l[fbw-9:0], 8'b0 }; 
    end
    if(fractR3l[fbw-1:fbw-4]==0) begin 
	renorm3l[2]=1; fractR3l={ 1'b0,fractR3l[fbw-5:0], 4'b0 }; 
    end
    if(fractR3l[fbw-1:fbw-2]==0) begin 
	renorm3l[1]=1; fractR3l={ 1'b0,fractR3l[fbw-3:0], 2'b0 }; 
    end
    if(fractR3l[fbw-1   ]==0) begin 
	renorm3l[0]=1; fractR3l={ 1'b0,fractR3l[fbw-2:0], 1'b0 }; 
    end
end
end

//-----------------------------------------------------------------------

always @(*) begin
  renorm4l=renorm4;
  signres4l=signres4;
  ied4l=ied4;
  fractR4l=fractR4;
  expR4l=expR4;

  if(ied4l<61) begin
   // fractPreRound=fractR;
    if(fractR4l != 0) begin
      if(fractR4l[fbw-55:0]==0 && fractR4l[fbw-54]==1) begin
	if(fractR4l[fbw-53]==1) fractR4l=fractR4l+{1'b1,zero[fbw-54:0]};
      end else begin
        if(fractR4l[fbw-54]==1) fractR4l=fractR4l+{1'b1,zero[fbw-54:0]};
      end
      expR4l=expR4l-renorm4l;
      if(fractR4l[fbw-1]==0) begin
       expR4l=expR4l+1;
       fractR4l={1'b0,fractR4l[fbw-1:1]};
      end
    end else begin
      expR4l=0;
      signres4l=0;
    end
  end
 //end

  resout={signres4l,expR4l,fractR4l[fbw-2:fbw-53]};

end


endmodule
