function [segmented_images,orig_ar] = DetectDisease(img)

area_dis = 0;

%Detecting diseased area for fruits/leaves

[row col channel] = size(img);

% Extracting the area of the object from the background black area
% img3 = rgb2gray(img);
% img3 = img3>(10/255);
img3 = im2bw(img,0.7);
img3 = ~img3;
[L3 num3] = bwlabel(img3);
st = regionprops(L3,'Area');

% Calculating the actual area of the object
orig_ar = st(1).Area;
for i = 1:num3   
    temp = st(i).Area;
    if temp > orig_ar
        orig_ar = temp;
    end
end

%calculate the background black area
area_extra = (row*col) - orig_ar;

% % converting the image to L*a*b form
cform = makecform('srgb2lab');
lab_he = applycform(img,cform);
ab = double(lab_he(:,:,2:3));
ab = reshape(ab,480*640,2);

% specifying the number of clusters required
nColours = 3;

% applying kmeans filtering
[IDX C] = kmeans(ab,nColours,'distance','cityblock','Replicates',2);

pixel_labels = reshape(IDX,480,640);

segmented_images = cell(1,3);
rgb_label = repmat(pixel_labels,[1 1 3]);

% extracting individual clusters
for k = 1:nColours
        color = img;
        color(rgb_label ~= k) = 0;
        segmented_images{k} = color;
end
