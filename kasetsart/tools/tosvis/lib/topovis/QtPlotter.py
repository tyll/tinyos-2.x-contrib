from common import *
from PyQt4 import QtCore,QtGui
from TopoVis import GenericPlotter, LineStyle, FillStyle
from math import sin,cos,acos,pi

Pi = pi
TwoPi = Pi*2.0

###################
def makeQtColor(color):
    colTuple = (0,0,0)
    if color:
        colTuple = (int(255*x) for x in color)
    return QtGui.QColor(*colTuple)

###############################################
class QtScene(QtGui.QGraphicsScene):
    def invokeGui(self,func,args,kwargs):
        func(*args,**kwargs)

###############################################
class Plotter(GenericPlotter,QtCore.QObject):

    ###################
    def __init__(self, params=None):
        GenericPlotter.__init__(self, params)
        QtCore.QObject.__init__(self)
        self.nodes = {}
        self.links = {}
        self.nodeLinks = {}
        self.lineStyles = {}
        self.shapes = {}

        # each entry stores (node's pen, node's brush, label's pen)
        self.nodePens = {}

        self.qtScene = QtScene(0,0,500,500)
        self.qtScene.connect(self, QtCore.SIGNAL('invokeGui'),
                self.qtScene.invokeGui)

    ###################
    def invokeGui(self, func, *args, **kwargs):
        self.emit(QtCore.SIGNAL('invokeGui'), func, args, kwargs)

    ###################
    def attachStyles(self,item,lineStyle=None,fillStyle=None):
        if lineStyle:
            pen = QtGui.QPen()
            pen.setColor(makeQtColor(lineStyle.color))
            pen.setWidth(lineStyle.width)
            #if lineStyle.dash:
            #    pen.setDashPattern(list(lineStyle.dash))
            self.invokeGui(item.setPen, pen)
        if fillStyle and fillStyle.color:
            brush = QtGui.QBrush()
            brush.setColor(makeQtColor(fillStyle.color))
            brush.setStyle(QtCore.Qt.SolidPattern)
            self.invokeGui(item.setBrush, brush)

    ###################
    def createLine(self,x1,y1,x2,y2,lineStyle,polygonItem=None):
        '''Create and return a polygon representing a line with optional arrow heads.
        Part of this code is taken from PyQt4's Elastic Nodes example.
        '''
        srcPoint = QtCore.QPointF(x1,y1)
        dstPoint = QtCore.QPointF(x2,y2)
        # prepare the line
        line = QtCore.QLineF(srcPoint, dstPoint)

        polygon = QtGui.QPolygonF([line.p1(), line.p2()])

        # Draw the arrows if there's enough room.
        angle = math.acos(line.dx() / line.length())
        if line.dy() >= 0:
            angle = TwoPi - angle

        arrowSize = 5.0 * lineStyle.width
        if lineStyle.arrow in ['tail', 'both']:
            srcArrowP1 = srcPoint + QtCore.QPointF(
                    sin(angle + Pi/3)*arrowSize, cos(angle + Pi/3)*arrowSize)
            srcArrowP2 = srcPoint + QtCore.QPointF(
                    sin(angle + Pi - Pi/3)*arrowSize, cos(angle + Pi - Pi/3)*arrowSize);   
            polygon.prepend(srcArrowP2)
            polygon.prepend(line.p1())
            polygon.prepend(srcArrowP1)
            polygon.prepend(line.p1())

        if lineStyle.arrow in ['head', 'both']:
            dstArrowP1 = dstPoint + QtCore.QPointF(
                    sin(angle - Pi/3)*arrowSize, cos(angle - Pi/3)*arrowSize)
            dstArrowP2 = dstPoint + QtCore.QPointF(
                    sin(angle - Pi + Pi/3)*arrowSize, cos(angle - Pi + Pi/3)*arrowSize)
            polygon.append(dstArrowP1)
            polygon.append(line.p2())
            polygon.append(dstArrowP2)
            polygon.append(line.p2())

        if polygonItem:
            self.invokeGui(polygonItem.setPolygon, polygon)
        else:
            polygonItem = QtGui.QGraphicsPolygonItem(polygon)
        return polygonItem

    ###################
    def createLink(self,src,dst,style):
        if src is dst:
            raise('Source and destination are the same node')
        params = self.params
        qt = self.qtScene
        (x1,y1,x2,y2) = computeLinkEndPoints(
                self.scene.nodes[src],
                self.scene.nodes[dst], 
                params.nodesize)
        lineStyle = self.scene.lineStyles[style]
        linkItem = self.createLine(x1, y1, x2, y2, lineStyle)
        self.attachStyles(linkItem, lineStyle)
        return linkItem

    ###################
    def updateNodePosAndSize(self,id,newLabel=None):
        params = self.params
        qt = self.qtScene
        if id not in self.nodes.keys():
            nodeItem = QtGui.QGraphicsEllipseItem(0,0,0,0)
            labelItem = QtGui.QGraphicsSimpleTextItem(str(id))
            self.nodePens[id] = (QtGui.QPen(), QtGui.QBrush(), QtGui.QPen())
            self.nodes[id] = (nodeItem,labelItem)
            self.invokeGui(qt.addItem, nodeItem)
            self.invokeGui(qt.addItem, labelItem)
        else:
            (nodeItem,labelItem) = self.nodes[id]

        node = self.scene.nodes[id]
        nodesize = node.scale*params.nodesize
        (nodePen,nodeBrush,labelPen) = self.nodePens[id]
        x1 = node.pos[0] - nodesize
        y1 = node.pos[1] - nodesize
        self.invokeGui(nodeItem.setRect,x1,y1,nodesize*2,nodesize*2)
        if newLabel:
            newLabelItem = QtGui.QGraphicsSimpleTextItem(newLabel)
            newLabelItem.setPen(labelPen)
            self.invokeGui(qt.removeItem, labelItem)
            self.invokeGui(qt.addItem, newLabelItem)
            labelItem = newLabelItem
            self.nodes[id] = (nodeItem, newLabelItem)
        (x,y,w,h) = labelItem.boundingRect().getRect()
        self.invokeGui(labelItem.setPos,
                node.pos[0]-w/2, node.pos[1]-h/2)

        for l in self.nodeLinks[id]:
            self.updateLink(*l)

    ###################
    def updateLink(self,src,dst,style):
        params = self.params
        qt = self.qtScene
        linkItem = self.links[(src,dst,style)]
        (x1,y1,x2,y2) = computeLinkEndPoints(
                self.scene.nodes[src],
                self.scene.nodes[dst], 
                params.nodesize)
        self.createLine(x1,y1,x2,y2,self.scene.lineStyles[style],linkItem)

    ###################
    def init(self,tx,ty):
        self.qtScene.setSceneRect(0,0,tx,ty)

    ###################
    def node(self,id,x,y):
        self.nodeLinks[id] = []
        self.updateNodePosAndSize(id)

    ###################
    def nodemove(self,id,x,y):
        self.updateNodePosAndSize(id)

    ###################
    def nodecolor(self,id,r,g,b):
        (nodeItem,labelItem) = self.nodes[id]
        (nodePen,nodeBrush,labelPen) = self.nodePens[id]
        color = makeQtColor((r,g,b))
        nodePen.setColor(color)
        labelPen.setColor(color)
        self.invokeGui(nodeItem.setPen, nodePen)
        self.invokeGui(labelItem.setPen, labelPen)

    ###################
    def nodewidth(self,id,width):
        (nodeItem,labelItem) = self.nodes[id]
        (nodePen,nodeBrush,labelPen) = self.nodePens[id]
        nodePen.setWidth(width)
        self.invokeGui(nodeItem.setPen, nodePen)

    ###################
    def nodescale(self,id,scale):
        # scale attribute has been set by TopoVis
        # just update the node
        self.updateNodePosAndSize(id)

    ###################
    def nodelabel(self,id,label):
        (nodeItem,labelItem) = self.nodes[id]
        self.updateNodePosAndSize(id,label)

    ###################
    def addlink(self,src,dst,style):
        qt = self.qtScene
        self.nodeLinks[src].append((src,dst,style))
        self.nodeLinks[dst].append((src,dst,style))
        link = self.createLink(src, dst, style)
        self.links[(src,dst,style)] = link
        self.invokeGui(qt.addItem,link)

    ###################
    def dellink(self,src,dst,style):
        self.nodeLinks[src].remove((src,dst,style))
        self.nodeLinks[dst].remove((src,dst,style))
        self.invokeGui(self.qtScene.removeItem, self.links[(src,dst,style)])
        del self.links[(src,dst,style)]

    ###################
    def clearlinks(self):
        for link in self.links.values():
            self.invokeGui(self.qtScene.removeItem, link)
        self.links.clear()
        for n in self.nodes.keys():
            self.nodeLinks[n] = []

    ###################
    def circle(self,x,y,r,id,linestyle,fillstyle):
        qt = self.qtScene
        if id in self.shapes.keys():
            self.invokeGui(qt.removeItem, self.shapes[id])
            del self.shapes[id]
        shape = QtGui.QGraphicsEllipseItem(x-r,y-r,2*r,2*r)
        self.shapes[id] = shape
        self.attachStyles(shape, linestyle, fillstyle)
        self.invokeGui(qt.addItem, shape)

    ###################
    def line(self,x1,y1,x2,y2,id,linestyle):
        qt = self.qtScene
        if id in self.shapes.keys():
            self.invokeGui(qt.removeItem, self.shapes[id])
            del self.shapes[id]
        shape = self.createLine(x1,y1,x2,y2,linestyle)
        self.shapes[id] = shape
        self.attachStyles(shape, linestyle)
        self.invokeGui(qt.addItem, shape)

    ###################
    def rect(self,x1,y1,x2,y2,id,linestyle,fillstyle):
        qt = self.qtScene
        if id in self.shapes.keys():
            self.invokeGui(qt.removeItem, self.shapes[id])
            del self.shapes[id]
        shape = QtGui.QGraphicsRectItem(x1,y1,x2-x1,y2-y1)
        self.shapes[id] = shape
        self.attachStyles(shape, linestyle, fillstyle)
        self.invokeGui(qt.addItem, shape)

    ###################
    def delshape(self,id):
        qt = self.qtScene
        if id in self.shapes.keys():
            self.invokeGui(qt.removeItem, self.shapes[id])
