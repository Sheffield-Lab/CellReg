% File: count_neurons_per_session
% Description: uses the CellReg output file cell_registered_struct
% and loops through to count and plot how many cells in each session
% Author: Mikayla Voglewede (with some ChatGPT help)
% Created: 11-17-25
% Last modified: 11-17-25

% loop through cell_registered_struct.cell_to_index_map and determine how
% many cells are in each session
% cell_registered_struct needs to already be open
data = cell_registered_struct.cell_to_index_map;

% session presence
present = data ~= 0;         
nSessions = size(present,2);

combLabels = {};     % text labels for plotting
combCounts = [];     % numeric counts

fprintf('\n===== Neuron Counts for All Session Combinations =====\n\n');

for k = 1:nSessions
    combs = nchoosek(1:nSessions, k);

    for c = 1:size(combs,1)
        cols = combs(c,:);

        % present in these sessions
        in_these = all(present(:, cols), 2);

        % absent in other sessions
        otherSessions = setdiff(1:nSessions, cols);
        not_other = ~any(present(:, otherSessions), 2);

        % count
        count_exact = sum(in_these & not_other);

        % store for plotting
        combLabels{end+1} = mat2str(cols);
        combCounts(end+1) = count_exact;

        % print
        fprintf('Sessions %s only: %d neurons\n', mat2str(cols), count_exact);
    end
end

fprintf('\n======================================================\n');

%% ===== PLOT THE RESULTS =====

figure;
bar(combCounts);
xticks(1:length(combLabels));
xticklabels(combLabels);
xtickangle(45);            % rotate labels so they fit
ylabel('Number of Neurons');
title('Neuron Counts for All Session Combinations');
grid on;
fprintf('\n======================================================\n');