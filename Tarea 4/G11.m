%% TAREA 4: PROCESAMIENTO MORFOLÓGICO
% Álvaro San Román Cárdenas
% Daniel Pérez Gómez

%% PARTE OBLIGATORIA 
%% PRIMER OBJETIVO 
%% I. Transformación del espacio de color HSI
clear all; close all; clc;

% Cargamos imágenes
Im = imread('G11.jpg');
figure, imshow(Im);

% Transformación al espacio HSI 
[I_HSI_H, I_HSI_S,I_HSI_I] = rgb2hsi(Im);

figure,
subplot(1,3,1), imshow(I_HSI_H), title('H')
subplot(1,3,2), imshow(I_HSI_S),title('S')
subplot(1,3,3), imshow(I_HSI_I), title('I')

% Guardamos la componente I, es la que más nos interesa
Componente = I_HSI_I;

%% II. Umbralización
close all; clc;

figure, imhist(Componente);

% Aplicar metodo Otsu
level = graythresh(Componente);
I_U = im2bw(Componente,level);

I_U = uint8(I_U*255);
figure,
subplot(2,1,[1,2]);
imshowpair(Componente,I_U, 'montage');
title('Imagen original y Otsu');
%% III. Aplicación de operadores mormfológicos
close all; clc;

% aplicamos filtro de mediana, para mantener imagen binaria
I_U_filt = medfilt2(I_U,[5 5]);

figure,
subplot(2,1,[1,2]);
imshowpair(I_U,I_U_filt, 'montage');
title('Otsu e imagen filtrada');

EE_cuadrado = strel('square',4); % Elemento estructurante

B_erode = imerode(I_U_filt,EE_cuadrado); % Eosión
B_dilate = imdilate(I_U_filt,EE_cuadrado); % Dilatación
B_Open = imopen(I_U_filt,EE_cuadrado); % Apertura
B_Close = imclose(I_U_filt,EE_cuadrado); % Cierre

figure,subplot(1,4,1), imshow(B_erode), title('Erosión')
subplot(1,4,2), imshow(B_dilate), title('Dilatación')
subplot(1,4,3), imshow(B_Open), title('Apertura')
subplot(1,4,4), imshow(B_Close), title('Cierre')

%% IV. Segmentación y caracterización de objetos
close all; clc;
Im_Res_Morf = B_dilate;

% segmentamos la dilatación
IM_Seg = bwlabel(Im_Res_Morf);
RGB_Segment = label2rgb(IM_Seg);

Num_objetos = max(IM_Seg(:))

% Etiquetar cada objeto en la imagen
propiedades = regionprops(IM_Seg, 'Centroid');

for i = 1:Num_objetos
    RGB_Segment = insertText(RGB_Segment, propiedades(i).Centroid, num2str(i), 'FontSize',18, 'BoxColor', 'white');
end

figure, imshow(RGB_Segment), title('Objetos etiquetados');

% Crear una nueva imagen en blanco del mismo tamaño que IM_Seg
IM_Seg_mod = zeros(size(IM_Seg));

% Asignar el objeto 21 a la nueva imagen
IM_Seg_mod(IM_Seg == 21) = 1;

% Convertir la imagen a uint8 para visualización
IM_Seg_mod = uint8(IM_Seg_mod * 255);

% Mostrar la imagen modificada
figure, imshow(IM_Seg_mod), title('Objeto 21');

%% V. Bounding Box
close all; clc;
% Obtener las propiedades de los objetos en la imagen
propiedades = regionprops(IM_Seg, 'BoundingBox');

% Obtener la bounding box del objeto 21
bbox = round(propiedades(21).BoundingBox);

% Recortar la imagen original usando la bounding box del objeto 21
Im_cropped = imcrop(Im, bbox);

% Mostrar la imagen recortada
figure, imshow(Im_cropped), title('Objeto 21 recortado de la imagen original');

%% PARTE OBLIGATORIA 
%% SEGUNDO OBJETIVO 
%% IV. Segmentación y caracterización de objetos

close all; clc;
% Crear una nueva imagen en blanco del mismo tamaño que IM_Seg
IM_Seg_mod3 = zeros(size(IM_Seg));

% Asignar el objeto 21 a la nueva imagen
IM_Seg_mod3(IM_Seg == 21) = 1;

% Crear una copia de la imagen original
Im_copia = Im;

% Enmascarar cada componente de la imagen original con el objeto 21
Im_copia(:,:,1) = Im_copia(:,:,1) .* uint8(IM_Seg_mod3);
Im_copia(:,:,2) = Im_copia(:,:,2) .* uint8(IM_Seg_mod3);
Im_copia(:,:,3) = Im_copia(:,:,3) .* uint8(IM_Seg_mod3);

% Mostrar la imagen original pero solo con el objeto 21
figure, imshow(Im_copia), title('Imagen original con solo el objeto 21');

%% II. Operadores 
EE_cuadrado = strel('square',5); % Elemento estructurante

R_Close = imerode(Im_copia(:,:,1),EE_cuadrado); 
G_Close = imerode(Im_copia(:,:,2),EE_cuadrado); 
B_Close = imerode(Im_copia(:,:,3),EE_cuadrado); 

figure,
subplot(1,3,1),imshow(R_Close),title('Componente R Erosionada')
subplot(1,3,2),imshow(G_Close),title('Componente G Erosionada')
subplot(1,3,3),imshow(B_Close),title('Componente B Erosionada')

%% III. Recomposición de la imagen en el espacio RGB
I_Close = cat(3, R_Close, G_Close, B_Close);

figure,
subplot(2,1,[1,2]);
imshowpair(Im_copia,I_Close, 'montage');
title('Imagen original e imagen con erosión');

%% PARTE CREATIVA 
%% I. Carga de imágenes
clear all; close all; clc;

Im= imread('G11.jpg');
figure, imshow(Im);

% Transformacion a espacio HSI (RGB no util)
[I_HSI_H, I_HSI_S,I_HSI_I] = rgb2hsi(Im);

figure,
subplot(1,3,1), imshow(I_HSI_H), title('H')
subplot(1,3,2), imshow(I_HSI_S),title('S')
subplot(1,3,3), imshow(I_HSI_I), title('I')

% Guardamos la componente I, la que más nos interesa
Componente = I_HSI_I;
%% II. Umbralización
close all; clc;

figure, imhist(Componente);

% Aplicar metodo Otsu
level = graythresh(Componente);
I_U = im2bw(Componente,level);

I_U = uint8(I_U*255);
figure, imshow(I_U),title('Otsu');
%% III. Aplicación de operadores morfológicos
close all; clc;

% Aplicamos filtro de mediana, para mantener imagen binaria
I_U_filt = medfilt2(I_U,[5 5]);
figure, imshow(I_U_filt),title('Filtro de Mediana');

EE_cuadrado = strel('square',4); % Elemento estructurante

B_dilate = imdilate(I_U_filt,EE_cuadrado); % Dilatación

figure, imshow(B_dilate), title('Dilatación')

%% IV. Segmentación y caracterización de objetos
close all; clc;
Im_Res_Morf = B_dilate;

% segmentamos el cierre
IM_Seg = bwlabel(Im_Res_Morf);
RGB_Segment = label2rgb(IM_Seg);

Num_objetos = max(IM_Seg(:))

% Nueva parte: Etiquetar cada objeto en la imagen
propiedades = regionprops(IM_Seg, 'Centroid');

for i = 1:Num_objetos
    RGB_Segment = insertText(RGB_Segment, propiedades(i).Centroid, num2str(i), 'FontSize',18, 'BoxColor', 'white');
end

% Crear una nueva imagen en blanco del mismo tamaño que IM_Seg
IM_Seg_mod = zeros(size(IM_Seg));

% Asignar los objetos a la nueva imagen
objetos = [17, 15, 18, 19,20,25,27,7,22,13,14,16,11,29,30,33];
for i = 1:length(objetos)
    IM_Seg_mod(IM_Seg == objetos(i)) = 1;
end

% Convertir la imagen a uint8 para visualización
IM_Seg_mod = uint8(IM_Seg_mod * 255);

figure, imshow(IM_Seg_mod), title('CARA DEL ALIEN');
%% V. Gradiente de la imagen
% Crear el gradiente
EE_disk = strel('disk',2);
B_dilate = imdilate(IM_Seg_mod, EE_disk); % Dilatacion imagen 
B_erode = imerode(IM_Seg_mod, EE_disk); % Erosion imagen
B_gradiente = B_dilate - B_erode; % Dilatacion - Erosion

% Añadir gradiente en rojo a la imagen original
Neg_Bgrad = 1- B_gradiente;
figure, imshow(Neg_Bgrad,[]),title('Negativo del gradiente')
I_Recorte2 = Im;
I_Recorte2(:,:,1) = Im(:,:,1).*uint8(Neg_Bgrad);
Frontera(:,:,1) = B_gradiente;
Frontera(:,:,2) = zeros(size(B_gradiente));
Frontera(:,:,3) = zeros(size(B_gradiente));
FINAL = imadd(uint8(255*Frontera),I_Recorte2);
figure, imshow(FINAL,[])
