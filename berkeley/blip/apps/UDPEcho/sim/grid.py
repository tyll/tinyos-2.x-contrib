
nnodes = 81
size = 9

basenodeid = 10

def idFromIdx(n):
    if n == 0: return 100
    else: return n + basenodeid

for i in range(0,nnodes):
    for j in range(0,nnodes):
        x1 = i % size
        x2 = j % size
        y1 = int(i / size)
        y2 = int(j / size)
        #print "(%i, %i) and (%i, %i)" % (x1, y1, x2, y2)
        if i == j: continue
        if (abs(x1 - x2) <= 1 and abs(y1 - y2) <= 1): gain = -85.5
        elif (abs(x1 - x2) <= 2 and abs(y1 - y2) <= 2): gain = -120
        else: continue
        n1 = idFromIdx(i)
        n2 = idFromIdx(j)
        print "gain\t%i\t%i\t%f" %(n1, n2, gain)
        
