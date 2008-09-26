package edu.umass.eflux;


//import java.io.*;
//import java.util.*;
//import jdsl.graph.ref.IncidenceListGraph;
//import jdsl.graph.api.*;

public class GraphNode
{
        final static public int WHITE = 0;
        final static public int GREY = 1;
        final static public int BLACK = 2;
        
        final static public int DEFAULT = 0;
        final static public int ENTRY = 1;
        final static public int ERROR = 2;
        final static public int ERROR_HANDLER = 3;
        final static public int EXIT = 4;

        private int nodeColor = WHITE;
        private int numPaths = 0;
        
        private int nodeType;	
        
        private Object element; 
        
        public GraphNode(Object e, int nodeType)
        {
            this.element = e;
            this.numPaths = 0;
            if ((nodeType == DEFAULT) 
            		|| (nodeType == ENTRY) 
            		|| (nodeType == ERROR) 
            		|| (nodeType == ERROR_HANDLER)
            		|| (nodeType == EXIT))
                this.nodeType = nodeType;
            else
            {
                System.out.println("Error: " + nodeType + " is not a valid Node Type");
                System.exit(1);
            }
        }
    
        public String toString()
        {
            if (this.nodeType == ENTRY)
                return "ENTRY";
            if (this.nodeType == ERROR)
                return "ERROR";
            if (this.nodeType == EXIT)
                return "EXIT";
            if (this.nodeType ==  ERROR_HANDLER)
            	return ((ErrorHandler)element).getFunction();
            if (this.element instanceof Source)
                return ((Source)this.element).getSourceFunction();
            if (this.element instanceof TaskDeclaration)    
                return ((TaskDeclaration)this.element).getName();
            else 
                return "e is null";
        }

        
    public int getNodeColor()
    {
        return this.nodeColor;
    }

    public int getNumPaths()
    {
    	return this.numPaths;
    }
    
    public void setNumPaths(int num)
    {
    	this.numPaths = num;
    }
    
    public void setNodeColor(int nodeColor)
    {
        if ((nodeColor == GraphNode.WHITE)||(nodeColor == GraphNode.GREY)||(nodeColor == GraphNode.BLACK))
        {
            this.nodeColor = nodeColor;
        }
        else
        {
            System.out.println("Error: " + nodeColor + " is not a valid Node Color");
            System.exit(1);
        }
            
    }        
        
        public int getNodeType()
        {
                return this.nodeType;
        }

        
        public Object getElement()
        {
                return element;
        }
}
