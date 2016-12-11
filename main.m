load templates3.mat

speedLimitSigns = './wild_signs/speedLimit/';
stopSigns = './wild_signs/stop/';
otherSigns = './wild_signs/misc/';

images = dir(speedLimitSigns);
for i = 3:length(images)
    filename = strcat(speedLimitSigns, images(i).name);
    im_speed = imread(filename);
    fig_speed = figure('units', 'normalized', 'OuterPosition', [0 0 1 1]);
    [~] = matchTemplate(speedLimitTemplate, im_speed);
    saveas(fig_speed, strcat('speedLimit_', images(i).name));
    fig_stop = figure('units', 'normalized', 'OuterPosition', [0 0 1 1]);
    [~] = matchTemplate(stopSignTemplate, im_speed);
    saveas(fig_stop, strcat('stop_', images(i).name));
    close(fig_speed);
    close(fig_stop);
end
 

images = dir(stopSigns);
for i =3:length(images)
    filename = strcat(stopSigns, images(i).name);
    im_stop = imread(filename);
    fig_speed = figure('units', 'normalized', 'OuterPosition', [0 0 1 1]);
    [~] = matchTemplate(speedLimitTemplate, im_stop);
    saveas(fig_speed, strcat('speedLimit_', images(i).name));
    fig_stop = figure('units', 'normalized', 'OuterPosition', [0 0 1 1]);
    [~] = matchTemplate(stopSignTemplate, im_stop);
    saveas(fig_stop, strcat('stop_', images(i).name));
    close(fig_speed);
    close(fig_stop);
end


images = dir(otherSigns);
for i = 3:length(images)
    filename = strcat(otherSigns, images(i).name);
    im_ = imread(filename);
    fig_speed = figure('units', 'normalized', 'OuterPosition', [0 0 1 1]);
    [~] = matchTemplate(speedLimitTemplate, im_);
    saveas(fig_speed, strcat('speedLimit_', images(i).name));
    fig_stop = figure('units', 'normalized', 'OuterPosition', [0 0 1 1]);
    [~] = matchTemplate(stopSignTemplate, im_);
    saveas(fig_stop, strcat('stop_', images(i).name));
    close(fig_speed);
    close(fig_stop);
end