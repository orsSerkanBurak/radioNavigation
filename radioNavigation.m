clc;clear;close all;
syms yyy
%% Initial Values
n = 15; % student sequence number
% position of ground stations
O1 = [100.8;1.1;30.3]; % ground station 1
O2 = [-20.2;0.5;19.8]; % ground station 2
O3 = [40.4;0.86;-38.5]; % ground station 3
% distances of A/C between ground stations
D1 = 63.4 + n*0.1;
D2 = 69.2 + n*0.1;
D3 = 44.8 + n*0.1;
% position elements of ground stations
x1 = O1(1);y1 = O1(2);z1 = O1(3);
x2 = O2(1);y2 = O2(2);z2 = O2(3);
x3 = O3(1);y3 = O3(2);z3 = O3(3);
%% Theoretical Equations
% distances of ground stations from the origin
L1 = sqrt(x1^2+y1^2+z1^2);
L2 = sqrt(x2^2+y2^2+z2^2);
L3 = sqrt(x3^2+y3^2+z3^2);
% assistant variables
c1 = 0.5*(D2^2 - D1^2 + L1^2 - L2^2);
c2 = 0.5*(D3^2 - D1^2 + L1^2 - L3^2);
c3 = 0.5*(D3^2 - D2^2 + L2^2 - L3^2);
e1 = ((c1*(z2-z3))-(c3*(z1-z2))) / (((x1-x2)*(z2-z3))-((x2-x3)*(z1-z2)));
e2 = ((c1*(x1-x3))-(c2*(x1-x2))) / (((x1-x3)*(z1-z2))-((x1-x2)*(z1-z3)));
a = (((y1-y2)*(z2-z3))-((y2-y3)*(z1-z2))) / (((x1-x2)*(z2-z3))-((x2-x3)*(z1-z2)));
b = (((y1-y2)*(x1-x3))-((y1-y3)*(x1-x2))) / (((x1-x3)*(z1-z2))-((x1-x2)*(z1-z3)));
%% Position Elements of A/C
eqn = (a^2 + b^2 + 1)*yyy*yyy + 2*(x1*a - y1 + z1*b - a*e1 - b*e2)*yyy - (D1^2 - L1^2 - e1^2 + (2*x1*e1) - e2^2 + (2*z1*e2)) == 0; 
yy = vpa(solve(eqn,yyy));
% y coordinate must be positive since aircraft has positive altitude (over the ground)
for i = 1:length(yy)
    if yy(i) > 0
        y = yy(i);
    end
end
x = e1 - a*y;
z = e2 - b*y;
M = [x;y;z];
% Distance of A/C with Range Measurement Method
D = sqrt(x^2+y^2+z^2);
%% Range Differences
deltaD1R = D - D1;
deltaD2R = D - D2;
deltaD3R = D - D3;
% assistant variables
f1 = 0.5*(L1^2-deltaD1R^2);
f2 = 0.5*(L2^2-deltaD2R^2);
f3 = 0.5*(L3^2-deltaD3R^2);
A = x1*(z3*deltaD2R-z2*deltaD3R) - z1*(x3*deltaD2R-x2*deltaD3R) - deltaD1R*(x2*z3-x3*z2);
% Position of A/C with Range Difference Method
x = (1/A)*(f1*(z3*deltaD2R-z2*deltaD3R)-z1*(f3*deltaD2R-f2*deltaD3R)-deltaD1R*(f2*z3-f3*z2));
z = (1/A)*(x1*(f3*deltaD2R-f2*deltaD3R)-f1*(x3*deltaD2R-x2*deltaD3R)-deltaD1R*(x2*f3-x3*f2));
y = sqrt(D^2-x^2-z^2);
MR = [x;y;z];
DR = (1/A)*(x1*(z2*f3-z3*f2) - z1*(x2*f3-x3*f2) + f1*(x2*z3 - x3*z2));
syms xxxx yyyy zzzz
eqn1 = x1*xxxx + y1*yyyy + z1*zzzz - D*deltaD1R == f1;
eqn2 = x2*xxxx + y2*yyyy + z2*zzzz - D*deltaD2R == f2;
eqn3 = x3*xxxx + y3*yyyy + z3*zzzz - D*deltaD3R == f3;
[x,y,z] = solve(eqn1,eqn2,eqn3,xxxx,yyyy,zzzz);
DR = sqrt(x^2+y^2+z^2);
MR = [x,y,z];
%% Sum of Range Differences
deltaD1 = D + D1;
deltaD2 = D + D2;
deltaD3 = D + D3;
% assistant variables
f1 = 0.5*(L1^2-deltaD1^2);
f2 = 0.5*(L2^2-deltaD2^2);
f3 = 0.5*(L3^2-deltaD3^2);
A = x1*(z3*deltaD2-z2*deltaD3) - z1*(x3*deltaD2-x2*deltaD3) - deltaD1*(x2*z3-x3*z2);
% Position of A/C with Sum of Range Difference Method
x = (1/A)*(f1*(z3*deltaD2-z2*deltaD3)-z1*(f3*deltaD2-f2*deltaD3)-deltaD1*(f2*z3-f3*z2));
z = (1/A)*(x1*(f3*deltaD2-f2*deltaD3)-f1*(x3*deltaD2-x2*deltaD3)-deltaD1*(x2*f3-x3*f2));
y = sqrt(D^2-x^2-z^2);
MSR = [x;y;z];
DSR = (1/A)*(x1*(z2*f3-z3*f2) - z1*(x2*f3-x3*f2) + f1*(x2*z3 - x3*z2));
syms xxxx yyyy zzzz
eqn1 = x1*xxxx + y1*yyyy + z1*zzzz - D*deltaD1 == f1;
eqn2 = x2*xxxx + y2*yyyy + z2*zzzz - D*deltaD2 == f2;
eqn3 = x3*xxxx + y3*yyyy + z3*zzzz - D*deltaD3 == f3;
[x,y,z] = solve(eqn1,eqn2,eqn3,xxxx,yyyy,zzzz);
DSR = sqrt(x^2+y^2+z^2);
MSR = [x,y,z];
%% Printing Results
fprintf("Range Measurement Method:\n")
fprintf("Position of aircraft: \nM(%.8f,%.8f,%.8f) km\n",M(1),M(2),M(3));
fprintf("Distance of aircraft to origin:\nD = %.8f km\n\n", D);
fprintf("Range Difference Method:\n")
fprintf("Position of aircraft: \nM(%.8f,%.8f,%.8f) km\n",MR(1),MR(2),MR(3));
fprintf("Distance of aircraft to origin:\nD = %.8f km\n\n", DR);
fprintf("Sum of Range Differences Method:\n")
fprintf("Position of aircraft: \nM(%.8f,%.8f,%.8f) km\n",MSR(1),MSR(2),MSR(3));
fprintf("Distance of aircraft to origin:\nD = %.8f km\n", DSR);