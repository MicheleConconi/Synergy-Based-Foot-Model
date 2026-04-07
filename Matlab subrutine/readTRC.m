function trc = readTRC(fileName)
    % readTRC Reads a TRC file replicating OpenSim's TRCFileAdapter logic.
    %
    % INPUT:
    %   fileName - String or char array of the TRC file path.
    %
    % OUTPUT:
    %   trc - Struct containing:
    %       .MetaData    : Struct of metadata key-value pairs
    %       .MarkerNames : Cell array of original marker names
    %       .Time        : Nx1 array of time frames
    %       .Data        : Struct where each field is a valid marker name 
    %                      containing an Nx3 array of XYZ coordinates.
    
    if nargin < 1 || isempty(fileName)
        error('OpenSim:EmptyFileName', 'File name cannot be empty.');
    end
    
    fid = fopen(fileName, 'r');
    if fid == -1
        error('OpenSim:FileDoesNotExist', 'File does not exist: %s', fileName);
    end
    
    % Ensure file is closed if an error occurs
    cleaner = onCleanup(@() fclose(fid));
    
    %% 1. Read Header
    headerLine = fgetl(fid);
    if ~ischar(headerLine)
        error('OpenSim:FileIsEmpty', 'File is empty: %s', fileName);
    end
    
    % Tokenize header using ' \t\r'
    headerTokens = strsplit(headerLine, {' ', sprintf('\t'), sprintf('\r')});
    headerTokens = headerTokens(~cellfun('isempty', headerTokens)); 
    
    if isempty(headerTokens) || ~strcmp(headerTokens{1}, 'PathFileType')
        error('OpenSim:MissingHeader', 'PathFileType missing in header.');
    end
    trc.MetaData.header = headerLine;
    
    %% 2. Read Metadata Keys
    expectedKeys = {'DataRate', 'CameraRate', 'NumFrames', 'NumMarkers', ...
                    'Units', 'OrigDataRate', 'OrigDataStartFrame', 'OrigNumFrames'};
    
    keysLine = fgetl(fid);
    keysLine = regexprep(keysLine, '\r$', '');
    keys = strsplit(keysLine, sprintf('\t'));
    keys = keys(~cellfun('isempty', keys)); 
    
    if length(keys) ~= length(expectedKeys)
        error('OpenSim:IncorrectNumMetaDataKeys', ...
              'Expected %d metadata keys, found %d.', length(expectedKeys), length(keys));
    end
    
    for i = 1:length(keys)
        if ~strcmp(keys{i}, expectedKeys{i})
            error('OpenSim:UnexpectedMetaDataKey', ...
                  'Expected %s, found %s.', expectedKeys{i}, keys{i});
        end
    end
    
    %% 3. Read Metadata Values
    valsLine = fgetl(fid);
    valsLine = regexprep(valsLine, '\r$', '');
    values = strsplit(valsLine, sprintf('\t'));
    values = values(~cellfun('isempty', values)); 
    
    if length(keys) ~= length(values)
        error('OpenSim:MetaDataLengthMismatch', ...
              'Metadata keys length (%d) does not match values length (%d).', length(keys), length(values));
    end
    
    for i = 1:length(keys)
        trc.MetaData.(keys{i}) = values{i};
    end
    
    num_markers_expected = str2double(trc.MetaData.NumMarkers);
    
    %% 4. Read Column Labels
    colLine = fgetl(fid);
    colLine = regexprep(colLine, '\r$', '');
    column_labels = strsplit(colLine, sprintf('\t'));
    column_labels = column_labels(~cellfun('isempty', column_labels)); 
    
    if length(column_labels) ~= num_markers_expected + 2
        error('OpenSim:IncorrectNumColumnLabels', ...
              'Expected %d column labels, found %d.', num_markers_expected + 2, length(column_labels));
    end
    
    if ~strcmp(column_labels{1}, 'Frame#')
        error('OpenSim:UnexpectedColumnLabel', 'Expected Frame#, found %s.', column_labels{1});
    end
    
    if ~strcmp(column_labels{2}, 'Time')
        error('OpenSim:UnexpectedColumnLabel', 'Expected Time, found %s.', column_labels{2});
    end
    
    trc.MarkerNames = column_labels(3:end);
    
    %% 5. Read XYZ Labels
    xyzLine = fgetl(fid);
    xyzLine = regexprep(xyzLine, '\r$', '');
    xyz_labels_found = strsplit(xyzLine, sprintf('\t'));
    xyz_labels_found = xyz_labels_found(~cellfun('isempty', xyz_labels_found)); 
    
    xyzIdx = 1;
    axes = {'X', 'Y', 'Z'};
    for i = 1:num_markers_expected
        for j = 1:3
            expectedLabel = sprintf('%s%d', axes{j}, i);
            if ~strcmp(xyz_labels_found{xyzIdx}, expectedLabel)
                error('OpenSim:UnexpectedColumnLabel', ...
                      'Expected %s, found %s.', expectedLabel, xyz_labels_found{xyzIdx});
            end
            xyzIdx = xyzIdx + 1;
        end
    end
    
    %% 6. Read Data Rows
    expectedFrames = str2double(trc.MetaData.NumFrames);
    if isnan(expectedFrames) || expectedFrames < 1
        expectedFrames = 1024;
    end
    
    Time = zeros(expectedFrames, 1);
    DataArray = NaN(expectedFrames, 3, num_markers_expected);
    
    expectedTokens = num_markers_expected * 3 + 2;
    rowNumber = 0;
    
    while ~feof(fid)
        line = fgetl(fid);
        if ~ischar(line), break; end
        
        line = regexprep(line, '\r$', '');
        tokens = strsplit(line, sprintf('\t'), 'CollapseDelimiters', false);
        
        if rowNumber == 0 && (isempty(line) || isempty(tokens{1}))
            continue;
        end
        
        if isempty(line) || (length(tokens) == 1 && isempty(tokens{1}))
            break; 
        end
        
        if length(tokens) == expectedTokens + 1 && isempty(tokens{end})
            tokens(end) = [];
        end
        
        if length(tokens) ~= expectedTokens
            error('OpenSim:RowLengthMismatch', ...
                  'Expected %d elements in row, found %d.', expectedTokens, length(tokens));
        end
        
        rowNumber = rowNumber + 1;
        
        if rowNumber > length(Time)
            Time = [Time; zeros(expectedFrames, 1)]; %#ok<AGROW>
            DataArray = cat(1, DataArray, NaN(expectedFrames, 3, num_markers_expected));
        end
        
        Time(rowNumber) = str2double(tokens{2});
        
        mIdx = 1;
        for c = 3 : 3 : expectedTokens
            x_str = tokens{c};
            y_str = tokens{c+1};
            z_str = tokens{c+2};
            
            % Insert data only if X, Y, and Z are all present
            if ~(isempty(x_str) || isempty(y_str) || isempty(z_str))
                DataArray(rowNumber, 1, mIdx) = str2double(x_str);
                DataArray(rowNumber, 2, mIdx) = str2double(y_str);
                DataArray(rowNumber, 3, mIdx) = str2double(z_str);
            end
            mIdx = mIdx + 1;
        end
    end
    
    %% 7. Finalize and Trim to Struct
    trc.Time = Time(1:rowNumber);
    trc.Data = struct();
    
    % Trim the preallocated array to actual rows read
    DataArray = DataArray(1:rowNumber, :, :);
    
    % Distribute 3D array into distinct Nx3 fields named after each marker
    for i = 1:num_markers_expected
        % Ensure the name is a valid MATLAB struct field name
        safeFieldName = matlab.lang.makeValidName(trc.MarkerNames{i});
        trc.Data.(safeFieldName) = DataArray(:, :, i);
    end

end