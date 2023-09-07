

% Clearing all Variables and Command Window

clear all;
close all;
clc;

% Reading the Image from its path

a = imread('path of the image');
figure
imshow(a)
title("Original Image")

% Converting RGB image to Indexed Image
[I, colormap] = rgb2ind(a, 256);

% Size of the Indexed image
[m,n]=size(I);
Totalcount=m*n;

% Probability Calculation
c = 1; % pixel count for the count array
sigma = 0; % Cumulative probability of the pixels
% computing the cumulative probability.
for i = 0:255
k = (I == i);
count(c) = sum(k(:)); % no. of times each pixel is repeated
% prob array is having the probabilities of each pixel
prob(c) = count(c)/Totalcount;
sigma = sigma + prob(c); % sum of all probabilities 
c_prob(c) = sigma;
c = c+1;
end

% Symbols for an image
symbols = [0:255]; % all possible gray scale values

% Huffman code Dictionary
[dict, alen] = huffmandict(symbols,prob);
entropy = - sum (prob .* log10(prob)/log10(2));
disp(['Entropy: ',num2str(entropy),' bits/sym']);
disp(' ');
disp(['Average Length: ',num2str(alen),' bits/sym']);
disp(' ');

% 2 D array to Vector
vec_size = 1;
for p = 1:m
for q = 1:n
newvec(vec_size) = I(p,q);
vec_size = vec_size+1;
end
end

% Huffman Encoding
hcode = huffmanenco(newvec,dict);

% Huffman Decoding
hdeco = huffmandeco(hcode,dict); % huffman encoded array

% Convertign dhsig1 double to dhsig uint8
hdeco1 = uint8(hdeco);

% Convert vector to 2 D array
arr_row = 1;
arr_col = 1;
vec_si = 1;
for x = 1:m
for y = 1:n
d_im(x,y) = hdeco1(vec_si); % decoded image (Indexed)
arr_col = arr_col+1;
vec_si = vec_si + 1;
end
arr_row = arr_row + 1;
end

% Converting image from Index to rgb
RGB = ind2rgb(d_im, colormap); 
RGB1 = im2uint8(RGB); % convert decoded image to uint8
RGB1; % decoded image
% class(RGB1)
imwrite(RGB1,'D:\MATLAB_Codes\ITC_Matlab\ITC photos\flowers_comp.jpg');
figure; 
imshow(RGB1)
title("Compressed Image");

% Comparing original and decoded images
[peaksnr1,snr1] = psnr(RGB1,a);
disp(['Peak SNR : ',num2str(peaksnr1),' dB']);
disp(' ');
disp(['SNR : ',num2str(snr1),' dB']);
disp(' ');


% Efficiency of the Huffman code
code_eff = entropy/alen;
percentage = code_eff*100;
disp(['Efficiency : ',num2str(percentage),' %']);
disp(' ');


