close all
clear all
clc

% Bildverarbeitung - Übung 1: Kontrastverbesserung und Histogrammvererbung
% Name: Preslava Peshkova
% Matr.-Nr.: 3115785

%% Histogrammanpassung

I_left = imread('8873_g.jpg');
I_right = imread('8874_g.jpg');

figure, imshow(I_left), title('linkes Bild');
figure, imshow(I_right), title('rechtes Bild');

figure, imhist(I_left), title('linkes Bild Histogramm');
figure, imhist(I_right), title('rechtes Bild Histogramm');

h_left = imhist(I_left);
h_right = imhist(I_right);

h_l_norm = imhist(I_left)/numel(I_left); 
h_r_norm = imhist(I_right)/numel(I_right);

f = cumsum(h_left/numel(I_left));                   % f Grauwerttransferfunktion des linken Bildes
g = cumsum(h_right/numel(I_right));                 % g Grauwerttransferfunktion des rechten Bildes

x = 1:1:256;
figure, plot(x,f,'r'); title('Grauwerttransferfunktion linkes Bild');
xlim([0 255])
ylim([0 1])
figure, plot(x,g,'g'); title('Grauwerttransferfunktion rechtes Bild');
xlim([0 255])
ylim([0 1])

F = floor(256*cumsum(h_l_norm));
G = floor(256*cumsum(h_r_norm));

for i = 1:256
    j = G(i);
    k = min(find(F >= j));
    H(i) = k;
end

I_new = uint8(H(imadd(I_right,1)));
h_n_norm = imhist(I_new)/numel(I_new);

figure,imshow(I_new),title('Bild des angepassten Histogramms');
figure,plot(x,h_l_norm,'r', x,h_r_norm,'g', x,h_n_norm,'b'),title('angepasstes Histogramm'),legend('linkes Bild','rechtes Bild','angepasstes Bild');
figure,plot(x,F,'r', x,G,'g', x,H,'b'),title('Grauwerttransferfunktionen'),legend('linkes Bild','rechtes Bild','angepasstes Bild');
xlim([0 256])
ylim([0 256])


