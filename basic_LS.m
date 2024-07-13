syms x1 x2

f1 = 2*x1 - 2*x2 - 2;
f2 = x1 - 2*x2 - 1;
f3 = x1 + x2 - 4;

R = [f1;f2;f3];
J = [diff(f1,x1) diff(f1,x2);diff(f2,x1) diff(f2,x2);diff(f3,x1) diff(f3,x2)];

x = [3;1];

for i = 1:10
    Js = subs(J,[x1,x2],x');
    Rs = subs(R,[x1,x2],x');
    dx = (Js'*Js)\Js'*Rs;
    x = x - double(dx);
    disp(double(dx))
    disp(x)
end