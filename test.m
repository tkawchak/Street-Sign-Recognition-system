load templates.mat

im_speed = imread('wild_signs\speedLimit\streetsign12.jpg');
bounds1 = matchTemplate(speedLimitTemplate, im_speed);

im_stop = imread('wild_signs\stop\streetsign10.jpg');
bounds2 = matchTemplate(stopSignTemplate, im_stop);