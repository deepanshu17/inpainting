img = imread('test/08.jpg');
gray = rgb2gray (img);
h_img = baseline_removal(gray, 1, 10);
v_img = baseline_removal(gray, 1, 8, 90);
subplot(1,3,1), imshow(gray)
subplot(1,3,2), imshow(h_img)
subplot(1,3,3), imshow(v_img)
