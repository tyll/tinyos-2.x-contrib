package edu.umass.eflux.nesc;

import java.util.*;
import java.io.*;

public class NESCConfig {

	private File m_f;
	
	public NESCConfig(Vector<String> incs, String name, NESCInterfaceListing listing, NESCImpl impl)
	{
		
	}
	
	public boolean setFile(File f)
	{
		m_f = f;
		return (m_f.exists() && m_f.isFile());
	}
	
	public File getFile()
	{
		return m_f;
	}
}
