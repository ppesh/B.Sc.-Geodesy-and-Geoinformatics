clc
clear all
close all

%% Bildverarbeitung Uebung 3: Anwendung von Ableitungsoperatoren
% Preslava Peshkova
% Matr.-Nr.: 3115785

%% Teil 1: Schummerung

buff = load('stuttgart_laser.mat');
DHM = buff.DHM;
figure, imshow(DHM,[]), title('Stuttgart DHM')

buff2 = load('schiller_laser.mat');
DHM2 = buff2.DHM;
figure, imshow(DHM2, []), title('Schiller DHM')

l = [-1, -1, sqrt(2)];
L = 1/norm(l)*l;                                                 % Belichtungsvektor
                                 

% Ableitungen in x- und y-Richtung (Stuttgart DHM):
u = 1/8*[-1,0,1; -2,0,2; -1,0,1];                                % x
dx = imfilter(DHM,u,'replicate');
v = 1/8*[1,2,1; 0,0,0; -1,-2,-1];                                % y
dy = imfilter(DHM,v,'replicate');

figure
subplot(1,2,1), imshow(dx,[]), title('Ableitung in x-Richtung (Stuttgart)')
subplot(1,2,2), imshow(dy,[]), title('Ableitung in y-Richtung (Stuttgart)')


% Ableitungen in x- und y-Richtung (Schiller DHM):
dx_Sch = imfilter(DHM2,u,'replicate');                          % x
dy_Sch = imfilter(DHM2,v,'replicate');                          % y

figure
subplot(1,2,1), imshow(dx_Sch,[]), title('Ableitung in x-Richtung (Schiller)')
subplot(1,2,2), imshow(dy_Sch,[]), title('Ableitung in y-Richtung (Schiller)')


% Normalenvektor (Stuttgart DHM):
NormSt = cell([1602,1603]);
Norm_x_St = zeros(1602,1603);
Norm_y_St = zeros(1602,1603);
Norm_z_St = zeros(1602,1603);

for i = 1:1602
    for j = 1:1603
        NormSt{i,j} = [dx(i,j) dy(i,j) 1];
        NormSt{i,j} = NormSt{i,j}./norm(NormSt{i,j});
        Norm_x_St(i,j) =  NormSt{i,j}(1,1);
        Norm_y_St(i,j) =  NormSt{i,j}(1,2);
        Norm_z_St(i,j) =  NormSt{i,j}(1,3);
    end
end


% Normalenvektor (Schiller DHM):
NormSch = cell([233,266]);
Norm_x_Sch = zeros(233,266);
Norm_y_Sch = zeros(233,266);
Norm_z_Sch = zeros(233,266);

for i = 1:233
    for j = 1:266
        NormSch{i,j} = [dx_Sch(i,j) dy_Sch(i,j) 1];
        NormSch{i,j} = NormSch{i,j}./norm(NormSch{i,j});
        Norm_x_Sch(i,j) =  NormSch{i,j}(1,1);
        Norm_y_Sch(i,j) =  NormSch{i,j}(1,2);
        Norm_z_Sch(i,j) =  NormSch{i,j}(1,3);
    end
end


% Skalarprodukt und Skalierung auf verfügbaren Grauwertbereich (Stuttgart DHM):
g_St = uint8((Norm_x_St*L(1)+Norm_y_St*L(2)+Norm_z_St*L(3)).*255);
figure, imshow(g_St), title('Schummerung Stuttgart')


% Skalarprodukt und Skalierung auf verfügbaren Grauwertbereich (Schiller DHM):
g_Sch = uint8((Norm_x_Sch*L(1)+Norm_y_Sch*L(2)+Norm_z_Sch*L(3)).*255);
figure, imshow(g_Sch), title('Schummerung Schiller')


%% Teil 2: Kantendetektion
% Neigungsbetrag:
N = sqrt(dx.^2 + dy.^2);                                          % Stuttgart DHM)                                        
% Neigungsbetrag:
N_Sch = sqrt(dx_Sch.^2 + dy_Sch.^2);                              % Schiller DHM

% Schwellenwert bestimmen:
threshold = 3;                                                           
N(N<threshold) = 0;                                               % Stuttgart DHM
N(N>=threshold) = 1;
N_Sch(N_Sch<threshold) = 0;                                       % Schiller DHM
N_Sch(N_Sch>=threshold) = 1;

% Glättung mit 5x5 Binomialfilter:
bin = [1 4 6 4 1;                                                        
       4 16 24 16 4; 
       6 24 36 24 6; 
       4 16 24 16 4; 
       1 4 6 4 1]./256;
   
St_bin = imfilter(DHM,bin,'replicate');                           % Stuttgart DHM
Sch_bin = imfilter(DHM2,bin,'replicate');                         % Schiller DHM

% Ableitung in x- und y-Richtung (Stuttgart  DHM):
dx_bin = imfilter(St_bin,u,'replicate');                          % x
dy_bin = imfilter(St_bin,v,'replicate');                          % y
% Ableitung in x- und y-Richtung (Schiller DHM):
dx_bin_Sch = imfilter(Sch_bin,u,'replicate');                     % x                     
dy_bin_Sch = imfilter(Sch_bin,v,'replicate');                     % y

% Neigungsbetrag:
N_bin = sqrt(dx_bin.^2 + dy_bin.^2);                              % Stuttgart DHm
N_bin_Sch = sqrt(dx_bin_Sch.^2 + dy_bin_Sch.^2);                  % Schiller DHM

% Erzeugung des Binärbildes:
N_bin(N_bin<threshold) = 0;                                       % Stuttgart  DHM                                              
N_bin(N_bin>=threshold) = 1;

N_bin_Sch(N_bin_Sch<threshold) = 0;                               % Schiller DHM                                            
N_bin_Sch(N_bin_Sch>=threshold) = 1;

% Darstellung:
figure, imshow(N,[]), title('Binärbild (Stuttgart)')
figure, imshow(N_bin,[]), title('Binärbild (Stuttgart) nach der Filterung')

figure, imshow(N_Sch,[]), title('Binärbild (Schiller)')
figure, imshow(N_bin_Sch,[]), title('Binärbild (Schiller) nach der Filterung')

