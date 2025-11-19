% File: cell_to_index_map_corrected_for_is_cell.m
% Description: This takes the Fall.m files and the CellReg output file
% cell_registered_struct and creates a new variable
% cell_to_index_map_corrected that converts the suite2p ROI ID to the cell
% ROI that is used in our preprocessing pipeline
% Author: Mikayla Voglewede
% Created: 11/18/25
% Last modified: 11/19/25

%% Ask user for things

% enter number of recording days
nDays = input('Enter number of recording days: ');

% Get Fall.m file paths
fallPaths = cell(nDays, 1);
for j = 1:nDays
    % create title string with each day number
    titleStr = sprintf('Select Day %d Fall.mat file', j);

    % select & load Fall paths
    [Fall_file, Fall_path]=uigetfile('*.mat', titleStr);
    cd(Fall_path)
    fallPaths{j} = Fall_file;

end

% select & load cell_registered_struct file
[cellreg_file, cellreg_path]=uigetfile('*.mat', 'Select cell_registered_struct.mat file');
cd(cellreg_path)
load(cellreg_file);

%% --- Load CellReg output and check size ---
cellMap = cell_registered_struct.cell_to_index_map;   % rows = registered cells, cols = days

% find shape of cellMap and make sure it matches the number of days
[rows, cols] = size(cellMap)

% determine if cols = nDays
if cols == nDays
    disp('cell_registered_struct columns and number of recording days match')
end

% if it doesn't match then break the program
if cols ~= nDays
    error('Number of columns in cell_registered_struct does not match the number of recording days.');
    
end


%% Convert cell_to_index_map

% Initialize the corrected cell-to-index map
cell_to_index_map_corrected = zeros(rows, nDays);

% go through each recording day
for d = 1:nDays

    % load each Fall.mat file iscell variable
    current_iscell = load(fallPaths{d}, 'iscell'); 
    iscell=current_iscell.iscell;

    % Match indexing of cell_to_index_map and iscell
    % exclude the second column of iscell (probability that it's a cell)
    iscell_index = iscell(:,1);      
    % cumulative count of 1's
    idx = cumsum(iscell_index);      
    % set index to 0 where iscell is 0
    idx(~iscell_index) = 0; 
    
    % Fill in corrected mapping for each registered cell
    for i = 1:rows
        roi = cellMap(i, d);  % Suite2p ROI index from CellReg
        if roi > 0
            cell_to_index_map_corrected(i, d) = idx(roi);
        else
            cell_to_index_map_corrected(i, d) = 0;
        end
    end

   
end

%% --- save output ---
save('cell_to_index_map_corrected.mat', 'cell_to_index_map_corrected');

disp('Done. Corrected cell map created.');
