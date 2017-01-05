function [shadowless] = ShadowRemoval(image)

% sat_thresh = inputdlg('Enter a saturation threshold for Shadow Removal(0-1)','Saturation Threshold');
sat_thresh = 0.6;
% Convert image from RGB to HSV colour space
hsvconv_img = rgb2hsv(image);

% Split the HSV components
h_component = hsvconv_img(:,:,1);
s_component = hsvconv_img(:,:,2);
v_component = hsvconv_img(:,:,3);

[row col] = size(s_component);

% Thresholding the S component since it tends to contain the shadow.
for ii = 1:row
    for jj = 1:col
        if s_component(ii,jj)> sat_thresh
            s_component(ii,jj) = sat_thresh; %#ok<*ST2NM>
        end
    end
end

% Joining the three components and converting it back to the RGB colour
% space
hsvconv_img = cat(3,h_component,s_component,v_component);
shadowless = hsv2rgb(hsvconv_img);

end
