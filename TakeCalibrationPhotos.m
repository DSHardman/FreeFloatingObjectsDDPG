n_photos = 10;
delay_t = 1; % in seconds

delete('CalibrationImages\*') %delete previous calibration
pause(5);
for i = 1:n_photos
    I = TakePhoto(cam);
    imwrite(I, strcat('CalibrationImages\Image',string(i),'.jpg'));
    imshow(I);
    pause(delay_t);
end
close