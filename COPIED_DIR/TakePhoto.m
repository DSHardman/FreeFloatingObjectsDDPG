function I = TakePhoto(cam, cameraParams)
%incorporates cropping into picture obtaining
    %I = cam.snapshot();
    I = getsnapshot(cam);
    I = imcrop(I, [180 0 650 1080]);
    %I = I./2; %reduce brightness
    
    if (nargin==2) %return undistorted image if possible
        I = undistortImage(I, cameraParams, 'OutputView', 'same');
        %using 'same' keeps same number of pixels in final image: no coordinate
        %shifts. Note this was the default anyway.
    end
end