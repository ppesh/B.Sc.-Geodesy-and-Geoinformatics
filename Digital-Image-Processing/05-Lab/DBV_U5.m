
clc
clear all
close all

%% Digitale Bildverarbeitung Übung 5: 
%  Photogrammetrische Punktbestimmung durch Korrelation und Vorwärtsschnitt
%  Preslava Peshkova
%  Matr.-Nr.: 3115785

%%
% Bilder einlesen:
% 1. Bildpaar:
Img1 = imread('8872.tif');
Img2 = imread('8873.tif');

% 2. Bildpaar:
%Img1 = imread('8874.tif'); 
%Img2 = imread('8875.tif');

% 1)
I = imtool(Img1);
[x1,y1] = getpts(I);
Pt1 = [x1;y1];
Pt1 = round(Pt1);
close(I)

I = imtool(Img2);
[x2,y2] = getpts(I);
Pt2 = [x2;y2];
Pt2 = round(Pt2);
close(I)

% 2)
% Transformation d. Pixelkoord. in Bildkoord. mit read_ori_example:
[FocalLength1,PixelSize1,PrincipalPoint1,RotationMatrix1,TranslationVector1,CameraMatrix1] = read_ori('8872.ori');
%[FocalLength1,PixelSize1,PrincipalPoint1,RotationMatrix1,TranslationVector1,CameraMatrix1] = read_ori('8874.ori');
RotationMatrix1 = RotationMatrix1';
P1 = [PixelSize1(2) 0;0 -PixelSize1(1)]*(Pt1-PrincipalPoint1);

[FocalLength2,PixelSize2,PrincipalPoint2,RotationMatrix2,TranslationVector2,CameraMatrix2] = read_ori('8873.ori');
%[FocalLength2,PixelSize2,PrincipalPoint2,RotationMatrix2,TranslationVector2,CameraMatrix2] = read_ori('8875.ori');
RotationMatrix2 = RotationMatrix2';
P2 = [PixelSize2(2) 0;0 -PixelSize2(1)]*(Pt2-PrincipalPoint2);

% vektorielle Betrachtung: 
vecL = inv(CameraMatrix1)*[Pt1;1];                         % Bildkoord.
vecR = inv(CameraMatrix2)*[Pt2;1];

% Bildbasis b:
b = TranslationVector2-TranslationVector1;

% Raumstrahlen:
Raumstrahl1 = RotationMatrix1*vecL;
Raumstrahl2 = RotationMatrix2*vecR;

d = cross(Raumstrahl1,Raumstrahl2);                        % kürzester Abstand zwischen zwei Raumstrahlen
lam = [Raumstrahl1 Raumstrahl2 d]\b;

% Objektpunkt P:
P0 = TranslationVector1+lam(1).*Raumstrahl1+1/2*lam(3).*d;
disp(['Objektraumkoordinaten: X = ',num2str(P0(1)),' Y = ',num2str(P0(2)),' Z = ',num2str(P0(3))])
dist = sum(abs(lam(3).*d));
disp(['Kürzester Abstand zwischen zwei Bildstrahlen: d = ',num2str(dist),' m'])




