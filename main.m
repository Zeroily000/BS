%% 3d Gaussian Model
clear;clc;
%% Read background timestamp
timestamp = load('background/cam0/timestamp0.txt');
n = size(timestamp, 1);
rows = 720;
cols = 1280;
%% Read background images
background = zeros(rows, cols, 3, n);
% figure
for i = 1 : n
    filename = ['background/cam0/left/', num2str(timestamp(i)), '.png'];
    background(:, :, :, i) = imread(filename);
%     imshow(uint8(background(:, :, :, i)));
%     pause(0.05);
end
%% Get parameters(mu, sigma)
mu = mean(background, 4);
sigma = sum((background - mu).^2, 4)/(n-1);
rng(0)
sigma(find(sigma == 0)) = rand;
% threshold = 0.01
%% Read test image
img = double(imread('398940709150.png'));
%% Reshape
X = reshape(img, rows*cols, 3);
MU = reshape(mu, rows*cols, 3);
SIGMA = zeros(3,3,rows*cols);
scale = 1;
cnt = 1;
for j = 1:cols
    for i = 1:rows
        SIGMA(:,:,cnt) = scale * reshape(sigma(i,j,:),1,[]) .* eye(3);
        cnt = cnt + 1;
    end
end
%% Estimate
y = mvnpdf(X,MU,SIGMA);
%% Output
mask = zeros(rows*cols,1);
% mask(find(y<1e-300)) = 1;
% mask(find(y>=1e-300)) = 0;
mask(find(y==0)) = 1;
mask(find(y>0)) = 0;
figure
imshow(reshape(mask,rows,cols))








