clc
clear all
close all

%% Bildverarbeitung Uebung 3: Anwendung von Ableitungsoperatoren
% Preslava Peshkova
% Matr.-Nr.: 3115785

%% Teil 3: Bildverbesserung, Kantenverstärkung

I = im2double(imread('einstein.tif'));
figure, imshow(I), title('Originalbild')

LP = 1/8*[0 1 0;1 -4 1;0 1 0];                              % Laplace-Filter

% Extrapolation: 
c = size(I,2);                                              
r = size(I,1);                                              

% upper row
I_ex(1,1) = I(1,1);                                        
I_ex(1,2:c+1) = I(1,:);                                    
I_ex(1,c+2) = I(1,c);                                      

% left column:
I_ex(2:r+1,2:c+1) = I;                                   
I_ex(2:r+1,1) = I(:,1);  
I_ex(r+2,1) = I(r,1);                                        

% lower row
I_ex(r+2,2:c+1) = I(r,:);                                  
I_ex(r+2, c+2) = I(r,c);                                   

% right column:
I_ex(2:r+1,c+2) = I(:,c);                                  

% Bildverbesserung mittels Laplace-Filter:
for i = 1:r
    for h = 1:c
        I_part = zeros(3,3);
        I_part(:,:) = I_ex(i:i+2,h:h+2);
        I_part = I_part.*LP;
        I_LP(i,h) = sum(sum(I_part));
    end
end

  I_LP = I_LP-min(min(I_LP));
  I_LP = I_LP/(max(max(I_LP)));

% High-Boost mit k = 0.5:
k = 0.5;
I_sharp = I-k*I_LP;

% Grauwertbereich anpassen:
I_sharp = I_sharp-(min(min(I_sharp)));
I_sharp = I_sharp/(max(max(I_sharp)));

% Darstellung:
figure, imshow(I_LP), title('Laplace-Bild')
figure, imshow(I_sharp),title('Kantenverstärkung')

