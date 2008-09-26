package edu.umass.eflux;

import java.io.*;
import gnu.getopt.Getopt;
import java.util.*;

public class Main {
	public static void main(String args[]) throws Exception {
		parser p;
		boolean stubbs = false;
		String root = "./";
		String appdir = null;
		String dotFile = "graph.dot";

		Getopt g = new Getopt("Main", args, "sld:r:a:");
		int c;

		while ((c = g.getopt()) != -1) {
			switch (c) {
			case 's':
				stubbs = true;
				break;
			case 'd':
				dotFile = g.getOptarg();
				break;

			case 'r':
				root = g.getOptarg();
				break;
			
			case 'a':
				appdir = g.getOptarg();
				break;
				
			}
		}
		p = new parser(new Yylex(new FileInputStream(args[g.getOptind()])));
		if (p == null) {
			System.out.println("Could not create parser!");
			System.exit(3);
		}
		Program pm = (Program) p.parse().value;
		if (pm == null) {
			System.out.println("Parse error!");
			System.exit(3);
		}

		if (pm.verifyExpressions()) {
			pm.unifyExpressions();

			// Dynamically Generate a DotGraph Here
			ProgramGraph pg = new ProgramGraph(pm);
			VirtualDirectory out = new VirtualDirectory(root);
			PrintWriter pw = new PrintWriter(out.getWriter(dotFile));
			int ix = args[0].lastIndexOf(File.separator);
			pg.outputDot(pw, args[0].substring(ix + 1));
			pw.flush();
			pw.close();
			
			
			//get the programs platforms
			Vector<Platform> plats = pm.getPlatforms();
			
			System.out.println("Generating code...");
			
			plats.add(new Platform("simulator",null));
			for (Platform plat : plats)
			{
				CodeGenerator gen = GeneratorFactory.getGenerator(plat.getName());
				
				if (gen != null)
				{
					System.out.println("\tplatform: "+plat.getName()+"...");
					
					//create directories
					String dname = root + "/" + plat.getName();
					//String rtdname = root + "/" + plat.getName()+"/runtime";
					String rtdname = dname;
				
					File f = new File(dname);
					if (!f.exists())
					{
						boolean success = f.mkdir();
						if (!success)
						{
							System.out.println("\t\tmkdir failed! : Permission problem or non-existant root");
							System.exit(1);
						}	
					}
					
					//create runtime directory
					f = new File(rtdname);
					if (!f.exists())
					{
						boolean success = f.mkdir();
						if (!success)
						{
							System.out.println("\t\tmkdir failed! : Permission problem or non-existant root");
							System.exit(1);
						}	
					}
					
					System.out.println("\t\tgenerating code...");
					//generate code
					gen.generate(dname, pg, pm, stubbs);
					
					
					System.out.println("\t\tcopy runtime...");
					//copy in runtime code
					Vector<String> targets = gen.getTargets();
					for (String t : targets)
					{
						System.out.println("\t\t\ttarget : "+t+"");
						File rtfile = new File("src/runtime/"+t);
						String[] contents = rtfile.list();
						if (contents != null)
						{
							for (String afile: contents)
							{
								//don't copy svn directories
								if (!afile.equals(".svn"))
								{
									callBash("cp -rf src/runtime/"+t+"/"+afile +" "+ rtdname+ "/.",false, 	"\t\t\t\t");
								}
							}
						}
					}
					
					System.out.println("\t\tcopy impl...");
					//copy in impl code
					for (String t : targets)
					{
						System.out.println("\t\t\ttarget : "+t+"");
					
						File appf = new File(appdir + "/impl/"+t);
						String[] contents = appf.list();
						
						if (contents != null)
						{
							for (String afile: contents)
							{
								//don't copy svn directories
								if (!afile.equals(".svn"))
								{
									callBash("cp -rf "+appdir+"/impl/"+t+"/"+afile +" "+ dname+ "/.", false, "\t\t\t\t");
								}
							}
						}
					}
				 
				} else {
					System.out.println("ERROR! No code generator found for platform: "+plat.getName());
					System.exit(1);
				}
			}
			/*
			// generate the simulation program here
			// new SimulatorGenerator(pm, pg, root);

			// Need two generators, for two platforms
			// StargateGenerator.generate(root, pg, pm);
			// Create a directory; all ancestor directories must exist
			boolean success;
			success = ((new File(root + "/telos")).mkdir() && (new File(root
					+ "/telos/runtime")).mkdir())
					&& (new File(root + "/simulator")).mkdir();
			if (!success) {
				System.out.println("Telos directory already exists or ERROR.");
			}
			
			//TelosGenerator.callBash("cp -R -u src/runtime/telos/* " + root + "/telos/runtime/.");
			//TelosGenerator.generate(root + "/telos", pg, pm, stubbs);
			
			success = (new File(root + "/mica2dot")).mkdir();
			success = (new File(root + "/mica2dot/runtime")).mkdir();
			success = (new File(root + "/mica2dot/test")).mkdir();
			if (!success) {
				System.out.println(root+"/mica2dot/runtime already exists or ERROR.");
			}
			
			Mica2DotGenerator.callBash("cp -R -u src/runtime/mica2dot/* " + root
					+ "/mica2dot/runtime/.");
			Mica2DotGenerator.generate(root + "/mica2dot", pg, pm, stubbs);
			

			success = ((new File(root + "/stargate")).mkdir() && (new File(root
					+ "/stargate/runtime")).mkdir());
			if (!success) {
				System.out
						.println("Stargate directory already exists or ERROR.");
			}
			
			
			success = (new File(root + "/stargatehelper")).mkdir();
			success = (new File(root + "/stargatehelper/runtime")).mkdir();
			if (!success) {
				System.out
						.println("StargateHelper directory already exists or ERROR.");
			}
			
			TelosGenerator.callBash("cp -R -u src/runtime/stargate/* " + root + "/stargate/runtime/.");
			TelosGenerator.callBash("cp -R -u src/runtime/stargatehelper/* " + root + "/stargatehelper/runtime/.");
			StargateGenerator.generate(root + "/stargate", pg, stubbs);
			SGHelperGenerator.generate(root + "/stargatehelper", pg, pm, stubbs);
			
			new SimulatorGenerator(pm, pg, root);
			*/
		} else {
			System.out.println("Usage: [-r destination_root] <program>");
		}
	}
	
	public static int callBash(String s, boolean echo, String prefix) {
		int result = -1;

		if (echo)
		{
			System.out.println(prefix + "BASH(" + s + ")");
		}

		try {
			String[] CMD = { "/bin/bash", "-c", s };
			ProcessBuilder pb = new ProcessBuilder(CMD);
			pb.redirectErrorStream(true);
			Process p = pb.start();
			int data = 0;
			while (data >= 0) {
				data = p.getInputStream().read();
				if (data >= 0) {
					char c = (char) data;
					System.out.print(c);
				}
			}

			p.waitFor();
			result = p.exitValue();
		} catch (Exception e) {
			System.out.println("Exception:" + e.getMessage());
		}
		return result;

	}
}
