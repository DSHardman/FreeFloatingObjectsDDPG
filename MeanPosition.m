function [x, y] = MeanPosition(I)
    [Y, ~] = GetYellows2(I); %binary thresholding for yellow areas
    [centresY,radiiY] = imfindcircles(Y, [10, 25], 'Sensitivity', 0.92); %identify circles
    
    imshow(I) %display image
    viscircles(centresY,radiiY, 'color', 'k'); %draw circles
    
    
    if ~isempty(centresY) %return mean positions, or empty array if no circles are identified
        x = mean(centresY(:,1)); 
        y = mean(centresY(:,2));
    else
        x = [];
        y = [];
    end
end