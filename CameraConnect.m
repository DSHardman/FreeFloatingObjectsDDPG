clear cam

%global cam
fprintf('Connecting to camera...\n');
%cam = webcam('Logitech QuickCam Easy/Cool');
%cam.Resolution = '640x480';
%cam = webcam('HP Wide Vision HD');
%cam = webcam('e2eSoft iVCam');

%{
cam = webcam('Logitech BRIO');
cam.resolution = '1024x576';
cam.preview()

fprintf('Press any key to proceed...\n');
pause()
cam.closePreview()
%}

%Try configuring as video input rather than webcam to avoid timeouts
cam = videoinput("winvideo", 1, 'MJPG_1024x576');
preview(cam); %preview must remain open: create new figure here?

fprintf('Connected to camera.\n');
