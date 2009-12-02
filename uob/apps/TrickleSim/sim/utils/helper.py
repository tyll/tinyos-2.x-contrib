
def id2xy(id, nodes):
    x = (id-1)/nodes
    y = (id-1)%nodes
    return (x, y)

def xy2id(x, y, nodes):
    return x*nodes + y +1

class Time:
    def __init__(self, h, m, s):
        self.h = int(h)
        self.m = int(m)
        self.s = float(s)

    def in_second(self):
        return ((24*self.h)+60*self.m) + self.s

    def __str__(self):
        return ""
