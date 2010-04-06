% SenZip reconstruction
% author: Sundeep Pattem, ANRG, USC

% currently works for DPCM transform, Fixed quantization of coefficients 

% assumptions: 
% num nodes remains constant
% node ids are in sequence,
% node 0 is the sink 

clear;

% topology related constants
NUM_NODES = 4;
SINK_ID = 0;

% packet related constants
NUM_MEASUREMENTS = 3;
BIT_WIDTH = 16;
PARENT_POS = 3;
MIN_POS = 5;
MAX_POS = 6;
DATA_POS = 7;

% quantization parameters
BIT_ALLOCATION = 5;

% sensor related constants
NORMAL_CONST = 3/1024;

% plotting range constants
HIGH_VAL = 25;
LOW_VAL = 15;

%initializations
parent = zeros(1,NUM_NODES);
numLines = zeros(1,NUM_NODES);  % number of data items read for each node
numCoeffs = zeros(1,NUM_NODES); % number of coefficients currently reconstructed
done = 0;
minDec = 0;

% begin processing
while (~done)
    for nodeId = 1:NUM_NODES
        % raw data
        file = sprintf('C:/cygwin/opt/tinyos-2.x_SenZip/trunk/apps/SenZipApp/raw_data_%d.txt', nodeId);
        x = dlmread(file);
        numRawLines(nodeId) = length(x);
        rawData(1:length(x),nodeId) = x(:,DATA_POS);
        numRawPackets(numLines(nodeId)+1:numLines(nodeId)+NUM_MEASUREMENTS, nodeId) = length(x)/NUM_MEASUREMENTS;
        
        % detect new compressed packets and decode
        file = sprintf('C:/cygwin/opt/tinyos-2.x_SenZip/trunk/apps/SenZipApp/coeff_data_%d.txt', nodeId);
        x = dlmread(file);
        while (numLines(nodeId) < length(x(:,1)))
            parent = x(numLines(nodeId) + 1,PARENT_POS);
            if (parent == SINK_ID) % data from nodes one hop to sink not compressed
                reconData(numCoeffs(nodeId)+1:numCoeffs(nodeId)+NUM_MEASUREMENTS,nodeId) = x(numLines(nodeId)+1:numLines(nodeId)+NUM_MEASUREMENTS,DATA_POS);
                parentInfo(numCoeffs(nodeId)+1:numCoeffs(nodeId)+NUM_MEASUREMENTS,nodeId) = SINK_ID;
                numCoeffs(nodeId) = numCoeffs(nodeId)+NUM_MEASUREMENTS;
                if (numLines(nodeId) == 0)
                    numCompPackets(1:NUM_MEASUREMENTS, nodeId) = 1;
                else
                    numCompPackets(numLines(nodeId)+1:numLines(nodeId)+NUM_MEASUREMENTS, nodeId) = numCompPackets(numLines(nodeId), nodeId) + 1;
                end
            else % compressed data from nodes two hops or more from sink
                decodedSeq = zeros(1,floor(BIT_WIDTH/BIT_ALLOCATION)*NUM_MEASUREMENTS);
                decodedSeq = FQDecode(x(numLines(nodeId)+1:numLines(nodeId)+NUM_MEASUREMENTS, DATA_POS), BIT_WIDTH, BIT_ALLOCATION, x(numLines(nodeId)+1, MIN_POS), x(numLines(nodeId)+1, MAX_POS));
                for j = 1:length(decodedSeq)
                    reconData(numCoeffs(nodeId)+j, nodeId) = decodedSeq(j);
                    parentInfo(numCoeffs(nodeId)+j, nodeId) = x(numLines(nodeId)+1,PARENT_POS);
                end
                if (numCoeffs(nodeId) == 0)
                    numCompPackets(1:length(decodedSeq), nodeId) = 1;
                else
                    numCompPackets(numCoeffs(nodeId):numCoeffs(nodeId)+length(decodedSeq), nodeId) = numCompPackets(numCoeffs(nodeId), nodeId) + 1;
                end
                numCoeffs(nodeId) = numCoeffs(nodeId) + length(decodedSeq);
            end
            numLines(nodeId) = numLines(nodeId) + NUM_MEASUREMENTS;
        end
    end

    % reconstruct tree for each measurement and invert transform
    % parents in tree need to be reconstructed before children
    % sorting according to hop size for this reason
    while (minDec < min(numCoeffs(1:NUM_NODES)))
        minDec = minDec + 1;
        hopInfo = zeros(NUM_NODES,1);
        hopInfo = TreeReconstruct(parentInfo(minDec, :), SINK_ID, hopInfo, 0);
        [sortedHop sortedIndex] = sort(hopInfo);
        for idx = 1:NUM_NODES
            if (sortedHop(idx) > 1)
                % for DPCM add coefficient to parent measurement
                reconData(minDec, sortedIndex(idx)) = reconData(minDec, sortedIndex(idx)) + reconData(minDec, parentInfo(minDec, sortedIndex(idx)));
            end
            if (minDec > 1)
                % indicate change of parent in plot
                if (parentInfo(minDec, sortedIndex(idx)) ~= parentInfo(minDec-1, sortedIndex(idx)))
                    hold on;
                    subplot(2, NUM_NODES/2, sortedIndex(idx))
                    plot(minDec, reconData(minDec, sortedIndex(idx))*NORMAL_CONST, 'rs');
                end
            end
        end
    end


    pause(1);

    %plots
    for id = 1:NUM_NODES
        subplot(2, NUM_NODES/2, id)
        hold on
        axis([0 length(reconData) LOW_VAL HIGH_VAL]);
        if (numRawLines(id) > 0)
            plot(rawData(1:numRawLines(id),id)*NORMAL_CONST, 'r', 'LineWidth', 2);
        end
        if (numLines(id) > 0)
            plot(reconData(1:minDec,id)*NORMAL_CONST, 'b', 'LineWidth', 2);
        end
    end   
end

