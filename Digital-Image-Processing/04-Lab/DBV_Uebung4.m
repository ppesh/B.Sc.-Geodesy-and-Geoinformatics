clc
clear all
close all

%% Digitale Bildverarbeitung Übung 4: Projektive Bildtransformation durch homogene Koordinaten
% Preslava Peshkova
% Matr.-Nr.: 3115785

%% Teil a): Homographie H
% 1.Bildpaar (Gebäudefassade):
% Bild1 = imread('DSC_0187.jpg');                
% Bild2 = imread('DSC_0188.jpg');

% 2.Bildpaar (Seminarraum):
I1 = imread('DBV_2017_1.jpg');
I2 = imread('DBV_2017_2.jpg');

I1 = imresize(I1,0.5);
I2 = imresize(I2,0.5);
 
% Originalbilder:
% figure; img1 = imshow(I1), title('Originalbild 1');
% figure; img2 = imshow(I2), title('Originalbild 2');

I1 = imresize(I1,0.5);                
I2 = imresize(I2,0.5);

% Punkte im Bild 1 auswählen:
imshow(I1), title('Bitte wählen Sie 6 Punkte aus!');
[x,y] = getline('closed');
NPts = length(x)-1;
if NPts < 6
    fprintf('Die Anzahl der Punkte ist ungenügend!');
end

% Markierung der Punkte im Bild:
pts1 = [x(1:NPts),y(1:NPts)]';
hold on,
plot([x(1:NPts);x(1)],[y(1:NPts);y(1)],'ro')
title('ausgewählte Punkte im Bild 1');
drawnow

% Punkte im Bild 2 auswählen:
figure;
imshow(I2)
title('Bitte wählen Sie 6 identische Punkte!');
[x,y] = getline('closed');

% Vergleich der Anzahl der Punkte:
if (length(x)-1)~=NPts
    fprintf('Die Anzahl der Punkte stimmt nicht überein!');
end

pts2 = [x(1:NPts),y(1:NPts)]';
hold on,
plot([x(1:NPts);x(1)],[y(1:NPts);y(1)],'ro')
title('ausgewählte Punkte im Bild 2');
drawnow

fprintf('Anzahl der Messpunkte %i\n',NPts);

% Bestimmung der homogenen Koordinaten:
x1 = [pts1; ones(1,NPts)];
x2 = [pts2; ones(1,NPts)];

A = zeros(2*NPts,9);
O = [0 0 0];

for n = 1:NPts
    X = x1(:,n)';
    x = x2(1,n);
    y = x2(2,n);
    w = x2(3,n);
    A(2*n-1,:) = [O, -w*X, y*X];
    A(2*n,:) = [w*X, O, -x*X];
end

[U, D, V] = svd(A,0);                            % Singulärwertzerlegung
H = reshape(V(:,9),3,3)';                        % H-Matrix

% Vergleichsbild mit ausgewählten Punkten
x1hs = x1';
x2hs = x2';

figure;
h0 = imshow([I1, I2]);
title('Originalbilder mit ausgewählten Punkten')
hold on;
diff = length(I1);
line([x1hs(:,1),x2hs(:,1)+diff]',[x1hs(:,2),x2hs(:,2)]');
hold off;

x_calc_h = H*x1;
x_calc = [x_calc_h(1,:)./x_calc_h(3,:);x_calc_h(2,:)./x_calc_h(3,:)];
fehler = [x2(1,:)-x_calc(1,:);x2(2,:)-x_calc(2,:)];

%% Teil b): Bildtransformation
[width,height,numbands] = size(I1);

% Matrix in Pixelkoord.:
[xi, yi] = meshgrid(1:height, 1:width);
TransPoints = [xi(:) yi(:) ones(length(yi(:)),1)]';

% Pixelkoord. in Bildkoord. transformieren:
pix_pts = H*TransPoints;

% Normierung der Pixelkoordinaten
pix_pts(1,:) = pix_pts(1,:)./pix_pts(3,:);
pix_pts(2,:) = pix_pts(2,:)./pix_pts(3,:);
pix_pts(3,:) = [];

xi = reshape(pix_pts(1,:),width,height);
yi = reshape(pix_pts(2,:),width,height);

% Grauwertinterpolation:
imghsv1 = rgb2hsv(I1);
imggrey1 = imghsv1(:,:,3);
imghsv2 = rgb2hsv(I2);
imggrey2 = imghsv2(:,:,3);

imgneu = interp2(double(imggrey2),xi,yi,'linear',0);

% Ausgabe Original-, transformiertes und überlagertes Bild
figure; h1 = imshow([imggrey1, imggrey2, imgneu]), title('Originalbilder und transformiertes Bild')

%% Teil c): Überlagerung der Bilder:
imgoverlay = (0.5*imgneu+0.5*double(imggrey1));
figure, imshow(imgoverlay), title('überlagertes Bild');

