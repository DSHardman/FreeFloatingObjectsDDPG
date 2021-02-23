I = TakePhoto(cam, cameraParams); [x,y] = SinglePosition(I, imagecentre);
w_p  = pointsToWorld(cameraParams,...
                cameraParams.RotationMatrices(:,:,1),...
                cameraParams.TranslationVectors(1,:), [x y]);

%relative to centre
w_x = w_p(1) - worldcentre(1);
w_y = w_p(2) - worldcentre(2);

[theta, r] = cart2pol(w_x, w_y)