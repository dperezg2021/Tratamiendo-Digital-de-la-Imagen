%% PRACTICA 2 PARTE OBLIGATORIA 
% Álvaro San Román Cardenas
% Daniel Pérez Gómez 
%% 1.1 
clear all; close all ; clc ;
% 1. Cargamos imagen.
imagen_original = imread ('G11.jpg');
imagen = imresize(imagen_original, [640, 400]);
Imagen_gris = rgb2gray(imagen);

% 2. Creamos máscara y generamos imagen degradada.

h = 1 /36*ones(6,6);
I_degradada = imfilter(Imagen_gris,h);

% 3. Visualizamos imágenes.
figure;
subplot(2,1,[1,2]);
imshowpair(Imagen_gris,I_degradada, 'montage');
title('Imagen original e imagen filtrada');

%% 
% Analizar y comparar el módulo de la FFT de la imagen original (en escala de grises) con el
%de la imagen suavizada. Aplique, si lo considera oportuno, alguna transformación para
%visualizar mejor el módulo de la FFT. (1 punto)

% 1. Obtenemos la TTF de las imágenes centradas para facilitar su
% visualización.

IG_FFT= fftshift(fft2(double(Imagen_gris),640, 400));
FFT_modulo_IG=abs(IG_FFT);

IGF_FFT = fftshift(fft2(double(I_degradada),640,400));
FFT_modulo_IGF=abs(IGF_FFT);

% 2. Aplicamos una transformación logaritmica.

FFT_log_IG=log10(1+FFT_modulo_IG);
FFT_log_IGF=log10(1+FFT_modulo_IGF);

% 3. Visualizamos módulo y fase de la PSF.
figure;
subplot(1,2,1);
imshow(FFT_log_IG,[]), title('Módulo original')
subplot(1,2,2);
imshow(FFT_log_IGF,[]), title('Módulo filtrado')
%% 
% Empleando la imagen original (en escala de grises) y la imagen suavizada, estime la Point
% Spread Function (PSF) en el dominio frecuencial. (1.5 puntos)

% 1.Aplicamos transformada de Fourier y calculamos psf.
IG_FFT_op= fft2(double(Imagen_gris),640, 400);
IGF_FFT_op = fft2(double(I_degradada),640,400);

psf = IGF_FFT_op ./IG_FFT_op;

% 2.Visualizamos las tres imágenes.
figure,
subplot(1,2,1);imshow(abs(psf), []);title ('PSF en el dominio de la frecuencia (modulo)');
subplot(1,2,2);imshow(angle(psf), []); title ('PSF en el dominio de la frecuencia ( fase)');
%%
% 1. Generemos la imagen original.
I_rest = (1./psf);
Irecovered =real(ifft2(I_rest.* IGF_FFT_op));

% 2.Visualización imágenes.
 figure;
 subplot(1,3,1); imshow(Imagen_gris); title('Original');
 subplot(1,3,2); imshow(I_degradada); title('Suavizada');
 subplot(1,3,3); imshow(uint8(Irecovered)); title ( 'Restaurada');

 %% Parte Creativa

close all; clear all; clc
% 1. Cargar imagen.
imagen_original = imread ('G11.jpg');
imagen = imresize(imagen_original, [640, 400]);
Imagen_gris = rgb2gray(imagen);

% 2. Aplica diferentes filtros de suavizado.
imagen_suavizada_gauss = imgaussfilt(Imagen_gris, 2); % Filtro Gaussiano
imagen_suavizada_mediana = medfilt2(Imagen_gris, [3, 3]); % Filtro de mediana
imagen_suavizada_promedio = filter2(fspecial('average', 3), Imagen_gris); % Filtro de promedio

% 3. Realce de contornos.
realce_gauss = abs(Imagen_gris - imagen_suavizada_gauss);
realce_mediana = abs(Imagen_gris - imagen_suavizada_mediana);
realce_promedio = abs(im2double(Imagen_gris) - im2double(imagen_suavizada_promedio));

% 4. Visualización y comparación de resultados.

figure, 

subplot(2, 3, 4); imshow(realce_gauss);
title('Realce de Contornos (Gaussiano)');
subplot(2, 3, 6); imshow(realce_promedio);
title('Realce de Contornos (Promedio)');

 subplot(2, 3, 5); imshow(realce_mediana);
title('Realce de Contornos (Mediana)');

 subplot(2, 3, 1); imshow(imagen_suavizada_gauss);
 title('Imagen Suavizada (Gaussiano)');

 subplot(2, 3, 2); imshow(imagen_suavizada_mediana);
 title('Imagen Suavizada (Mediana)');
 
 subplot(2, 3, 3); imshow(imagen_suavizada_promedio);
 title('Imagen Suavizada (Promedio)');