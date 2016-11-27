function [parameters]=hough_elli(img, A2min, min_votes)
    A2min = 10;
    min_votes = 10;
    [width height] = size(img);
    % Finding all nonzero pixels of the image, possible ellipse's pixels.
    [ys xs] = find(img);
    pixels = [xs ys];
    % Accumulator for the minor axis' half-length. The indexes correspond to the
    % possible b values. 
    % TODO: the data structure can be improved (tree with the possible values?).
    acc = zeros(1, max(width, height)/2);
    % ij1, ij2 are indexes of (x1, y1) and (x2, y2), following the reference [1].
    for ij1 = 1:(length(xs)-1)
        for ij2 = length(xs):-1:(ij1+1)
            x1 = pixels(ij1, 1);
            y1 = pixels(ij1, 2);
            x2 = pixels(ij2, 1);
            y2 = pixels(ij2, 2);
            d12 = norm([x1 y1] - [x2 y2]);
            acc = acc * 0;
            if  x1 - x2 && d12 > A2min
                % Center
                x0 = (x1 + x2)/2;
                y0 = (y1 + y2)/2;
                % Half-length of the major axis.
                a = d12/2;
                % Orientation.
                alpha = atan((y2 - y1)/(x2 - x1));
                % Distances between the two points and the center.
                d01 = norm([x1 y1] - [x0 y0]);
                d02 = norm([x2 y2] - [x0 y0]);
                for ij3 = 1:length(xs)
                    % The third point must be a different point, obviously.
                    if (ij3 == ij1) && (ij3 == ij2)
                        continue;
                    end
                    x3 = pixels(ij3, 1);
                    y3 = pixels(ij3, 2);
                    d03 = norm([x3 y3] - [x0 y0]);
                    % Distance f
                    if  d03 >= a
                        continue;
                    end
                    f = norm([x3 y3] - [x2 y2]);
                    % Estimating the half-length of the minor axis.
                    cos2_tau = ((a^2 + d03^2 - f^2) / (2 * a * d03))^2;
                    sin2_tau = 1 - cos2_tau;
                    b = round(sqrt((a^2 * d03^2 * sin2_tau) /...
                                (a^2 - d03^2 * cos2_tau)));
                    % Changing the score of the accumulator, if b is a valid value.
                    % NOTE: the accumulator's length gives us the biggest expected
                    % value for b, which means, in this current implementation,
                    % we wouldn't detect ellipses whose half of minor axis is
                    % greater than the image's size (look at the acc's declaration).
                    if b > 0 && b <= length(acc)
                        acc(b) = acc(b) + 1;
                    end
                end
                % Taking the highest score.
                [sv si] = max(acc);
                if sv > min_votes
                    % Ellipse detected!
                    % The index si gives us the best b value.
                    parameters = [x0 y0 a si alpha];
                    return;
                end
            end
        end
    end
%     printf("No ellipses detected!\n");
end