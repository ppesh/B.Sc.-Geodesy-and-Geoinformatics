function [I,H,S] = rgb2hsi(R,G,B)                                          % Transformation von RGB in IHS

I = (R + G + B)./3;
theta = acos(0.5*((R-G)+(R-B)) ./ sqrt((R-G).^2+(R-B).*(G-B)));
C1 = find((abs(R-B)<eps)&(abs(R-G)<eps)&(abs(G-B)<eps));
H = (B<=G).*theta + (B>G).*(2*pi - theta);
H(C1) = 0;                                                                 % case 1: R=G=B => 0°
H = H./(2*pi);
S = 1 - 3.*min(min(R,G),B)./(R+G+B);
end