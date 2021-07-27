% Bildverarbeitung
% Preslava Peshkova
% Matr.-Nr.: 3115785

clc;
clear all; 
close all;

%% Übung 2: Pan-Sharpening

% Bilder einlesen
I_pan = imread('DMC_haeuser_pan.bmp');
figure, imshow(I_pan), title('Panchromatisches Bild')
I_pan_double = im2double(I_pan);

I_rgb_original = imread('DMC_haeuser_lowRGB_original.bmp');
%figure, imshow(I_rgb_original), title('Originales Bild')

% Transformation von RGB in IHS
R = im2double(I_rgb_original(:,:,1));
G = im2double(I_rgb_original(:,:,2));
B = im2double(I_rgb_original(:,:,3));

[I,H,S] = rgb2hsi(R,G,B);

% Anpassung der Größe des RGB-Bildes auf die Größe des SW-Bildes
I_hsi = cat(3,I,H,S);
I_scale = imresize(I_hsi,size(I_pan),'bilinear');
H_scale = I_scale(:,:,2);
S_scale = I_scale(:,:,3);
I_RGB_scale = imresize(I_rgb_original,size(I_pan),'bilinear');
figure, imshow(I_RGB_scale), title('Skalliertes Bild')

% Rücktransformation von IHS in RGB
I_trafo = cat(3,I_pan_double,H_scale,S_scale);
I_new = hsi2rgb(I_trafo);
I_new = im2uint8(I_new);
figure, imshow(I_new), title('Neues Bild')


% Plotten der Bilder
figure();
subplot(2,3,1), imshow(im2uint8(R)), title('Red')
subplot(2,3,2), imshow(im2uint8(G)), title('Green')
subplot(2,3,3), imshow(im2uint8(B)), title('Blue')
subplot(2,3,4), imshow(im2uint8(I)), title('Intensity')
subplot(2,3,5), imshow(im2uint8(H)), title('Hue')
subplot(2,3,6), imshow(im2uint8(S)), title('Saturation')


