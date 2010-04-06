% decoding fixed quantization
% author: Sundeep Pattem
% December 18, 2009

function decodedSeq = FQDecode(encodedSeq, bitWidth, bitAllocation, low, high)

numElems = length(encodedSeq);
quantizationFactor = (high-low+1)/(2^bitAllocation);
bitRatio = floor(bitWidth/bitAllocation);
remainder = 0;
offset = 0;
k = 1;
for i = 1:numElems
    offset = rem((i-1)*bitWidth, bitAllocation);
    if (offset == 0)
        remainder = 0;
    end
    if (encodedSeq(i) < 0)
        encodedSeq(i) = encodedSeq(i) + 2^bitWidth;
    end
    remainder = remainder*(2^bitWidth) + encodedSeq(i);
    j = 1;
    while ((k*bitAllocation <= i*bitWidth) & (k <= bitRatio*numElems))
        factor = 2^(bitWidth - bitAllocation*j + offset);
        decodedSeq(k) = floor(remainder/factor);
        remainder = remainder - factor*floor(remainder/factor);
        j = j + 1;
        k = k + 1;
    end
end
decodedSeq;
if ((high-low) >= 2^bitAllocation)
    decodedSeq = quantizationFactor*decodedSeq + low;
else
    decodedSeq = decodedSeq + low;
end


