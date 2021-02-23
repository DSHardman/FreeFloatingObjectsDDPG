function [worldcentre, imagecentre] = SetCentre(I, cameraParams)
%assumes that it has been fed an undistorted image

    imshow(I);
    quarters = ginput(4); %x_left, x_right, y_up, y_down
    close();

    %Using extrinsics from first image in camera calibration
    worldquarters  = pointsToWorld(cameraParams,...
        cameraParams.RotationMatrices(:,:,1),...
        cameraParams.TranslationVectors(1,:), quarters);

    %calculate equations of lines across diameter
    m1 = (worldquarters(2,2)-worldquarters(1,2))/(worldquarters(2,1)-worldquarters(1,1));
    c1 = worldquarters(1,2) - m1*worldquarters(1,1);
    m2 = (worldquarters(4,2)-worldquarters(3,2))/(worldquarters(4,1)-worldquarters(3,1));
    c2 = worldquarters(3,2) - m2*worldquarters(3,1);

    %take their intersection to be the circle centre
    worldcentre = [0 0];
    worldcentre(1) = (c2 - c1)/(m1 - m2);
    worldcentre(2) = (m1*worldcentre(1) + c1);

    imagecentre = worldToImage(cameraParams.Intrinsics,...
        cameraParams.RotationMatrices(:,:,1),...
        cameraParams.TranslationVectors(1,:),[worldcentre 0]);
    
    imshow(I);
    hold on
    viscircles(imagecentre, 5, 'color', 'r');
end
