function normalized_image = normalize(mean_data,std_data,Image)
if ~all(mean_data==0) && ~all(std_data==1)
    I=reshape(Image,3,1024);
    for i=1:3
        J(:,:,i)=reshape(I(i,:),32,32);
        J(:,:,i)=J(:,:,i)';
    end
    for i=1:3
      norm_im(:,:,i) = (J(:,:,i) - mean_data(i))/std_data(i);
    end
    normalized_image=norm_im;
else 
    normalized_image = Image-0.5;
end

end