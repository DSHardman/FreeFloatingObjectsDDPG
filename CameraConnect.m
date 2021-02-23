clear cam

%global cam
fprintf('Connecting to camera...\n');
%cam = webcam('Logitech QuickCam Easy/Cool');
%cam.Resolution = '640x480';
%cam = webcam('HP Wide Vision HD');
%cam = webcam('e2eSoft iVCam');
cam = webcam('Logitech BRIO');
cam.resolution = '1024x576';
cam.preview()
fprintf('Press any key to proceed...\n');
pause()
cam.closePreview()
fprintf('Connected to camera.\n');
