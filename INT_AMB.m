ioff = 20;

q = [-0.4 0.7 0.5 0];
q(4) = sqrt(1-norm(q)^2);

cnt = 0;
idx = 0;
wl1 = 299792458/1575.42e6;
thres = 0.25*wl1;

buf = q;
[a,aa] = max(abs(buf));
buf(aa) = 0;
[b,bb] = max(abs(buf));
buf(bb) = 0;
[c,cc] = max(abs(buf));
buf(cc) = 0;
[d,dd] = max(abs(buf));
buf(dd) = 0;

qp(1) = q(aa);
qp(2) = q(bb);
qp(3) = q(cc);
qp(4) = q(dd);

amb = zeros(1,4);

for ia = -ioff:ioff
    amb(aa) = ia;
    
    chkb1a = (qp(1)*amb(aa) + abs(qp(2))*(-ioff) + abs(qp(3))*(-ioff) + abs(qp(4))*(-ioff))*wl1;
    chkb2a = (qp(1)*amb(aa) + abs(qp(2))*(+ioff) + abs(qp(3))*(-ioff) + abs(qp(4))*(-ioff))*wl1;
    chkb1b = (qp(1)*amb(aa) + abs(qp(2))*(-ioff) + abs(qp(3))*(+ioff) + abs(qp(4))*(+ioff))*wl1;
    chkb2b = (qp(1)*amb(aa) + abs(qp(2))*(+ioff) + abs(qp(3))*(+ioff) + abs(qp(4))*(+ioff))*wl1;
    
    jumpb1 = (chkb1a > thres & chkb2a > thres);
    jumpb2 = (chkb1b < -thres & chkb2b < -thres);
    
    if jumpb1 == 0 && jumpb2 == 0
        for ib = -ioff:ioff
            amb(bb) = ib;

            chkc1a = (qp(1)*amb(aa) + qp(2)*amb(bb) + abs(qp(3))*(-ioff) + abs(qp(4))*(-ioff))*wl1;
            chkc2a = (qp(1)*amb(aa) + qp(2)*amb(bb) + abs(qp(3))*(+ioff) + abs(qp(4))*(-ioff))*wl1;
            chkc1b = (qp(1)*amb(aa) + qp(2)*amb(bb) + abs(qp(3))*(-ioff) + abs(qp(4))*(+ioff))*wl1;
            chkc2b = (qp(1)*amb(aa) + qp(2)*amb(bb) + abs(qp(3))*(+ioff) + abs(qp(4))*(+ioff))*wl1;

            jumpc1 = (chkc1a > thres & chkc2a > thres);
            jumpc2 = (chkc1b < -thres & chkc2b < -thres);
            
            if jumpc1 == 0 && jumpc2 == 0
                for ic = -ioff:ioff
                    amb(cc) = ic;

                    chkd1 = (qp(1)*amb(aa) + qp(2)*amb(bb) + qp(2)*amb(bb) + abs(qp(4))*(-ioff))*wl1;
                    chkd2 = (qp(1)*amb(aa) + qp(2)*amb(bb) + qp(2)*amb(bb) + abs(qp(4))*(+ioff))*wl1;

                    jumpd1 = (chkd1 > thres);
                    jumpd2 = (chkd2 < -thres);

                    if jumpd1 == 0 && jumpd2 == 0
                        ref = (qp(1)*amb(aa) + qp(2)*amb(bb) + qp(2)*amb(bb) + qp(4)*amb(dd))*wl1;

                        if qp(4) <= 0
                            intup = ceil((-thres-ref)/(qp(4)*wl1));
                            intdn = floor((thres-ref)/(qp(4)*wl1));
                        else
                            intup = ceil((thres-ref)/(qp(4)*wl1));
                            intdn = floor((-thres-ref)/(qp(4)*wl1));
                        end

                        if intup > ioff
                            intup = ioff;
                        end

                        if intdn < -ioff
                            intdn = -ioff;
                        end

                        for id = intdn:intup
                            amb(dd) = id;

                            cnt = cnt + 1;
                            iset = amb';

                            res(cnt) = q*iset*wl1;

                            if abs(res(cnt)) <= thres
                                idx = idx + 1;
                                int(idx,:) = amb;
                            end
                        end

                    end

                end

            end

        end
    end
end

plot(res,"*");
pause;
resin = res;

p = find(abs(resin) > thres);
resin(p) = zeros(size(resin(p)));
resout = res - resin;

plot(resout,"*");
hold on;
plot(resin,"*g");
hold off;
                                