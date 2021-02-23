function [x, y] = SinglePosition(I, imagecentre)
    [B, ~] = GetOrange(I); %binary thresholding for orange areas
    [centres,radii, metric] = imfindcircles(B, [10, 50], 'Sensitivity', 0.95); %identify circles
    %note that a higher sensitivity will find more circles
    
    imshow(I) %display image
    viscircles(imagecentre, 2, 'color', 'r');
    
    %metric(1) %uncomment for testing
    
    if (~isempty(centres) && metric(1) > 0.5) %return circle corresponding to highest metric
        x = centres(1,1);
        y = centres(1,2);
        viscircles(centres(1,:),radii(1,:), 'color', 'k'); %draw circles
    else %return empty array if no circles have been found
        x = [];
        y = [];
    end
end