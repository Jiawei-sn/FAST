function tiltPhase = tiltPhase(imageSize, tiltAngleX, tiltAngleY, tiltCenter)
% Create tilted phase mask on SLM
% imageSize - 2D matrix with image size in [imageSizeY imageSizeX]
% tiltAngleX, tiltAngleY - tilt angle in degree
% tiltCenter - Center point of the tilt [CenterX CenterY]
% Copyright to Jiawei Sun 10.03.2020

tilt = zeros(imageSize);

for x= 1:imageSize(2)
    for y= 1:imageSize(1)           
    tilt(y,x) = tand(tiltAngleX)*x+tand(tiltAngleY)*y-(tand(tiltAngleX)*tiltCenter(1))-(tand(tiltAngleX)*tiltCenter(2)); 
    end
end

tiltPhase = wrapTo2Pi(tilt);

end