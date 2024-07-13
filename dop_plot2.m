clear
close all

GDOP = zeros(41,41);
HDOP = zeros(41,41);
VDOP = zeros(41,41);
PDOP = zeros(41,41);

x = [19,18,-19,-21];
y = [21,-19,20,-18];
z = [10,10,10,10];

ia = 1;
for a = -20:20
    ib = 1;
    for b = -20:20
        Ru = [a;b;0];
        
        A = [];
        for i = 1:4
            Ri = [x(i);y(i);z(i)];
            Ru = [a;b;0];

            Ui = (Ru - Ri)/norm(Ru - Ri);

            A = [A;Ui' 1];
        end
        D = inv(A'*A);
        VDOP(ia,ib) = sqrt(D(3,3));
        HDOP(ia,ib) = sqrt(D(1,1)+D(2,2));
        PDOP(ia,ib) = sqrt(D(1,1)+D(2,2)+D(3,3));
        GDOP(ia,ib) = sqrt(D(1,1)+D(2,2)+D(3,3)+D(4,4));
        ib = ib + 1;
    end
    ia = ia + 1;
end
PDOP(PDOP>20)=20;
figure(1)
surf(-20:20,-20:20,PDOP)
hold on;
scatter(x,y,20,'r*')