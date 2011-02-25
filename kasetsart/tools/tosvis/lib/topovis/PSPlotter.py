from common import *
from TopoVis import GenericPlotter

PS_PROLOG = """\
%%!PS-Adobe-3.0
%%%%Creator: TopoVis
%%%%BoundingBox: %d %d %d %d
%%%%LanguageLevel: 2
%%%%DocumentData: Clean7Bit

%%%%Pages: (atend)

/Bg {
    %d %d moveto
    %d %d lineto
    %d %d lineto
    %d %d lineto
    fill
} bind def

/Node {
    /isdouble exch def
    /thickness exch def
    isdouble {
        3 copy
        gsave
         newpath
         thickness setlinewidth
         0 360 arc stroke
        grestore
    } if
    3 copy
    newpath
    isdouble { 0.8 mul } if 
    0 360 arc fill
    3 1 roll moveto
    dup rlineto show
} bind def

/HNode {
    /isdouble exch def
    /thickness exch def
    isdouble {
        3 copy
        gsave
         newpath
         thickness setlinewidth
         0 360 arc stroke
        grestore
    } if
    3 copy
    newpath
    gsave
     isdouble
      { 0.8 mul }
      { thickness setlinewidth }
     ifelse
     0 360 arc
     gsave
      1 1 1 setrgbcolor
      stroke
     grestore
     stroke
    grestore
    pop moveto
    dup stringwidth
    pop 2 div neg %.3f
    rmoveto show
} bind def

/Line { newpath moveto lineto stroke } bind def

/AHL { -12 currentlinewidth 1 add 2 div mul } def
/AHW { 4 currentlinewidth 1 add 2 div mul } def
/AHT { AHW -2 mul } def
/ArrowHead {
  4 copy
  gsave newpath 2 copy moveto 2 index sub exch
  3 index sub atan rotate pop pop
  AHL AHW rlineto 0 AHT rlineto closepath fill
  grestore } bind def
/ArrowTail { 4 2 roll ArrowHead 4 2 roll } bind def

"""

PS_PAGE_PROLOG = """\
%%%%Page: %d %d
%d %d translate
%.2f %.2f scale
%.2f %.2f %.2f setrgbcolor Bg
"""

PS_SETFONT = """\
/Times-Roman findfont
%d scalefont setfont
"""

PS_GRIDDEF = """\
/Grid {
  %.2f %.2f %.2f setrgbcolor 0.1 setlinewidth
  0 %.2f %.2f { 0 moveto 0 %.2f rlineto } for
  0 %.2f %.2f { 0 exch moveto %.2f 0 rlineto } for
  stroke
} bind def
"""

PS_LINESTYLE = """\
/LS%d { %.2f %.2f %.2f setrgbcolor %.2f setlinewidth [%s] 0 setdash } bind def
"""

PS_EPILOG = """\
%%%%Trailer
%%%%Pages: %d
"""

###############################################
class Plotter(GenericPlotter):
    def __init__(self, stream, params):
        GenericPlotter.__init__(self, params)
        self.stream = stream
        self.params = params
        self.page_count = 0

    ###################
    def printPSProlog(self):
        p = self.params
        (tx,ty) = self.scene.dim
        llx = p.margin - p.scale*p.guard;
        lly = p.margin - p.scale*p.guard;
        urx = p.margin + p.scale*(tx+p.guard);
        ury = p.margin + p.scale*(ty+p.guard);
        vert_just = p.textsize/3.0
        print >> self.stream, PS_PROLOG % (
                llx, lly, urx, ury,
                -p.guard, -p.guard,
                -p.guard, ty+p.guard,
                tx+p.guard, tx+p.guard,
                tx+p.guard, -p.guard,
                -vert_just)

        if (p.grid > 0):
            print >> self.stream, PS_GRIDDEF % (
                    p.gridcolor[0], p.gridcolor[1], p.gridcolor[2],
                    p.grid, tx, ty,
                    p.grid, ty, tx)

        print >> self.stream, PS_SETFONT % p.textsize

    ###################
    def printPageProlog(self, page):
        p = self.params
        print >> self.stream
        print >> self.stream, PS_PAGE_PROLOG % (
                page, page,
                p.margin, p.margin,
                p.scale, p.scale,
                p.bgcolor[0], p.bgcolor[1], p.bgcolor[2])

    ###################
    def printPSEpilog(self, num_pages):
        print >> self.stream
        print >> self.stream, PS_EPILOG % num_pages

    ###################
    def startPage(self, time):
        self.page_count += 1
        self.current_time = time
        self.printPageProlog(self.page_count)
        self.last_node_color = None

    ###################
    def finishPage(self):
        print >> self.stream
        print >> self.stream, "0 0 0 setrgbcolor 0 0 moveto"
        print >> self.stream, "(Page %d: Time = %.3f sec) show" % (
                self.page_count, self.current_time
                )
        print >> self.stream, "showpage"

    ###################
    def close(self):
        self.printPSEpilog(self.page_count)

    ###################
    def drawGrid(self):
        print >> self.stream, "Grid"

    ###################
    def createLineStyle(self, id, style):
        print >> self.stream, PS_LINESTYLE % (
                id, style.color[0], style.color[1], style.color[2],
                style.width, ' '.join(str(x) for x in style.dash)
                )

    ###################
    def drawLink(self, src, dst, style):
        p = self.params
        lineStyle = self.scene.lineStyles[style]

        # shorten the line by the radius of the node to prevent
        # parts of the line from being covered by the node
        endpoints = computeLinkEndPoints(src, dst, p.nodesize)

        # both nodes are on the same location, link not visible
        if endpoints == None: return

        (sx, sy, dx, dy) = endpoints

        # draw nothing if the line is not visible after shortened
        if abs(dx-sx) < 0.01 and abs(dy-sy) < 0.01: return

        if lineStyle.arrow == 'both':
            arrow = "ArrowHead ArrowTail"
        elif lineStyle.arrow == 'head':
            arrow = "ArrowHead"
        elif lineStyle.arrow == 'tail':
            arrow = "ArrowTail"
        else:
            arrow = ""

        print >> self.stream, "LS%d %7.2f %7.2f %7.2f %7.2f %s Line" % (
              style, sx, sy, dx, dy, arrow
              )

    ###################
    def drawNode(self, node):
        p = self.params

        # resolve node's 'hollow' setting
        if (node.hollow == DEFAULT and p.hollow) or (node.hollow == ENABLED):
            drawCmd = "HNode"
        else:
            drawCmd = "Node"

        # resolve node's 'double' setting
        if (node.double == DEFAULT and p.double) or (node.double == ENABLED):
            double = "true"
        else:
            double = "false"

        # resolve node's 'width' setting
        if node.width == DEFAULT:
            width = p.nodewidth
        else:
            width = node.width

        # resolve node's 'color' setting
        if node.color == DEFAULT:
            color = p.nodecolor
        else:
            color = node.color

        # reset line width before the first node is drawn
        if self.last_node_color == None:
            print >> self.stream, "0 setlinewidth"

        # suppress node color setting if the same was used last time
        if self.last_node_color != color:
            print >> self.stream, "%.2f %.2f %.2f setrgbcolor" % (
                    color[0], color[1], color[2]
                    )
            self.last_node_color = node.color

        print >> self.stream, "%5s %7.2f %7.2f %7.2f %.2f %s %s" % (
                '(' + node.label + ')', node.pos[0], node.pos[1],
                node.scale*p.nodesize, width, double, drawCmd
                )

    ###################
    def init(self,tx,ty):
        self.printPSProlog()

    ###################
    def show(self):
        self.startPage(self.scene.time)

        if self.params.grid > 0:
            self.drawGrid()

        for (src,dst,type) in self.scene.links:
            self.drawLink(self.scene.nodes[src], self.scene.nodes[dst], type)

        for n in self.scene.nodes.values():
            self.drawNode(n)

        self.finishPage()

    ###################
    def linestyle(self,id,**kwargs):
        self.createLineStyle(id, self.scene.lineStyles[id])

