function [ H ] = interest( image )
% interest - find the areas of interest withing the image
% by applying filters and stuff.

    im = rgb2gray(image);
    im = edge(im);

    [H, theta, rho] = hough(im);
    
    figure;
    imshow(imadjust(mat2gray(H)),'XData',theta,'YData',rho,...
       'InitialMagnification','fit');
    title('Limited Theta Range Hough Transform of Gantrycrane Image');
    xlabel('\theta'), ylabel('\rho');
    axis on, axis normal;
    colormap(gca,hot)
    
    figure;
    imshow(image); hold on;
    
    aoi = houghpeaks(H,5,'threshold',ceil(0.3*max(H(:))));
    disp(aoi);
    disp(size(image));
    
    lines = houghlines(im,theta,rho,aoi,'FillGap',5,'MinLength',7);

    max_len = 0;
    for k = 1:length(lines)
       xy = [lines(k).point1; lines(k).point2];
       plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');

       % Plot beginnings and ends of lines
       plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
       plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');

       % Determine the endpoints of the longest line segment
       len = norm(lines(k).point1 - lines(k).point2);
       if ( len > max_len)
          max_len = len;
          xy_long = xy;
       end
    end
    % highlight the longest line segment
    plot(xy_long(:,1),xy_long(:,2),'LineWidth',2,'Color','red');


end

