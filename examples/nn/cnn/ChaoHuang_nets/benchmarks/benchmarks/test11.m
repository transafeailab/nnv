im = im_data(:,:,1);
im = im/255;

im1 = im + 0.1;

im2 = im - 0.1;

mean = 0.1307;
std = 0.3018; 

 
%im1 = im;

for i=1:28
    for j=1:28
        if im1(i, j) > 1.0
            im1(i, j) = 1.0;
        end
        if im2(i, j) < 0
            im2(i, j) = 0;
        end
    end
end

im1 = (im1 - mean)/std; 
im2 = (im2 - mean)/std;
      
figure;
subplot(1,3,1);
imshow(im);

subplot(1,3,2);
imshow(im1);

subplot(1, 3, 3);
imshow(im2);

truesize([400 400]);