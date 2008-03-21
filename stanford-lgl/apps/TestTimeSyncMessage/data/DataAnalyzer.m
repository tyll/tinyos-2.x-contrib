function DataAnalyzer(file)
%file = 'data.report';
%sender_id = 7;

data = load(file);
data1 = sortrows(sortrows(sortrows(data,1),3),2);

row=1;

while (row <= size(data1,1))
    sender_id=data1(row,2)
    minrow=row;
    while (row <= size(data1,1) && data1(row,2)==sender_id)
        row = row + 1;
    end
    maxrow = row-1;

    if (minrow >= maxrow)
        return;
    end

    row=minrow;
    newrow = 1;
    newdata = zeros(10000,5);
    while (row <= (maxrow-1))
        if (data1(row,3) == data1(row+1,3))
            newdata(newrow,1)=data1(row,3);
            newdata(newrow,2)=data1(row,4)-data1(row+1,4);
            if (newrow==1)
                newdata(newrow,3)=0;
            else
                newdata(newrow,3)=newdata(newrow,2)-newdata(newrow-1,2);
            end
            newdata(newrow,4)=data1(row,4);
            newdata(newrow,5)=data1(row+1,4);

            newrow = newrow+1;
            row=row+1;
        end
        row=row+1;
    end
    newsize=newrow-1;
    
    figure();
    plot(newdata(1:newsize,1),newdata(1:newsize,3));
    title(sprintf('TimeStampingErrors for sender %d',sender_id));
    disp(sprintf('data size %d (all %d)',newsize,maxrow-minrow));
    disp(sprintf('avg %0.3f',mean(newdata(1:newsize,3))));
    disp(sprintf('abs avg %0.3f',mean(abs(newdata(1:newsize,3)))));
    disp(sprintf('max %d',max(abs(newdata(1:newsize,3)))));

    while (row <= size(data1,1) && data1(row,2)==sender_id)
        row = row + 1;
    end
end
savedata=newdata(1:newsize,:);
save data.out savedata -ASCII;