load templates.mat

speedLimitSigns = './wild_signs/speedLimit/';
stopSigns = './wild_signs/stop/';

images = dir(speedLimitSigns);
for i = 3:length(images)
    filename = strcat(speedLimitSigns, images(i).name);
    im_speed = imread(filename);
    figure('units', 'normalized', 'OuterPosition', [0 0 1 1]);
    [~] = matchTemplate(speedLimitTemplate, im_speed);
end


images = dir(stopSigns);
for i = 3:length(images)
    filename = strcat(stopSigns, images(i).name);
    im_stop = imread(filename);
    figure('units', 'normalized', 'OuterPosition', [0 0 1 1]);
    [~] = matchTemplate(stopSignTemplate, im_stop);
end