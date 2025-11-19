% File: format_conversion_Suite2p_cellsonly.m
% Description: Adapted the conversion code that comes with CellReg to only
% include the "cells" and excludes the "not cells"
% Author: CellReg, adapted by Mikayla Voglewede
% Created: 11/17/25
% Last modified: 11/19/25

%% Converting the outputs from CNMF-e or Suite2p to the required input format for CellReg

input_format='Suite2p'; % could be either 'CNMF-e' or 'Suite2p'

%% Choosing the files for conversion:
[file_names,files_path]=uigetfile('*.mat','MultiSelect','on',...
    'Choose the spatial footprints from all the sessions: ' );

if iscell(file_names)
    number_of_sessions=size(file_names,2);
else
    number_of_sessions=1;
end

for n=1:number_of_sessions
    % load file
    if iscell(file_names)
        this_session_data=load([files_path file_names{n}]);
    else
        this_session_data=load([files_path file_names]);
    end

    %% ============ SUITE2P CASE ============
    if strcmp(input_format,'Suite2p')

        % image size
        this_session_x_size=this_session_data.ops.Lx+1;
        this_session_y_size=this_session_data.ops.Ly+1;
        
        % Determine which ROIs are neurons
        iscell_vec = this_session_data.iscell(:,1);   % Nx1 logical-ish vector
        neuron_inds = find(iscell_vec == 1);          % Indices of real neurons
        num_neurons = length(neuron_inds);

        % Preallocate footprint array ONLY for neurons
        this_session_converted_footprints = ...
            zeros(num_neurons, this_session_y_size, this_session_x_size);

         % Fill array only with neurons
        for ii = 1:num_neurons
            k = neuron_inds(ii);  % original Suite2p index

            % Insert the footprint for neuron k
            ypix = this_session_data.stat{k}.ypix + 1;
            xpix = this_session_data.stat{k}.xpix + 1;
            lam  = this_session_data.stat{k}.lam;

            for l = 1:length(ypix)
                this_session_converted_footprints(ii, ypix(l), xpix(l)) = lam(l);
            end
        end
    end

       
    % elseif strcmp(input_format','CNMF-e')
    %     this_session_y_size=this_session_data.neuron.options.d1;
    %     this_session_x_size=this_session_data.neuron.options.d2;
    %     this_session_num_cells=size(this_session_data.neuron.A,2);
    %     this_session_converted_footprints=zeros(this_session_num_cells,this_session_y_size,this_session_x_size);
    %     for k=1:this_session_num_cells
    %         this_session_converted_footprints(k,:,:)=reshape(this_session_data.neuron.A(:,k),this_session_y_size,this_session_x_size);
    %     end
    % end
    if iscell(file_names)
        save([files_path 'converted_cellsonly' file_names{n}],'this_session_converted_footprints','-v7.3')
    else
        save([files_path 'converted_cellsonly' file_names],'this_session_converted_footprints','-v7.3')
    end
end

