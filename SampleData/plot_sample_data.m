% file: plot_sample_data
% description: take one cell from the sample CellReg dataset and plot it to
% see what this data actually is
% Conclusion: in allFiltersMat, (NxMxK) N = neuron
% MxK makes a 2D matrix that 0 = no fluorescence and # = fluorescence for
% that cell, so it basically is a grid of the image
% Author: Mikayla Voglewede with some ChatGPT
% Date: 11-12-25

% select neuron #10
f=allFiltersMat(10,:,:)

% 3D to 2D
f2 = squeeze(f);


% plot it
f2 = rand(253, 326);  % Example data — replace with your actual f2
[row, col] = ndgrid(1:size(f2,1), 1:size(f2,2));

figure;
scatter(col(:), row(:), 10, f2(:), 'filled');
colorbar;
xlabel('Column');
ylabel('Row');
title('Scatter plot of f2 values');