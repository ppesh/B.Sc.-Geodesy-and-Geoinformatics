close all
clear all
clc

% Bildverarbeitung - Übung 1: Kontrastverbesserung und Histogrammvererbung
% Name: Preslava Peshkova
% Matr.-Nr.: 3115785

%% Kontrastverbesserung - lineare Skallierung
% Bild einlesen
I = imread('pout.tif');
h1 = imshow(I);title('Originalbild');                      % Darstellung des Bildes 
figure, imhist(I), title('Histogramm des Originalbildes'); % Histogramm vor der Skallierung

I = double(I);
min_I = min(I(:));
max_I = max(I(:));
I = uint8(I);

% Strecken des Bildes
I_adj = imadjust(I,[(min_I/255);(max_I/255)],[0;1]);
figure,imshow(I_adj),title('gestrecktes Bild');
figure,imhist(I_adj),title('gestrecktes Histogramm');

q = cumsum(imhist(I)/numel(I));
figure, plot(q),title('Grauwerttransferfunktion');

% ohne 7% der dunkelsten bzw. hellsten Grauwerte
I = double(I);
min_Ineu = max(find(q <= 0.07))-1;
max_Ineu = min(find(q >= 0.93))-1;
bandwidth = max_Ineu - min_Ineu;
offset = -(min_Ineu*255)/(max_Ineu - min_Ineu);
scale = 255/bandwidth;
I_stretch = int16(I)*scale + offset;
I_stretch = uint8(I_stretch);
figure, imshow(I_stretch),title('Bild ohne 7%');
figure, imhist(I_stretch),title('Histogramm ohne 7%');




