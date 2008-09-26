package edu.umass.eflux.nesc;

import java.io.*;
import java.util.*;

import jdsl.graph.ref.*;
import jdsl.graph.api.*;

public class NESCGraph {

	private boolean recursive;
	Vector<NESCFile> m_nescfiles;
	Vector<NESCConfig> m_configs;
	Vector<NESCModule> m_modules;
	Vector<NESCInterface> m_ifaces;
	Vector<File> m_app_files;
	
	IncidenceListGraph graph;
	
	public NESCGraph(String directoryName, boolean recurse)
	{
		File f = new File(directoryName);
		recursive = recurse;
		
		if (!f.isDirectory())
		{
			//maybe throw something here
			throw new RuntimeException("Bad Filename!");
		}	
		m_nescfiles = loadNescFiles(f);
		
		
	}
	
	
	
	private Vector<NESCFile> loadNescFiles(File f)
	{
		System.out.println("Loading..."+f.getPath());
		Vector<NESCFile> nesc_f = new Vector<NESCFile>();
		
		File[] files = f.listFiles(new NescFileFilter());
		File[] dirs = f.listFiles(new DirectoryFilter());
		
		System.out.println("\tfiles..."+files);
		System.out.println("\tdirs..."+dirs);
		
		if (recursive && dirs != null)
		{
			for (int i=0; i < dirs.length; i++)
			{
				Vector<NESCFile> subfiles = loadNescFiles(dirs[i]);
				for (NESCFile nf : subfiles)
				{
					nesc_f.add(nf);
				}
			}	
		}
		
		for (int i=0; i < files.length; i++)
		{
			
			try
			{
				parser p;
				p = new nesc_parser(new Yylex(new FileInputStream(files[i])));
				
				NESCFile nf = silentParse(p, files[i]);
				
				
				if (nf != null)
				{
					nesc_f.add(nf);
				}
			}
			catch (Exception e)
			{
				e.printStackTrace();
			}
			
		}
		
		return nesc_f;
	}
	
	private NESCFile silentParse(parser p, File f)
	{
		PrintStream oldout = System.out;
		PrintStream olderr = System.err;
		Object ret = null;
		
		try
		{
			//System.setOut(new PrintStream(new ByteArrayOutputStream()));
			//System.setErr(new PrintStream(new ByteArrayOutputStream()));
			
			ret = p.parse().value;
			
			
		}
		catch (Exception e)
		{
			System.setErr(olderr);
			System.setOut(oldout);
			e.printStackTrace(oldout);
		}
		System.setErr(olderr);
		System.setOut(oldout);
		
		return new NESCFile(f,ret);
		
	}
	
	
	/**
	 * @param args
	 */
	public static void main(String[] args) 
	{
		NESCGraph graph = new NESCGraph(args[0], args[1].toLowerCase().equals("r"));
		
		for (NESCFile c : graph.m_nescfiles)
		{
			System.out.println(c.getPath()+"   :   "+c.getNescData());
			
		}
		
	}
}
