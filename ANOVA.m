% ANOVA Function: 
% By analyzing the evaluation results of a focus measure under different image contents, 
% it is determined whether the focus measure is independent of the image content or sensitive to defocus.

% Usage:
% Input:
% r --> It is set according to the number of the defocus blur levels (A).
% 4 levels of defocus blur (0, 0.5, 1, 1.5) are adopted, so r is equal to 4. 

% s --> It is set according to the number of different image contents (B).
% The number of images in DBIC dataset for simulated images, TID2013 Database, LIVE Database, and IVC Database are 12, 25, 29, and 10, respectively.
% Thus, s is equal to 12, 25, 29, and 10.

% c --> It is set according to the total number of repeated experiments at each level pair (Ai, Bj).
% 5 repetitions of experiments are conducted. Thus, c is equal to 5.

% FM --> Focus measure. 
% In this file, Focus measure available for selection include:
% Ten, SpF, EOL, SML, Bre, SWC, VWC, Var, Ent, Eig, DER, AC, StF.
% EMBM, MGVG, and FocusNet can be found in the corresponding references.

% Output: 
% F_defocus and F_content

% Query the statistical distribution table about F distribution to find the critical value.
% F_defocus obeys F𝛼(df_defocus, df_error); F_content obeys F𝛼(df_content, df_error).

% Results: 
% if F_defocus is greater than the critical value F𝛼(df_defocus, df_error), 
% it is considered that defocus blur has a significant impact on the focus measure. 
% Otherwise, it has no significant impact.
% if F_content is greater than the critical value F𝛼(df_content, df_error), 
% it is considered that image content has a significant impact on the focus measure. 
% Otherwise, it has no significant impact.



%% Definition
r = 4;      % The number of the defocus blur levels (A).
s = 29;     % The number of different image contents (B).
c = 5;      % The total number of repeated experiments at each level pair (Ai, Bj).
FM = 'Ten'; % Focus measure is tested.
FMValues = cell(r, s);      % FMValues: Focus measure values under different image contents and defocus blur levels.
                            % The cell matrix that stores the focus measure values. 
                            % Each element of this cell matrix stores all the focus measure values at the level (Ai, Bj).

% Take this matrix as an example for Focus measure --> Ten.
for i = 1:size(FMValues, 1)
    sigma = (i - 1) / 2;
    for j = 1:size(FMValues, 2)
        temp = zeros(1, 5);
        for num = 1 : 5
            img_name = strcat('./DBIC_Dataset/LIVE_Database/Gaussian_blur_standard_deviation=', num2str(sigma), ...
                '/img', num2str(j), '_defocus_blur_', num2str(sigma), '_Gaussian_white_noise_0.001_', num2str(num), '.bmp');
            img = imread(img_name);
            [h, w] = size(img);
            temp(1, num) = FMsCalculation(img, FM, [1, 1, w, h]);
        end
        FMValues{i, j} = temp;
    end
end

% mean values
mean_xi__ = zeros(r, 1);
mean_x_j_ = zeros(1, s);
mean_xij_ = zeros(r, s);

SS_defocus = 0;     % Sum of Square of defocus blur
SS_content = 0;     % Sum of Square of image contents
SS_defocus_content = 0;     % Sum of Square of interaction
SS_error = 0;     % Sum of Square of error

df_defocus = r - 1;     % Degree of freedom of defocus blur
df_content = s - 1;     % Degree of freedom of image contents
df_defocus_content = (r - 1)*(s - 1);     % Degree of freedom of interaction
df_error = r * s * (c - 1);     % Degree of freedom of error

% MS_defocus     Mean Square of defocus blur
% MS_content     Mean Square of image contents
% MS_defocus_content     Mean Square of interaction
% MS_error     Mean Square of error

% F_defocus     F-ratio for defocus blur
% F_content     F-ratio for image contents

%% Calculating Mean Value
for i = 1 : r
    xi = 0;
    for j = 1 : s
        xi = xi + sum(FMValues{i, j});
    end
    mean_xi__(i, 1) = xi / (s * c);
end

for j = 1 : s
    xj = 0;
    for i = 1 : r
        xj = xj + sum(FMValues{i, j});
    end
    mean_x_j_(1, j) = xj / (r * c);
end

for j = 1 : s
    for i = 1 : r
        mean_xij_(i, j) = sum(FMValues{i, j})  / c;
    end
end

mean_x = sum(sum(mean_xij_)) / (r * s);

%% Calculating Sum of Square
for i = 1 : r
    SS_defocus = SS_defocus + s * c *(mean_xi__(i, 1) - mean_x)^2;
end

for j = 1 : s
    SS_content = SS_content + r * c *(mean_x_j_(1, j) - mean_x)^2;
end

for i = 1 : r
    for j = 1 : s
        SS_defocus_content = SS_defocus_content + c * (mean_xij_(i, j) - mean_xi__(i, 1) - mean_x_j_(1, j) + mean_x)^2;
    end
end

for i = 1 : r
    for j = 1 : s
        for k = 1 : c
            SS_error = SS_error + (FMValues{i, j}(1, k) - mean_xij_(i, j))^2;
        end 
    end
end

%% Calculating Mean Square

MS_defocus = SS_defocus / df_defocus;
MS_content = SS_content / df_content;
MS_defocus_content = SS_defocus_content / df_defocus_content;
MS_error = SS_error / df_error;

%% Calculating F-ratio
F_defocus = MS_defocus / MS_error;
F_content = MS_content / MS_error;

