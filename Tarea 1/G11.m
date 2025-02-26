%% PRACTICA 1 PARTE OBLIGATORIA 
% Álvaro San Román Cardenas
% Daniel Pérez Gómez 
%% 1.1 
clear all; close all ; clc ;
 imagen_original = imread ('G11.jpg');
% 1.1.1 escalamos la imagen a 640x480
 imagen = imresize(imagen_original, [640, 400]);
 parte_verde = imagen(:,:,2);
 
% 1.2 Rango original dinámico 
 max_verde = double(max (parte_verde(:)));
 min_verde = double(min (parte_verde(:)));
 DR_ORIGINAL = max_verde - min_verde;


% 2.transformación punto a punto 
 % reducimos rango dinámico
 f_reduc = 0.5;
 min_nuevo = min_verde + (DR_ORIGINAL *(1 - f_reduc))/2;
 max_nuevo = max_verde - (DR_ORIGINAL *(1 - f_reduc))/2; 

 % transiciones
 inicio1 = 0;
 pendiente1 = 0;
 fin1 = min_nuevo;

 inicio2 = min_nuevo;
 pendiente2 = 1;
 fin2 = max_nuevo;

 inicio3 = max_nuevo;
 pendiente3 = 0;
 fin3 = 256;

 x = 0:255;
 m_trans = zeros(size(x));

 m_trans (x >= inicio1 & x < fin1) = pendiente1 * (x(x>=inicio1 & x < fin1)) + min_nuevo;
 m_trans (x >= inicio2 & x < fin2) = pendiente2 * (x(x>=inicio2 & x < fin2));
 m_trans (x >= inicio3 & x < fin3) = pendiente3 * (x(x>=inicio3 & x < fin3)) + max_nuevo;

% 2.1 Graficar el mapa de transición
 figure;
 plot(x, m_trans);
 xlabel('Componente Verde Original');
 ylabel('Componente Verde Transformada');
 title('Mapa de Transición');
 xlim([0, 255]);
 ylim([0, 255]);

% Aplicamos transformación punto a punto.
 imagen_verde_transformada = double(parte_verde);
 imagen_verde_transformada = (imagen_verde_transformada - min_verde) * (max_nuevo - min_nuevo) / (max_verde - min_verde) + min_nuevo;
 imagen_verde_transformada = uint8 (imagen_verde_transformada);

%Vemos transformación punto a punto
 figure;
 subplot(1,2,1);
 imshow(parte_verde);
 title('Parte verde Original');
 subplot(1,2,2);
 imshow(imagen_verde_transformada);
 title('Imagen Transformada');

%2.2 Reemplazar la componente verde original por la componente verde transformada
 imagen_truecolor_transformada = imagen;
 imagen_truecolor_transformada(:,:,2) =imagen_verde_transformada;

% Ecualizar el histograma de la nueva componente verde
 parte_verde_ecualizada = histeq(imagen_verde_transformada);

% Reemplazar la componente verde transformada por la componente verde ecualizada
 imagen_ecualizada = imagen;
 imagen_ecualizada(:,:,2) = parte_verde_ecualizada;

% Mostrar la imagen original, la imagen true color transformada y la imagen true color ecualizada
  figure;
  subplot(1,3,1);
  imshow(imagen);
  title('Imagen Original');
  subplot(1,3,2);
  imshow(imagen_truecolor_transformada);
  title('Imagen Transformada');
  subplot(1,3,3);
  imshow(imagen_ecualizada);
  title('Imagen Ecualizada');

% Obtener y representar el mapa de transición
hist_transf = imhist(imagen_verde_transformada);
hist_ecualizado = imhist( parte_verde_ecualizada);

% Obtener el mapa de transición utilizado para la ecualización

transicion_mapa = cumsum(hist_transf) / sum(hist_transf) * (numel(hist_transf)-1);
% Crear un vector de intensidades para el eje x del gráfico
intensidades = linspace(0, 255, numel(hist_ecualizado));

% Graficar el mapa de transición
figure;
plot(intensidades, transicion_mapa, 'LineWidth', 2);
xlabel('Intensidad componente verde transformada ');
ylabel('Intensidad componente verde ecualizada');
title('Mapa de transición para la ecualización');
grid on;
xlim([0, 255]);
ylim([0, 255]);

%% II
close all; clear all; clc;

imagen_original = imread('G11.jpg');
imagen = imresize(imagen_original, [640, 480]);
Imagen_gris = rgb2gray(imagen);

%Representación tridimensional
 figure;
 subplot(1,2,1);
 imshow(imagen);
 title('Imagen Original');

 subplot(1,2,2);
 imshow(Imagen_gris);
 title('Imagen escala grises');

% Aplicar un filtro de gradiente para enfatizar los bordes verticales
filtro_gradiente = [-1 -2 -1; 0 0 0; 1 2 1]; % Definir filtro de gradiente vertical
imagen_gradiente = imfilter(double(Imagen_gris), filtro_gradiente');

figure;

% Representación tridimensional de la imagen de gradiente
subplot(2,2,1);
mesh(double(Imagen_gris(:,size(Imagen_gris,2):-1:1))), colormap gray;
title('Relieve topográfico de la imagen');
xlabel('Columnas');
ylabel('Filas');
zlabel('Nivel intensidad');

% Representación tridimensional del gradiente.
subplot(2,2,2);
mesh(double(imagen_gradiente(:,size(imagen_gradiente,2):-1:1))), colormap gray;
title('Relieve topográfico del gradiente');
xlabel('Columnas');
ylabel('Filas');
zlabel('Gradiente');

% Mostrar la imagen original y la imagen de gradiente
subplot(2,2,[3,4]);
imshowpair(Imagen_gris, uint8(abs(imagen_gradiente)), 'montage');
title('Imagen original y su gradiente');
xlabel('Imagen original');

%% PARTE CREATIVA
% I. Añadir ruido de sal y pimienta a la imagen.
clear all; close all ; clc ;
imagen_original = imread ('G11.jpg');
imagen = imresize(imagen_original, [640, 400]);

density_values = [0.01, 0.05, 0.1, 0.2, 0.3]; % Densidades de ruido de tipo sal y pimienta que añadimos a la imagen

figure('Name', 'Ruido Sal y Pimienta');
for j = 1:length(density_values)
    I_saltpepper = imnoise(imagen, 'salt & pepper', density_values(j));
    subplot(1, length(density_values), j);
    imshow(I_saltpepper);
    title(['Densidad: ', num2str(density_values(j))]);
end

% II. Comparar filtros para eiliminar el ruido de sal y pimienta.
grises= rgb2gray(imagen);
ruido1 = imnoise(imagen, 'salt & pepper', 0.1);

ruido2 = rgb2gray(imnoise(imagen, 'salt & pepper', 0.1));
H1 = fspecial('average',3);
H2 = fspecial('average',5);

ifiltro1 = imfilter(ruido1,H1,'replicate');
ifiltro2 = imfilter(ruido1,H2,'replicate');
ifiltro3 = medfilt2(ruido2);

% con máscara de 3x3
figure;
subplot(1,3,1); imshow(imagen); title('imagen original');
subplot(1,3,2); imshow(ruido1); title('imagen con ruido ');
subplot(1,3,3); imshow(ifiltro1); title('imagen con filtro 3x3 ');
% con máscara de 5x5
figure;
subplot(1,3,1); imshow(imagen); title('imagen original');
subplot(1,3,2); imshow(ruido1); title('imagen con ruido ');
subplot(1,3,3); imshow(ifiltro2); title('imagen con filtro 5x5 ');

figure;
subplot(1,3,1); imshow(grises); title('imagen original en escala de grises');
subplot(1,3,2); imshow(ruido2); title('imagen con ruido ');
subplot(1,3,3); imshow(ifiltro3); title('imagen con filtro ');

