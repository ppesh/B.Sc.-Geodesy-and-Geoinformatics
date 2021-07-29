function [FocalLength,PixelSize,PrincipalPoint,RotationMatrix,TranslationVector,CameraMatrix] = read_ori(ori_File)
% Parse Ori-File and provide orientation parameters
 
[fid,Msg] = fopen(ori_File,'rt');   % open file in read text mode
if fid == -1, error(Msg); end
 
% Lese Kommentarzeile
Buf = fgetl(fid);%fprintf(Buf,'\n');
% Lese zweite Zeile mit Kamera ID
ImageID = fscanf(fid,'%d',1);
% Lese Kommentarzeile
Buf = fgetl(fid);Buf = fgetl(fid);
% Lese 4. Zeile mit Brennweite
FocalLength = fscanf(fid,'%f',1);
% Lese Kommentarzeile
Buf = fgetl(fid);Buf = fgetl(fid);%fprintf(Buf,'\n');
% Lese 4. Zeile mit pixelgr??e
PixelSize = fscanf(fid,'%f',2);
% Lese Kommentarzeile
Buf = fgetl(fid);Buf = fgetl(fid);%fprintf(Buf,'\n');
% Lese 6. Zeile mit pixelgr??e
SensorSize = fscanf(fid,'%f',2);
% Lese Kommentarzeile
Buf = fgetl(fid);Buf = fgetl(fid);%fprintf(Buf,'\n');
% Lese 6. Zeile mit pixelgr??e
PrincipalPoint = fscanf(fid,'%f',2);
% Lese Kommentarzeile
Buf = fgetl(fid);Buf = fgetl(fid);%fprintf(Buf,'\n');
% Lese 8. bis 10. Zeile mit CameraMatrix
C_1 = fscanf(fid,'%f',3);
C_2 = fscanf(fid,'%f',3);
C_3 = fscanf(fid,'%f',3);
CameraMatrix=[C_1';C_2';C_3'];
% Lese Kommentarzeile
Buf = fgetl(fid);Buf = fgetl(fid);%fprintf(Buf,'\n');
% Lese 12. bis 14. Zeile mit RotationMatrix
R_1 = fscanf(fid,'%f',3);
R_2 = fscanf(fid,'%f',3);
R_3 = fscanf(fid,'%f',3);
RotationMatrix = [R_1';  R_2';  R_3'];
% Lese Kommentarzeile
Buf = fgetl(fid);Buf = fgetl(fid);%fprintf(Buf,'\n');
% Lese 16. Zeile mit TranslationVector
TranslationVector = fscanf(fid,'%f',3);