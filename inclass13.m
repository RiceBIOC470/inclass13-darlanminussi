%Inclass 13

%Part 1. In this directory, you will find an image of some cells expressing a 
% fluorescent protein in the nucleus. 
% A. Create a new image with intensity normalization so that all the cell
% nuclei appear approximately eqully bright. 

reader = bfGetReader('Dish1Well8Hyb1Before_w0001_m0006.tif');

zplane = 1;
chan_c1 = 1;
time = 1;

iplane = reader.getIndex(zplane-1, chan_c1-1, time-1)+1;

img = bfGetPlane(reader, iplane);

imshow(img);

img = im2double(img);

img_sm = imfilter(img, fspecial('gaussian',4,2));
img_bg = imopen(img_sm, strel('disk',100));

img_bgsub = imsubtract(img_sm, img_bg);

imshow(img_bgsub);

img_dilate = imdilate(img_bgsub, strel('disk',150));
img_norm = img_bgsub./img_dilate;
imshow(img_norm, []);

% B. Threshold this normalized image to produce a binary mask where the nuclei are marked true. 

img_norm_t = img_norm > .15;
imshow(img_norm_t, []);

% C. Run an edge detection algorithm and make a binary mask where the edges
% are marked true.

edge_img = edge(img_norm_t, 'canny');
imshow(edge_img);

% D. Display a three color image where the orignal image is red, the
% nuclear mask is green, and the edge mask is blue. 

all = cat(3, img, img_norm_t, edge_img);
imshow(all);

%Part 2. Continue with your nuclear mask from part 1. 
%A. Use regionprops to find the centers of the objects

cent = regionprops(img_norm_t, 'Centroid');

for i = 1:length(cent)
    x_cent(i) = cent(i).Centroid(1);
    y_cent(i) = cent(i).Centroid(2);
end

%B. display the mask and plot the centers of the objects on top of the
%objects

imshow(img_norm_t);
hold on;
plot(x_cent, y_cent, 'r*');


%C. Make a new figure without the image and plot the centers of the objects
%so they appear in the same positions as when you plot on the image (Hint: remember
%Image coordinates). 

plot(-y_cent, x_cent, 'r*');
