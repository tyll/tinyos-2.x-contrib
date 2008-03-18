function FTSPDataAnalyzer(file, varargin)
%file = '1205543689171.report';
min_seq = 0;
if (size(varargin,2)==1)
    min_seq = varargin{1};
end

data = load(file);
data1 = sortrows(sortrows(data,1),2);
newdata = zeros(1000,5);

row1=1;
while (row1 <= size(data1,1) && data1(row1,2)<min_seq)
row1=row1+1;
end

newrow=1;
unsynced=0;
while (row1<=size(data1,1))

    seqnum=data1(row1,2);

    data2=zeros(50,1);
    row2=1;
    tmprow1=row1;
    while (row1 <= size(data1,1) && data1(row1,2)==seqnum)
        if (data1(row1,5)==0)
            data2(row2,1)=data1(row1,3);
            row2= row2+ 1;
        else
            unsynced=unsynced+1;
        end
        row1 = row1 + 1;
    end
    
    if (row2>1)
        row2size=row2-1;
        rcvdsize=row1-tmprow1;
        newdata(newrow,1) = seqnum;
        newdata(newrow,2) = mad(data2(1:row2size,1));
        newdata(newrow,3) = mean(data2(1:row2size,1));
        newdata(newrow,4) = row2size;
        newdata(newrow,5) = rcvdsize;
        newrow = newrow + 1;
    end
end

newsize=newrow-1;
subplot(3,1,1);
plot(newdata(1:newsize,1),newdata(1:newsize,2));
title(sprintf('TimeSync Errors'));
subplot(3,1,2);
plot(newdata(1:newsize,1),newdata(1:newsize,3));
title(sprintf('Avg Glob Time'));
subplot(3,1,3);
plot(newdata(1:newsize,1),newdata(1:newsize,5),'r-',newdata(1:newsize,1),newdata(1:newsize,4),'b-');
title(sprintf('Num Synced Motes/Num Rcvd Motes'));

disp(sprintf('total unsycned num %d (all %d)',unsynced,newsize));
disp(sprintf('avg %0.3f',mean(newdata(1:newsize,2))));
disp(sprintf('max %d',max(newdata(1:newsize,2))));
savedata = newdata(1:newsize,:);

save data.out savedata -ASCII;