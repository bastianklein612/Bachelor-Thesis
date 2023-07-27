


n=100;
a = 1;
b = 1;

x = zeros(100,1);
y = zeros(100,1);


for i = 1:n
    
    theta = pi * (i/n);

    x(i) = a * cos(theta);
    y(i) = b * sin(theta);

end
%figure(100);
plot(x,y,'*k');
