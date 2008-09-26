package edu.umass.eflux;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Collection;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.Vector;



public class GeneratorFactory {


	public static CodeGenerator getGenerator(String name)
	{
		//TODO:  Add code to return a Code Generator.
		if (name.equals("tinyos"))
		{
			return new TinyOSGenerator();
		}

		if (name.equals("tinyos2"))
		{
			return new TinyOS2Generator();
		}

		if (name.equals("mica2dot"))
		{
			return new Mica2DotGenerator();
		}

		if (name.equals("tinynode"))
		{
			return new TinyNodeGenerator();
		}

		if (name.equals("tinynode_2"))
		{
			return new TinyNodeT2Generator();
		}

		if (name.equals("stargate"))
		{
			return new StargateGenerator();
		}

		if (name.equals("simulator"))
		{
			return new SimulatorGenerator();
		}

		if (name.equals("linuxsim"))
		{
			return new LinuxSimGenerator();
		}

		return null;
	}

}