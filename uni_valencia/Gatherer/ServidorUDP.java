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


import java.net.*;
import java.nio.*;
import java.io.*;
import java.sql.*;
import java.util.*;


class Retransmision extends TimerTask{

   private Connection conn;	
   private Statement stmt;
   private ResultSet resultado;
   private String ip = "fec0::";
   private int puertoUDP = 4;
   private DatagramSocket Socket;
   private DatagramPacket paquete;

   public void run(){

      Timestamp fecha_consulta = null;
      java.util.Date tiempo = new java.util.Date();
      tiempo.setTime(System.currentTimeMillis());
      System.out.println("Solicitamos retransmision " + tiempo);

      Vector<Integer> vector_motas = new Vector<Integer>();

      try {

         Class.forName("com.mysql.jdbc.Driver");
         conn = DriverManager.getConnection("jdbc:mysql://127.0.0.1:3306/Gatherer?user=root&password=pass");

         stmt = conn.createStatement();


         resultado = stmt.executeQuery("select distinct ID from topologia where Fecha between (now() - INTERVAL '15:00' MINUTE_SECOND) and now();");

         if(resultado.first()){
    
            do{

               vector_motas.add(resultado.getInt("ID"));

            }while(resultado.next());

         }


         conn.close();      

      }catch (Exception e){
         e.printStackTrace();
      }



      if(!vector_motas.isEmpty()){
         Iterator it = vector_motas.iterator();
            
         while(it.hasNext()){

            Vector<Integer> secuencias_perdidas = null, vector_secuencias = null;

            int id = (Integer) it.next();

            System.out.println();

            vector_secuencias = this.obtenerSecuencias(id);

            secuencias_perdidas = this.obtenerSecuenciasPerdidas(vector_secuencias);

            byte[] payload = this.obtenerPayload(secuencias_perdidas);

            this.envio(id, payload);

            try{
               Thread.sleep(5000);
            }catch(Exception e2){
               e2.printStackTrace();
            }

         }

      }
   
   }

   public void envio(int id, byte[] payload){
   
      String destino = ip + Integer.toHexString(id);

      try{

         Socket = new DatagramSocket();
         paquete = new DatagramPacket(payload, payload.length, InetAddress.getByName(destino), puertoUDP);
         Socket.send(paquete);

      }catch(UnknownHostException e){
         System.out.println("Ip no válida");
      }catch(SocketException se){
         System.out.println("Error Socket UDP de retransmision: creacion");
      }catch(IOException io){
         io.printStackTrace();
         System.out.println("Error Socket UDP de retransmision: envio");
      } 

   }


   public Vector<Integer> obtenerSecuencias(int id_mota){


      Vector<Integer> vector_sec = new Vector<Integer>();

      try{
 
         Class.forName("com.mysql.jdbc.Driver");
         conn = DriverManager.getConnection("jdbc:mysql://127.0.0.1:3306/Gatherer?user=root&password=pass");

         stmt = conn.createStatement();

         resultado = stmt.executeQuery("select SEC, Fecha from topologia where ID = "+id_mota+" and Fecha between (now() - INTERVAL '12:00:00' HOUR_SECOND) and now() order by Fecha desc;");

         if(resultado.first()){

            long tiempo_reciente = resultado.getTimestamp("Fecha").getTime();
            int secuencia_reciente = resultado.getInt("SEC");
            boolean bandera = true;

            do{

               int num_sec = resultado.getInt("SEC");
               long tiempo_real = resultado.getTimestamp("Fecha").getTime();

               int k = 0;

               if(num_sec < secuencia_reciente)
                  k = secuencia_reciente - num_sec;
               else
                  k = secuencia_reciente + (72 - num_sec);

               long horas = k / 6;
               long minutos = k % 6;
               long tolerancia = 180000;

               long tiempo_diferencia = (horas * 3600000) + (minutos * 10 * 60000) + tolerancia;

               if(vector_sec.isEmpty() || (!vector_sec.contains(num_sec) && tiempo_real >= (tiempo_reciente - tiempo_diferencia))){

                  vector_sec.add(num_sec);
                 
               }else
                  bandera = false;

            }while(resultado.next() && bandera);

   
         }

         conn.close();      

      }catch (Exception e){
         e.printStackTrace();
      }

      return vector_sec;

   }

   public Vector<Integer> obtenerSecuenciasPerdidas(Vector<Integer> vector_sec){

      Vector<Integer> secuencias_perdidas = new Vector<Integer>();
      
      if(!vector_sec.isEmpty()){

         if(vector_sec.size() < 72){
            
            Iterator iter = vector_sec.iterator();

            int sec_actual = (Integer) iter.next(); 
            int sec_ref = sec_actual;
            boolean bandera = true;

            while(iter.hasNext() && bandera){

               int sec = (Integer) iter.next();

               if(sec_actual == 0)
                  sec_actual = 71;
               else
                  sec_actual--;

               if(sec_actual == sec_ref)
                  bandera = false;
                      
               while(sec_actual != sec && bandera){

                  secuencias_perdidas.add(sec_actual); 

                  if(sec_actual == 0)
                     sec_actual = 71;
                  else
                     sec_actual--;

                  if(sec_actual == sec_ref || secuencias_perdidas.size() >= 71)
                     bandera = false;

               }
            }

            while(bandera){

               if(sec_actual == 0)
                  sec_actual = 71;
               else
                  sec_actual--;

               if(sec_actual == sec_ref || secuencias_perdidas.size() >= 71)
                  bandera = false;

               if(bandera)
                  secuencias_perdidas.add(sec_actual);
    
            }  
         }
      }
      return secuencias_perdidas; 
   
   }

   public byte[] obtenerPayload(Vector<Integer> secuencias_perdidas){

      byte[] payload = new byte[1];
      payload[0] = (byte) 0;

      if(secuencias_perdidas != null && secuencias_perdidas.size() > 0){
         payload = new byte[secuencias_perdidas.size() + 1];
         payload[0] = (byte) (payload.length - 1);

         Iterator iter_sec_perd = secuencias_perdidas.iterator();

         int i = 1;
         while(iter_sec_perd.hasNext()){

            payload[i] = ((Integer) iter_sec_perd.next()).byteValue();
            System.out.print(payload[i] + " ");
            i++;

         }
         
      }

      return payload;

   }

}


class TratamientoDatos extends Thread{

   private ByteBuffer buffer; 
   private Connection conn;	
   private Statement stmt;
   private ResultSet resultado;
   private int temperatura, humedad, id, anterior, num_medias, voltaje, total_medidas, num_sec, indice, padre, etx;
   private double temperatura_real, humedad_real, voltaje_real, humedad_sensor, temperatura_sensor; 

   public TratamientoDatos(byte[] payload){

      buffer = ByteBuffer.wrap(payload);

   }

   public void run(){
      
      
      id = (int)buffer.getShort();
      anterior = (int)buffer.get();
      num_medias = (int)buffer.get();
      padre = (int)buffer.getShort();
      etx = (int)buffer.getShort();

      for(int i = 0; i < num_medias; i++){
      
            temperatura = buffer.getInt();

            humedad = buffer.getInt();

            voltaje = (int)buffer.getShort();

            total_medidas = (int)buffer.get();

            num_sec = (int)buffer.get();

            temperatura_sensor = 0;
            humedad_sensor = 0;

            voltaje_real = (((double)voltaje) / 4096) * 3;

            if(total_medidas > 0) {

               temperatura_sensor = ((double)temperatura)/ total_medidas;
               temperatura_real = (temperatura_sensor - 3960) / 100;

               humedad_sensor = ((double)humedad) / total_medidas;

               double humedad_lineal = -2.0468 + 0.0367 * humedad_sensor + -1.5955 * Math.pow(10,-6) * humedad_sensor * humedad_sensor;

               humedad_real = (temperatura_real - 25) * (0.01 + 0.00008 * humedad_sensor) + humedad_lineal;

               java.util.Date fecha = new java.util.Date();
               fecha.setTime(System.currentTimeMillis());

               System.out.println ("ID: " + id + "; Temperatura: " + temperatura_real + "; Humedad: " + humedad_real + "; Voltaje: " + voltaje_real + "; Numero de medidas: " + total_medidas + "; Fecha: " + fecha + "; Sec: " + num_sec + "; ID Padre: " + padre + "; Anterior: " + anterior);
     
               this.inserccionBDD(true, i);

            }else{
               System.out.println ("ID: " + id + "; Error en el sensor");
               this.inserccionBDD(false, i);

            }

      }

   }

   public void inserccionBDD(boolean medidas, int posicion){

      String fecha = "";
      int recuperado = 0;

      try {

         Class.forName("com.mysql.jdbc.Driver");
         conn = DriverManager.getConnection("jdbc:mysql://127.0.0.1:3306/Gatherer?user=root&password=pass");

         stmt = conn.createStatement();     

         if(anterior == 0 && posicion == 0){
            fecha = "now()";

            resultado = stmt.executeQuery("SELECT COUNT(*) as count FROM motas WHERE ID=" + id + ";");
            resultado.first();	
		    
            if (resultado.getString("count").compareTo("0") == 0)
               stmt.executeUpdate("INSERT INTO motas (ID, ID_Padre, Fecha) values ("+ id + "," + padre + ","+fecha+")");	                    

            else {
               stmt.executeUpdate("UPDATE motas set ID_Padre="+ padre + " WHERE ID=" + id);
	       stmt.executeUpdate("UPDATE motas set Fecha="+fecha+" WHERE ID=" + id);

            }

         }else{

            resultado = stmt.executeQuery("select Fecha, SEC from topologia where id = "+id+" and Fecha between (now() - INTERVAL '15:00' MINUTE_SECOND) and now() order by Fecha desc limit 1;");

            if(resultado.first()){
               Timestamp fecha_reciente = resultado.getTimestamp("Fecha");
               int secuencia_reciente = resultado.getInt("SEC");

               int k = 0;

               if(num_sec < secuencia_reciente)
                  k = secuencia_reciente - num_sec;
               else
                  k = secuencia_reciente + (72 - num_sec);

               int horas = k / 6;
               int minutos = k % 6;

               fecha = "('" + fecha_reciente + "' - INTERVAL '"+horas+":"+minutos+"0:00' HOUR_SECOND)";
            }else{
               conn.close();
               return;
            }
           
            recuperado = 1;
               

         }

         if(medidas){                   
            resultado = stmt.executeQuery("select * from CEAM where Fecha >= ("+fecha+" - INTERVAL '1:00' MINUTE_SECOND)" +
                                        " AND Fecha < "+fecha+" AND ID = " + id + " AND SEC = " + num_sec + ";");

            if(!resultado.first())	                     
               stmt.executeUpdate("INSERT INTO CEAM (ID, Temperatura, Temperatura_B, Humedad, Humedad_B, Num_Medidas, Fecha, SEC) values (" + id + "," 
                                                + temperatura_real + "," + temperatura_sensor + "," + humedad_real + "," + humedad_sensor + ","
                                                + total_medidas + ", "+fecha+"," + num_sec + ")");

         }

         resultado = stmt.executeQuery("select * from topologia where Fecha >= ("+fecha+" - INTERVAL '1:00' MINUTE_SECOND)" +
                                        " AND Fecha < "+fecha+" AND ID = " + id + " AND SEC = " + num_sec + ";");

         if(!resultado.first())
            stmt.executeUpdate("INSERT INTO topologia (ID, ID_Padre, Voltaje, ETX, Fecha, SEC, Recuperado) values ("+ id + "," + padre + "," + voltaje_real + "," + etx +","+fecha+
                              "," + num_sec + "," + recuperado + ")");


         conn.close();

                   
      }catch (Exception e){
         e.printStackTrace();
      }

   }
   
}


public class ServidorUDP {

   public static void main (String args[]){

      DatagramSocket dgSocket;
      DatagramPacket datagram;

      Timer timer_retransmision = new Timer(false);
      timer_retransmision.schedule(new Retransmision(), 10000, 3600000);

      byte msg[] = new byte[1024];

      try{

         dgSocket = new DatagramSocket(10000);

         while(true){

            datagram = new DatagramPacket (msg, msg.length);
            dgSocket.receive(datagram);

            new TratamientoDatos(datagram.getData()).start();

         }
      }catch(SocketException se){
         System.out.println("Error en el socket UDP");
      }catch(IOException ioe){
         System.out.println("Error en el receive socket UDP");
      }

   }

}
