close all 
clear all
clc

% Bildverarbeitung - Übung 1: Kontrastverbesserung und Histogrammvererbung
% Name: Preslava Peshkova
% Matr.-Nr.: 3115785

%% Histogramverebnung
% Bild einlesen
I = imread('pout.tif');
h1 = imshow(I);title('Originalbild');                      % Darstellung des Bildes 
figure, imhist(I), title('Histogramm des Originalbildes'); % Histogramm vor der Skallierung

S = reshape(I,[],1);                     % Matrix I in eine Spalte S umwandeln; Länge S = n(I)*m(I)
S = double(S);

%% Histogramm skallieren ohne histeq
% Histogramm des Bildes berechnen:

H = hist(S,0:255);                       % Bereich des Histogramms von 0 bis 255 festlegen

relh = H/numel(I);                       % relative Häufigkeit für das Auftreten der Grauwerte

% Grauwerttransferfunktion berechnen
for relh = 1:256
    k = find(I==relh);
    hist(relh) = numel(k);
end

normhist = hist./numel(I);

for relh = 1:256
    cum_hist(relh) = 0;
    for i_buff = 1:relh
        cum_hist(relh) = cum_hist(relh) + normhist(i_buff);
    end
end

figure, plot(cum_hist), title('Grauwerttransferfunktion');
cusum = cum_hist;

% Transformation
I2 = cusum(I+1);

% Bildkonvertierung
I2 = uint8(I2*255);

figure,imshow(I2), title('skalliertes Bild');


[M,N] = size(I2);

t = 1:256;
n = 0:255;
count = 0;

for z = 1:256
    for i = 1:M
        for j = 1:N
            
            if I2(i,j)==z-1
                count=count+1;
            end
        end
    end
            t(z) = count;
            count = 0;
end

disp(t')
%stem(n,t); 
bar(n,t);
xlim([0 255])
ylim([0 2000])
title('Histogramm ohne imhist')

figure,imhist(I2), title('Soll-Histogramm');
