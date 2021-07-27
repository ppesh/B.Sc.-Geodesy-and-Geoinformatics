function RGB = hsi2rgb(HSI)                             % Transformation der Bilder von IHS in RGB

rho = 180/pi;
I = HSI(:,:,1); H = HSI(:,:,2)*2*pi; S = HSI(:,:,3); 

R_new = zeros(size(I));
G_new = zeros(size(I));
B_new = zeros(size(S));

% Farbton zwischen 0° und 120°
C2 = find((H>=0)&(H<120/rho));
B_new(C2) = I(C2).*(1-S(C2));
R_new(C2) = I(C2).*(1+S(C2).*cos(H(C2))./cos(60/rho-H(C2)));
G_new(C2) = 3*I(C2)-(R_new(C2)+B_new(C2));

% Farbton zwischen 120° und 240°
C3 = find((H>=120/rho)&(H<240/rho));
R_new(C3) = I(C3).*(1-S(C3));
G_new(C3) = I(C3).*(1+S(C3).*cos(H(C3)-120/rho)./cos(180/rho-H(C3)));
B_new(C3) = 3*I(C3) - (R_new(C3) + G_new(C3));

% Farbton zwischen 240° und 360°
C4 = find((H>=240/rho)&(H<360/rho));
G_new(C4) = I(C4).*(1-S(C4));
B_new(C4) = I(C4).*(1+S(C4).*cos(H(C4)-240/rho)./cos(300/rho-H(C4)));
R_new(C4) = 3*I(C4) - (G_new(C4)+B_new(C4));

RGB = cat(3,R_new,G_new,B_new);
end