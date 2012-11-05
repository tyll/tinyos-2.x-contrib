/* Copyright (c) 2011 Universitat de Valencia.
*  All rights reserved.
*
*  Redistribution and use in source and binary forms, with or without
*  modification, are permitted provided that the following conditions
*  are met:
*
*  1. Redistributions of source code must retain the above copyright
*     notice, this list of conditions and the following disclaimer.
*  2. Redistributions in binary form must reproduce the above copyright
*     notice, this list of conditions and the following disclaimer in the
*     documentation and/or other materials provided with the distribution.
*  3. Neither the name of the copyright holders nor the names of
*     contributors may be used to endorse or promote products derived
*     from this software without specific prior written permission.
*
*  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS `AS IS'
*  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
*  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
*  ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS
*  BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
*  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, LOSS OF USE, DATA,
*  OR PROFITS) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
*  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
*  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF
*  THE POSSIBILITY OF SUCH DAMAGE.
*
*  For additional information see http://www.uv.es/varimos/
* 
*/

/**
 * @author Manuel Delamo
 */

import java.util.Date;
import java.util.Iterator;
import java.util.Vector;

import net.tinyos.message.Message;
import net.tinyos.message.MessageListener;
import net.tinyos.message.MoteIF;
import net.tinyos.packet.BuildSource;
import net.tinyos.packet.PhoenixSource;
import net.tinyos.util.PrintStreamMessenger;

import java.sql.*;

public class HarvesterMonitor implements MessageListener{


   private Vector<String> basestations;
   private Vector<MoteIF> motes;
   private HarvesterMsg hmsg;
   private final static int NO_ADDR=0xffff;

   public HarvesterMonitor() {

      basestations = new Vector<String>(4);

   }

   private void addBasestation(String string) {

      basestations.add(string);

   }
        
   public static void main(String[] args) {

      if (args.length == 0) {
         System.err.println("especifica al menos una basestation, ej: serial@/dev/ttyUSB0:telosb");
    	 System.exit(1);
      }

      HarvesterMonitor me = new HarvesterMonitor();

      for (int i=0;i<args.length;i++) {
         System.out.println("añadida basestation "+args[i]);
    	 me.addBasestation(args[i]);
      }

      me.run();

   }

    public void run() {
    
    	hmsg = new HarvesterMsg();
    	motes = new Vector<MoteIF>(basestations.size());
    	Iterator<String> i = basestations.iterator();
    	while (i.hasNext()) {
    		PhoenixSource source = BuildSource.makePhoenix(i.next() , PrintStreamMessenger.err);
    		source.setResurrection();
    		source.start();
    		MoteIF mif=new MoteIF(source);
    		mif.registerListener(hmsg, this);
    		motes.add(mif);
    	}
    }
    
    synchronized public void messageReceived(int dest_addr, Message msg) {
    	
           if (msg instanceof HarvesterMsg) {

    		HarvesterMsg hmsg = (HarvesterMsg) msg;
    		System.out.print("Paquete recibido para "+dest_addr+" de "+hmsg.get_id()+"("+hmsg.get_dsn()+")");
              

                //Base de datos
                Connection conn = null;	
                ResultSet rs;
                Statement stmt;

                boolean duplicado = false;

                try {
		     Class.forName("com.mysql.jdbc.Driver");
                     conn = DriverManager.getConnection("jdbc:mysql://127.0.0.1:3306/EHarvester?user=root&password=pass");
                   
	        } catch (Exception e) {
                     e.printStackTrace();
                }
                

                //Obtencion de datos
                short anterior = hmsg.get_anterior();
                double voltaje_real = (((double)hmsg.get_voltaje()) / 4096) * 3;


                //Topologia          

                //Consultas topologia

                String query_topo_act = "select * from topologia where Fecha between (now() - INTERVAL '5:00' MINUTE_SECOND) AND now() AND ID = "+hmsg.get_id()+" AND SEC = "+hmsg.get_dsn()+";"; 
                String update_topo_act = "INSERT INTO topologia (ID, ID_Padre, Voltaje, ETX, Fecha, SEC, Recuperado) values ("+hmsg.get_id()+","+hmsg.get_padre()+","+voltaje_real+","
                                          +hmsg.get_etx()+",now(),"+hmsg.get_dsn()+","+anterior+");";    

                String query_topo_ant = "select * from topologia where Fecha between (now() - INTERVAL '18:00' MINUTE_SECOND) AND now() AND ID = "+hmsg.get_id()+" AND SEC = "+hmsg.get_dsn()+";";
                String update_topo_ant = "INSERT INTO topologia (ID, ID_Padre, Voltaje, ETX, Fecha, SEC, Recuperado) values ("+hmsg.get_id()+","+hmsg.get_padre()+","+voltaje_real+","
                                          +hmsg.get_etx()+",now() - INTERVAL '10:05' MINUTE_SECOND,"+hmsg.get_dsn()+","+anterior+");";


                //Consultas motas

                String query_motas = "SELECT * from motas where ID = "+hmsg.get_id()+";"; 
                String update_motas_new = "INSERT INTO motas (ID, ID_Padre, Fecha) values ("+ hmsg.get_id() + "," + hmsg.get_padre() + ",now());";
                String update_motas_refresh = "UPDATE motas set ID_Padre = "+hmsg.get_padre()+", Fecha = now() WHERE ID = "+hmsg.get_id()+";";
		
		try{    
                 
                    stmt = conn.createStatement();

                    if(anterior == 0){		       

                       //Tabla motas
		       rs = stmt.executeQuery(query_motas);

                       if(!rs.first())
		          stmt.executeUpdate(update_motas_new);	                    

		       else 
		          stmt.executeUpdate(update_motas_refresh);
                     
                       //Tabla Topologia
                       rs = stmt.executeQuery(query_topo_act);

                       if(!rs.first())
                          stmt.executeUpdate(update_topo_act);
                       else
                          duplicado = true;

		    }else{

                       rs = stmt.executeQuery(query_topo_ant);

                       if(!rs.first())
                          stmt.executeUpdate(update_topo_ant);
                       else
                          duplicado = true;

                    }

                }catch (Exception e) {
                        e.printStackTrace();
                }


                if(!duplicado){

                   short num_medidas = hmsg.get_num_medidas();

                   if(num_medidas > 0){     
        
                      double temperatura = ((double)hmsg.get_temperatura())/num_medidas;
                      double humedad = ((double)hmsg.get_humedad())/num_medidas;
                
                      double temperatura_real = (temperatura - 3960) / 100;

                      double humedad_lineal = -2.0468 + 0.0367 * humedad + -1.5955 * Math.pow(10,-6) * humedad * humedad;

                      double humedad_real = (temperatura_real - 25) * (0.01 + 0.00008 * humedad) + humedad_lineal;
       
                      //double humedad_real = (temperatura_real - 25) * (0.01 + 0.00008 * humedad) + (-4 + 0.0405 * humedad - 2.8 * Math.pow(10,-6) * humedad * humedad);
                                                           
               
                      Date fecha = new Date();

		      fecha.setTime(System.currentTimeMillis());

    		      System.out.println(": Temperatura: "+temperatura_real+", Humedad: "+humedad_real+", Voltaje: "+voltaje_real+", Numero de medidas: "+num_medidas+", Fecha: "+fecha+", Anterior: "+anterior);               


                      //Tabla de datos

                      //Consultas datos

                      String update_datos_act = "INSERT INTO CEAM (ID, Temperatura, Temperatura_B, Humedad, Humedad_B, Medidas, Fecha, SEC) values ("+hmsg.get_id()+","+temperatura_real+","
                                                 +temperatura+","+humedad_real+","+humedad+","+num_medidas+", now(),"+hmsg.get_dsn()+");";

                      String update_datos_ant = "INSERT INTO CEAM (ID, Temperatura, Temperatura_B, Humedad, Humedad_B, Medidas, Fecha, SEC) values ("+hmsg.get_id()+","+temperatura_real+","
                                                 +temperatura+","+humedad_real+","+humedad+","+num_medidas+", now() - INTERVAL '10:05' MINUTE_SECOND,"+hmsg.get_dsn()+");";


                      try{

                         stmt = conn.createStatement();

                         if(anterior == 0)                                           
                            stmt.executeUpdate(update_datos_act);
                         else                   
                            stmt.executeUpdate(update_datos_ant);

                      }catch (Exception e){
                         e.printStackTrace();
                      }

                   }else
                      System.out.println(": Error en el sensor");

                }else
                   System.out.println(": Paquete duplicado");

                
                try{
                   conn.close();
                }catch(Exception e){
                   e.printStackTrace();
                }          
                
    	   }

    }
	
}
