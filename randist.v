module randist(clk, rst, pushin, U1, U2, pushout, Z);
input clk, rst, pushin;
input [63:0] U1, U2;
output [63:0] Z;
output pushout;

reg sign1, sign2;
reg [10:0] exp1, exp2, expR1, expR2;

parameter fbw = 63;
parameter fbw1 = 63;
reg [fbw:0] fract1, fract2;
reg [fbw:0] fractR1, fractR2, fractR1_temp, fractR2_temp, fractR1_temp1, fractR2_temp1;

parameter [fbw:0] zero=0;

integer ied1, ied2;
integer renorm, renorm1;

//parameter [63:0] G1 = 64'h3ff0000000000000;

reg [8:0] vin;
reg [9:0] vin2;
reg [63:0] delta1, delta2;
wire [63:0] A, B, C, D, P, Q, R, z1, z2, z3, z4, k1, k2, p1, p2, k3, Zm;
wire [63:0] a_f, sinb;
wire pushout1, pushout2, pushout3, pushout4, pout0, pout1, pouta, pushout_1, pushout_2, pout2, poutb, pushoutm;

reg [63:0] A_1l, A_2l, A_3l, A_4l, A_5l, A_6l, A_7l, A_8l, A_9l, z3_1l, z3_2l, z3_3l, z3_4l, z3_5l, z3_6l, z3_7l, z3_8l, z3_9l, D_1l, D_2l, D_3l, D_4l, D_5l, D_6l, D_7l, D_8l, D_9l, k2_1l, k2_2l, k2_3l, k2_4l, k2_5l, k2_6l, k2_7l, k2_8l, k2_9l, R_1l, R_2l, R_3l, R_4l, R_5l, R_6l, R_7l, R_8l, R_9l, R_10l, R_11l, R_12l, R_13l, sinb_1l, sinb_2l, sinb_3l, sinb_4l, sinb_5l, sinb_6l, sinb_7l, sinb_8l, sinb_9l, Zl;  

reg pushout3_1l, pushout3_2l, pushout3_3l, pushout3_4l, pushout3_5l, pushout3_6l, pushout3_7l, pushout3_8l, pushout3_9l, pout1_1l, pout1_2l, pout1_3l,pout1_4l, pout1_5l, pout1_6l, pout1_7l, pout1_8l, pout1_9l, poutb_1l, poutb_2l, poutb_3l, poutb_4l, poutb_5l, poutb_6l, poutb_7l, poutb_8l, poutb_9l, pushoutl, pushin_1l, pushin_2l, pushin_3l, pushin_4l, pushin_5l, pushin_6l, pushin_7l, pushin_8l, pushin_9l, pushin_1ll, pushin_2ll, pushin_3ll, pushin_4ll, pushin_5ll, pushin_6ll, pushin_7ll, pushin_8ll, pushin_9ll, pushin_10ll, pushin_11ll, pushin_12ll, pushin_13ll;

assign pushout = pushoutl;
assign Z = Zl;

//.... denorm of U1 ...
always @(*) 
begin 
	sign1 = U1[63];
	exp1 = U1[62:52];
	fract1 = {2'b1, U1[51:0], 10'b0}; //zero[fbw:fbw-53]};
	//fract1 = U1[51:0];
	ied1 = 1022 - exp1;
	
	/*if(ied1 > 60) begin
    expR1 = exp1;*/
    fractR1 = fract1;
//	
    fractR1 = (ied1[5])?{32'b0,fractR1[fbw:32]}: {fractR1};
    fractR1 = (ied1[4])?{16'b0,fractR1[fbw:16]}: {fractR1};
    fractR1 = (ied1[3])?{ 8'b0,fractR1[fbw:8 ]}: {fractR1};
    fractR1 = (ied1[2])?{ 4'b0,fractR1[fbw:4 ]}: {fractR1};
    fractR1 = (ied1[1])?{ 2'b0,fractR1[fbw:2 ]}: {fractR1};
    fractR1 = (ied1[0])?{ 1'b0,fractR1[fbw:1 ]}: {fractR1};
	

// .... new fract ......
	fractR1_temp = fractR1;

	vin = fractR1_temp[fbw-1:fbw-9];
	
	fractR1_temp1 = {10'b0, fractR1_temp[fbw-10:0]};	// .. delta... 

	//...renorm of delta...
	renorm=0;
   
    if(fractR1_temp1[fbw1-1:fbw1-32]==0) begin 
	renorm[5]=1; fractR1_temp1 = {fractR1_temp1[fbw1-33:0],32'b0 }; 
    end
    if(fractR1_temp1[fbw1-1:fbw1-16]==0) begin 
	renorm[4]=1; fractR1_temp1 = {fractR1_temp1[fbw1-17:0],16'b0 }; 
    end
    if(fractR1_temp1[fbw1-1:fbw1-8]==0) begin 
	renorm[3]=1; fractR1_temp1 = {fractR1_temp1[fbw1-9:0], 8'b0 }; 
    end
    if(fractR1_temp1[fbw1-1:fbw1-4]==0) begin 
	renorm[2]=1; fractR1_temp1 = {fractR1_temp1[fbw1-5:0], 4'b0 }; 
    end
    if(fractR1_temp1[fbw1-1:fbw1-2]==0) begin 
	renorm[1]=1; fractR1_temp1 = {fractR1_temp1[fbw1-3:0], 2'b0 }; 
    end
    if(fractR1_temp1[fbw1-1   ]==0) begin 
	renorm[0]=1; fractR1_temp1={fractR1_temp1[fbw1-2:0], 1'b0 }; 
    end
    
	expR1 = 1022 - renorm;

	
	delta1 = {sign1, expR1, fractR1_temp1[fbw1-2:fbw1-53]};
end 

always @(*) 
begin 
	sign2 = U2[63];
	exp2 = U2[62:52];
	fract2 = {2'b1, U2[51:0], 10'b0}; //zero[fbw:fbw-53]};
	//fract1 = U1[51:0];
	ied2 = 1022 - exp2;
	
	/*if(ied1 > 60) begin
    expR1 = exp1;*/
    fractR2 = fract2;
//	
    fractR2 = (ied2[5])?{32'b0,fractR2[fbw:32]}: {fractR2};
    fractR2 = (ied2[4])?{16'b0,fractR2[fbw:16]}: {fractR2};
    fractR2 = (ied2[3])?{ 8'b0,fractR2[fbw:8 ]}: {fractR2};
    fractR2 = (ied2[2])?{ 4'b0,fractR2[fbw:4 ]}: {fractR2};
    fractR2 = (ied2[1])?{ 2'b0,fractR2[fbw:2 ]}: {fractR2};
    fractR2 = (ied2[0])?{ 1'b0,fractR2[fbw:1 ]}: {fractR2};
	

// .... new fract ......
	fractR2_temp = fractR2;

	vin2 = fractR2_temp[fbw-1:fbw-10];
	//
	fractR2_temp1 = {11'b0, fractR2_temp[fbw-11:0]};	// .. delta... 

	//...renorm of delta...
	renorm1=0;
   
    if(fractR2_temp1[fbw1-1:fbw1-32]==0) begin 
	renorm1[5]=1; fractR2_temp1 = {fractR2_temp1[fbw1-33:0],32'b0 }; 
    end
    if(fractR2_temp1[fbw1-1:fbw1-16]==0) begin 
	renorm1[4]=1; fractR2_temp1 = {fractR2_temp1[fbw1-17:0],16'b0 }; 
    end
    if(fractR2_temp1[fbw1-1:fbw1-8]==0) begin 
	renorm1[3]=1; fractR2_temp1 = {fractR2_temp1[fbw1-9:0], 8'b0 }; 
    end
    if(fractR2_temp1[fbw1-1:fbw1-4]==0) begin 
	renorm1[2]=1; fractR2_temp1 = {fractR2_temp1[fbw1-5:0], 4'b0 }; 
    end
    if(fractR2_temp1[fbw1-1:fbw1-2]==0) begin 
	renorm1[1]=1; fractR2_temp1 = {fractR2_temp1[fbw1-3:0], 2'b0 }; 
    end
    if(fractR2_temp1[fbw1-1   ]==0) begin 
	renorm1[0]=1; fractR2_temp1={fractR2_temp1[fbw-2:0], 1'b0 }; 
    end
    
	expR2 = 1022 - renorm1;

	
	delta2 = {sign2, expR2, fractR2_temp1[fbw1-2:fbw1-53]};
end 

sqrtln s0(.vin(vin), .A(A), .B(B), .C(C), .D(D));
//... determination of "a" .... 
//......a*delta^3.....
fpmul m1(.clk(clk), .rst(rst), .pushin(pushin), .a(delta1), .b(delta1), .c(delta1), .pushout(pushout1), .r(z1));
fpmul m2(.clk(clk), .rst(rst), .pushin(pushout1), .a(A_9l), .b(z1), .c(64'h3ff0000000000000), .pushout(pushout2), .r(z2));
//..... b*delta^2 .... 
fpmul m3(.clk(clk), .rst(rst), .pushin(pushin), .a(delta1), .b(delta1), .c(B), .pushout(pushout3), .r(z3));

//....c*delta....
fpmul m4(.clk(clk), .rst(rst), .pushin(pushin), .a(delta1), .b(C), .c(64'h3ff0000000000000), .pushout(pushout4), .r(z4));
//.... addition ....
fpadd s2(.clk(clk), .rst(rst), .pushin(pushout2&pushout3_9l), .a(z2), .b(z3_9l), .pushout(pout0), .r(k1)); // 1st Adelta^3 + Bdelta^2

fpadd s3(.clk(clk), .rst(rst), .pushin(pushout4), .a(z4), .b(D_9l), .pushout(pout1), .r(k2)); // Cdelta + D 

fpadd s4(.clk(clk), .rst(rst), .pushin(pout0&pout1_9l), .a(k1), .b(k2_9l), .pushout(pouta), .r(a_f));

//..................................................................

sin_lookup s1(.vin(vin2), .A(P), .B(Q), .C(R));

//..... determination of sinb .....
//....p*delta^2...
fpmul m5(.clk(clk), .rst(rst), .pushin(pushin), .a(delta2), .b(delta2), .c(P), .pushout(pushout_1), .r(p1));
//....q*delta....
fpmul m6(.clk(clk), .rst(rst), .pushin(pushin), .a(delta2), .b(Q), .c(64'h3ff0000000000000), .pushout(pushout_2), .r(p2));

fpadd h4(.clk(clk), .rst(rst), .pushin(pushout_1&pushout_2), .a(p1), .b(p2), .pushout(pout2), .r(k3)); // 1st Pdelta^2 + QdeltA
fpadd h2(.clk(clk), .rst(rst), .pushin(pout2), .a(k3), .b(R_13l), .pushout(poutb), .r(sinb)); // 1ST + R    

fpmul f1(.clk(clk), .rst(rst), .pushin(pouta&poutb_9l), .a(a_f), .b(sinb_9l), .c(64'h3ff0000000000000), .pushout(pushoutm), .r(Zm));

always @(posedge clk or posedge rst)
begin 
    if(rst) begin
    
    A_1l <= 0;
    A_2l <= 0;
    A_3l <= 0;
    A_4l <= 0;
    A_5l <= 0;
    A_6l <= 0;
    A_7l <= 0;
    A_8l <= 0;
    A_9l <= 0;
    
    z3_1l <= 0;
    z3_2l <= 0;
    z3_3l <= 0;
    z3_4l <= 0;
    z3_5l <= 0;
    z3_6l <= 0;
    z3_7l <= 0;
    z3_8l <= 0;
    z3_9l <= 0;
    
    pushout3_1l <= 0;
    pushout3_2l <= 0;
    pushout3_3l <= 0;
    pushout3_4l <= 0;
    pushout3_5l <= 0;
    pushout3_6l <= 0;
    pushout3_7l <= 0;
    pushout3_8l <= 0;
    pushout3_9l <= 0;
    
    D_1l <= 0;
    D_2l <= 0;
    D_3l <= 0;
    D_4l <= 0;
    D_5l <= 0;
    D_6l <= 0;
    D_7l <= 0;
    D_8l <= 0;
    D_9l <= 0;
    
   /* pushin_1l <= 0;
    pushin_2l <= 0;
    pushin_3l <= 0;
    pushin_4l <= 0;
    pushin_5l <= 0;
    pushin_6l <= 0;
    pushin_7l <= 0;
    pushin_8l <= 0;
    pushin_9l <= 0;
    */
    k2_1l <= 0;
    k2_2l <= 0;
    k2_3l <= 0;
    k2_4l <= 0;
    k2_5l <= 0;
    k2_6l <= 0;
    k2_7l <= 0;
    k2_8l <= 0;
    k2_9l <= 0;
    
    pout1_1l <= 0;
    pout1_2l <= 0;
    pout1_3l <= 0;
    pout1_4l <= 0;
    pout1_5l <= 0;
    pout1_6l <= 0;
    pout1_7l <= 0;
    pout1_8l <= 0;
    pout1_9l <= 0;
    
    R_1l <= 0;
    R_2l <= 0;
    R_3l <= 0;
    R_4l <= 0;
    R_5l <= 0;
    R_6l <= 0;
    R_7l <= 0;
    R_8l <= 0;
    R_9l <= 0;
    R_10l <= 0;
    R_11l <= 0;
    R_12l <= 0;
    R_13l <= 0;
    
    /*pushin_1ll <= 0;
    pushin_2ll <= 0;
    pushin_3ll <= 0;
    pushin_4ll <= 0;
    pushin_5ll <= 0;
    pushin_6ll <= 0;
    pushin_7ll <= 0;
    pushin_8ll <= 0;
    pushin_9ll <= 0;
    pushin_10ll <= 0;
    pushin_11ll <= 0;
    pushin_12ll <= 0;
    pushin_13ll <= 0;
    */
    poutb_1l <= 0;
    poutb_2l <= 0;
    poutb_3l <= 0;
    poutb_4l <= 0;
    poutb_5l <= 0;
    poutb_6l <= 0;
    poutb_7l <= 0;
    poutb_8l <= 0;
    poutb_9l <= 0;
    
    sinb_1l <= 0;
    sinb_2l <= 0;
    sinb_3l <= 0;
    sinb_4l <= 0;
    sinb_5l <= 0;
    sinb_6l <= 0;
    sinb_7l <= 0;
    sinb_8l <= 0;
    sinb_9l <= 0;
    
    pushoutl <= 0;
    Zl <= 0; 
    end 
    
    else begin 
    
    A_1l <= #1 A;
    A_2l <= #1 A_1l;
    A_3l <= #1 A_2l;
    A_4l <= #1 A_3l;
    A_5l <= #1 A_4l;
    A_6l <= #1 A_5l;
    A_7l <= #1 A_6l;
    A_8l <= #1 A_7l;
    A_9l <= #1 A_8l;
    
    
    z3_1l <= #1 z3;
    z3_2l <= #1 z3_1l;
    z3_3l <= #1 z3_2l;
    z3_4l <= #1 z3_3l;
    z3_5l <= #1 z3_4l;
    z3_6l <= #1 z3_5l;
    z3_7l <= #1 z3_6l;
    z3_8l <= #1 z3_7l;
    z3_9l <= #1 z3_8l;
    
    pushout3_1l <= #1 pushout3;
    pushout3_2l <= #1 pushout3_1l;
    pushout3_3l <= #1 pushout3_2l;
    pushout3_4l <= #1 pushout3_3l;
    pushout3_5l <= #1 pushout3_4l;
    pushout3_6l <= #1 pushout3_5l;
    pushout3_7l <= #1 pushout3_6l;
    pushout3_8l <= #1 pushout3_7l;
    pushout3_9l <= #1 pushout3_8l;
    
    D_1l <= #1 D;
    D_2l <= #1 D_1l;
    D_3l <= #1 D_2l;
    D_4l <= #1 D_3l;
    D_5l <= #1 D_4l;
    D_6l <= #1 D_5l;
    D_7l <= #1 D_6l;
    D_8l <= #1 D_7l;
    D_9l <= #1 D_8l;
    
   /* pushin_1l <= #1 pushin;
    pushin_2l <= #1 pushin_1l;
    pushin_3l <= #1 pushin_2l;
    pushin_4l <= #1 pushin_3l;
    pushin_5l <= #1 pushin_4l;
    pushin_6l <= #1 pushin_5l;
    pushin_7l <= #1 pushin_6l;
    pushin_8l <= #1 pushin_7l;
    pushin_9l <= #1 pushin_8l;
    */
    k2_1l <= #1 k2;
    k2_2l <= #1 k2_1l;
    k2_3l <= #1 k2_2l;
    k2_4l <= #1 k2_3l;
    k2_5l <= #1 k2_4l;
    k2_6l <= #1 k2_5l;
    k2_7l <= #1 k2_6l;
    k2_8l <= #1 k2_7l;
    k2_9l <= #1 k2_8l;
    
    pout1_1l <= #1 pout1;
    pout1_2l <= #1 pout1_1l;
    pout1_3l <= #1 pout1_2l;
    pout1_4l <= #1 pout1_3l;
    pout1_5l <= #1 pout1_4l;
    pout1_6l <= #1 pout1_5l;
    pout1_7l <= #1 pout1_6l;
    pout1_8l <= #1 pout1_7l;
    pout1_9l <= #1 pout1_8l;
    
    R_1l <= #1 R;
    R_2l <= #1 R_1l;
    R_3l <= #1 R_2l;
    R_4l <= #1 R_3l;
    R_5l <= #1 R_4l;
    R_6l <= #1 R_5l;
    R_7l <= #1 R_6l;
    R_8l <= #1 R_7l;
    R_9l <= #1 R_8l;
    R_10l <= #1 R_9l;
    R_11l <= #1 R_10l;
    R_12l <= #1 R_11l;
    R_13l <= #1 R_12l;
    
   /* pushin_1ll <= #1 pushin;
    pushin_2ll <= #1 pushin_1ll;
    pushin_3ll <= #1 pushin_2ll;
    pushin_4ll <= #1 pushin_3ll;
    pushin_5ll <= #1 pushin_4ll;
    pushin_6ll <= #1 pushin_5ll;
    pushin_7ll <= #1 pushin_6ll;
    pushin_8ll <= #1 pushin_7ll;
    pushin_9ll <= #1 pushin_8ll;
    pushin_10ll <= #1 pushin_9ll;
    pushin_11ll <= #1 pushin_10ll;
    pushin_12ll <= #1 pushin_11ll;
    pushin_13ll <= #1 pushin_12ll;
    */
    poutb_1l <= #1 poutb;
    poutb_2l <= #1 poutb_1l;
    poutb_3l <= #1 poutb_2l;
    poutb_4l <= #1 poutb_3l;
    poutb_5l <= #1 poutb_4l;
    poutb_6l <= #1 poutb_5l;
    poutb_7l <= #1 poutb_6l;
    poutb_8l <= #1 poutb_7l;
    poutb_9l <= #1 poutb_8l;
    
    sinb_1l <= #1 sinb;
    sinb_2l <= #1 sinb_1l;
    sinb_3l <= #1 sinb_2l;
    sinb_4l <= #1 sinb_3l;
    sinb_5l <= #1 sinb_4l;
    sinb_6l <= #1 sinb_5l;
    sinb_7l <= #1 sinb_6l;
    sinb_8l <= #1 sinb_7l;
    sinb_9l <= #1 sinb_8l;
    
    pushoutl <= #1 pushoutm;
    Zl <= #1 Zm;

    end
end 
endmodule 
    
    
    
    
