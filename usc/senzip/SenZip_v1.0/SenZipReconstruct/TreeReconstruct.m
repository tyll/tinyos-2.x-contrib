% Tree reconstruction for SenZip compression
% author: Sundeep Pattem, ANRG, USC

function [hopInfo] = TreeReconstruct(parentInfo, I, hopInfo, hopCount)

for idx = 1:length(I)
    sI = find(parentInfo == I(idx));
    if (sI);
        hopInfo(sI) = hopCount + 1;
        hopInfo = TreeReconstruct(parentInfo, sI, hopInfo, hopCount + 1);
    end
end
