function drawtarget_IROS(State, cam, cameraParams, worldcentre, imagecentre)
        
        [x, y] = pol2cart(pi/2*(State(3,1)+1)+pi/4, 175);
        x = x + worldcentre(1);
        y = y + worldcentre(2);

        target = worldToImage(cameraParams,...
            cameraParams.RotationMatrices(:,:,1),...
            cameraParams.TranslationVectors(1,:), [x y 0]);
        
        viscircles(target, 2, 'color', 'b');
        
end