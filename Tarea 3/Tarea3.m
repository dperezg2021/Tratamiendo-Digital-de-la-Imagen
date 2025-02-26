%% PRACTICA 2  
% Álvaro San Román Cardenas
% Daniel Pérez Gómez 

%% PARTE OBLIGATORIA
% Lee la imagen
clear all; close all; clc;

I = imread('G11.jpg');

% Extrae los canales de color RGB
R = I(:,:,1);
G = I(:,:,2);
B = I(:,:,3);

%Aumentar la intensidad del rojo
R = R*1.5;
R(R>255) = 255; %Para que los valores del color rojo no puedan ser mayores de 255
%Combina los canales de nuevo
I_R = cat(3, R, G, B);

figure, imshowpair(I, I_R, 'montage');

[nrows, ncols, ndim] = size (I);
I_R_res = reshape(R, nrows*ncols,1);
I_G_res = reshape(G, nrows*ncols,1);
I_B_res = reshape(B, nrows*ncols,1);

%%
ngrupos = 6;
rgb_res = double([I_R_res I_G_res I_B_res]);
[cluster_idx cluster_center] = kmeans(rgb_res,ngrupos,'distance','sqEuclidean','Replicates',10);
pixel_labels_rgb = reshape(cluster_idx, nrows, ncols);
%% Lab

%Cambio al espacio lab y considero únicamente el espacio ab
[lab_imL, l_L, a_L, b_L] = rgb2lab(I_R);
a_res = reshape(a_L, nrows*ncols, 1);
b_res = reshape(b_L, nrows*ncols, 1);

figure, plot(a_res, b_res, '.')
xlabel('a'), ylabel('b');

%% HSI

%Cambio al espacio HSI y consideramos solo H y S
[ h_I, s_I, i_I] = rgb2hsi(I_R);
h_res = reshape(h_I, nrows*ncols, 1);
s_res = reshape(s_I, nrows*ncols, 1);

figure, plot(h_res, s_res, '.');
xlabel('h'), ylabel('s');

%%
hs_res = double ([h_res s_res]);
[cluster_idx cluster_center] = kmeans(hs_res,ngrupos,'distance','sqEuclidean','Replicates',10);

plot(cluster_center(:,1), cluster_center(:,2),'sr');
axis equal
pixel_labels_hs = reshape(cluster_idx,nrows,ncols);
I_segm = label2rgb(pixel_labels_hs);
figure, imshow(I_segm), title('Segm hs');

%%
hs_res = [h_res s_res];
ndim = size(hs_res,2);
hs_norm = hs_res;

for ind_dim=1:ndim
    datos = hs_res(:,ind_dim);
    datos_norm = (datos-mean(datos))/std(datos);
    hs_norm(:,ind_dim)=datos_norm;
end


[cluster_idx_norm cluster_center] = kmeans(hs_norm,ngrupos,'distance','sqEuclidean','Replicates',20);
pixel_labels_hs_norm = reshape(cluster_idx_norm,nrows,ncols);

figure, plot(hs_norm(:,1), hs_norm(:,2),'.')
xlabel('h-norm'), ylabel('s-norm')
hold on
plot(cluster_center(:,1), cluster_center(:,2),'sr');
axis equal
I_segm = label2rgb(pixel_labels_hs_norm);
figure, imshow(I_segm)

%%
ab_res = [a_res b_res];
[cluster_idx cluster_center] = kmeans(ab_res,ngrupos,'distance','sqEuclidean','Replicates',10);

plot(cluster_center(:,1), cluster_center(:,2),'sr');
axis equal
pixel_labels_ab = reshape(cluster_idx,nrows,ncols);
I_segm = label2rgb(pixel_labels_ab);
figure, imshow(I_segm), title('Segm ab')

ab_res = [a_res b_res];
ndim = size(ab_res,2);
ab_norm = ab_res;

for ind_dim=1:ndim
    datos = ab_res(:,ind_dim);
    datos_norm = (datos-mean(datos))/std(datos);
    ab_norm(:,ind_dim)=datos_norm;
end


[cluster_idx_norm cluster_center] = kmeans(ab_norm,ngrupos,'distance','sqEuclidean','Replicates',10);
pixel_labels_ab_norm = reshape(cluster_idx_norm,nrows,ncols);

figure, plot(ab_norm(:,1), ab_norm(:,2),'.')
xlabel('a-norm'), ylabel('b-norm')
hold on
plot(cluster_center(:,1), cluster_center(:,2),'sr');
axis equal
I_segm = label2rgb(pixel_labels_ab_norm);
figure, imshow(I_segm)

