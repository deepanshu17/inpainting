function inpainting_test()
    clear all;
    clc;
    img = imread('test/01.jpg');
    % figure
    subplot(3,1,1), imshow(img) % debug
    % Creating a mask for the black tick line.
    [nr nc d] = size(img);
    mask = zeros(nr, nc);
    % Pixel indexes of the black tick line.
    blackIdxs = find(img(:,:,1) < 30);
    % Only the line pixels are white.
    mask(blackIdxs) = 1;
    % Dilating the region a little bit to include the smooth border of the line.
    mask = imdilate(mask, strel('diamond', 1));
    subplot(3,1,2), imshow(mask) % debug
    tic
    ret = inpainting(img, mask);
    toc
    subplot(3,1,3), imshow(ret) % debug
end
