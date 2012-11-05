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

#include <IPDispatch.h>
#include <lib6lowpan.h>
#include <ip.h>
#include "GathererReport.h"
#include <Statistics.h>

module GathererP {
  uses {

    interface Boot;
    interface SplitControl as RadioControl;

    /*Interfaz para controlar el Timer que refresca el WatchDog*/
    interface Timer<TMilli> as TimerWatchDog;

    interface Timer<TMilli> as ReinicioMotaTimer;

    interface Timer<TMilli> as LedsTimer;

    interface Timer<TMilli> as TimerMedidas;

    interface UDP as ServerUDP;

    interface Leds;

    interface Read<uint16_t> as Temperatura;
    interface Read<uint16_t> as Humedad;
    interface Read<uint16_t> as Voltaje;

    interface Statistics<route_statistics_t> as RouteStats;

  }

} implementation {

  static void fatal_problem();
  task void acumula_datos();
  task void envio();

  struct sockaddr_in6 dir_sink;

  uint16_t buffer_temperatura;
  uint16_t buffer_humedad;
  uint32_t temperatura_acumulada;
  uint32_t humedad_acumulada;

  uint8_t num_medida, num_medidas_ok;
  uint8_t num_sec;

  uint8_t sec_solicitadas[TAM_BUFFER + 1];
  uint8_t sec_retransmision[TAM_BUFFER];
  uint8_t longitud;

  gatherer_report buffer[TAM_BUFFER];
  gatherer_packet paquete;

  route_statistics_t route;

  bool lectura_sensor_ok = FALSE, buffer_lleno = FALSE, retransmision_pendiente = FALSE;

  event void Boot.booted() {

    #ifdef DIR_SINK
       inet_pton6(DIR_SINK, &dir_sink.sin6_addr);
       dir_sink.sin6_port = htons(10000);
    #endif

    if(call RadioControl.start() != SUCCESS)
       fatal_problem();

    dbg("Boot", "booted: %i\n", TOS_NODE_ID);

    call ServerUDP.bind(4);

    call TimerWatchDog.startPeriodic(512);
    WDTCTL = WDTPW + WDTHOLD;//Inicializamos el WatchDog
    WDTCTL = WDT_ARST_1000;  //Iniciamos el WatchDog 1000 ms

    call Leds.led0On();
    call Leds.led1On();
    call Leds.led2On();

    call LedsTimer.startOneShot(1024);

    num_medida = 0;
    num_medidas_ok = 0;
    num_sec = 0;

    call TimerMedidas.startPeriodic(INTERVALO_TIEMPO_MEDIDAS);
    call ReinicioMotaTimer.startOneShot(RESET);

  }

  event void RadioControl.startDone(error_t e) {
  
     if(e != SUCCESS)        
        fatal_problem();

  }

  event void RadioControl.stopDone(error_t e) {

  }

  event void ServerUDP.recvfrom(struct sockaddr_in6 *from, void *data, 
                           uint16_t len, struct ip_metadata *meta) {

     uint8_t i;
 
     call ReinicioMotaTimer.stop();     
     call ReinicioMotaTimer.startOneShot(RESET);

     if(len <= (TAM_BUFFER + 1)  && !retransmision_pendiente){
        memcpy(sec_solicitadas,data,len);
        longitud = 0;

        if(sec_solicitadas[0] > 0){

           for(i = 0; i < (len - 1); i++){

              if(sec_solicitadas[i + 1] < num_sec || (sec_solicitadas[i + 1] > num_sec && buffer_lleno)){
                 sec_retransmision[i] = sec_solicitadas[i + 1];
                 longitud++;
              
              }
           }
        }

        if(longitud > 0)
           retransmision_pendiente = TRUE;

     }
     

  }

  event void TimerMedidas.fired(){

     call Temperatura.read();
     
  } 

  event void TimerWatchDog.fired(){

     WDTCTL = WDTPW + WDTCNTCL;
     WDTCTL = WDT_ARST_1000;
 
  }

  event void LedsTimer.fired() {

     call Leds.led0Off();
     call Leds.led1Off();
     call Leds.led2Off();

  }

  event void ReinicioMotaTimer.fired(){

     fatal_problem();

  }

  event void Temperatura.readDone (error_t result, uint16_t valor){

     lectura_sensor_ok = FALSE;
 
     if (result == SUCCESS) {
        lectura_sensor_ok = TRUE;
	buffer_temperatura = valor;             
     }   

     if (call Humedad.read() != SUCCESS)
	fatal_problem();

  }

  event void Humedad.readDone (error_t result, uint16_t valor){

     if (result == SUCCESS) 
        buffer_humedad = valor;
     else
        lectura_sensor_ok = FALSE;

     post acumula_datos();

  }

  event void Voltaje.readDone (error_t result, uint16_t valor){

        uint16_t voltaje = 0;

        if(result == SUCCESS)
           voltaje = valor;
        
        buffer[num_sec].temperatura = 0;
        buffer[num_sec].humedad = 0;
        buffer[num_sec].voltaje = 0;

        buffer[num_sec].temperatura = temperatura_acumulada;
   
        buffer[num_sec].humedad = humedad_acumulada;
     
        buffer[num_sec].voltaje = voltaje;

        buffer[num_sec].total_medidas = num_medidas_ok;

        buffer[num_sec].num_sec = num_sec;

        call RouteStats.get(&route);

        num_medida = 0;
        num_medidas_ok = 0;

        paquete.id_nodo = TOS_NODE_ID;
        paquete.anterior = 0;
        paquete.parent = route.parent;
        paquete.etx = route.parent_etx;
        
        memcpy(&paquete.payload[0], &buffer[num_sec], sizeof(gatherer_report));

        if (num_sec < (TAM_BUFFER - 1))
           num_sec++;
        else{
	   buffer_lleno = TRUE; 
           num_sec = 0;
        }

        post envio();

  }

  task void envio(){
  
     uint8_t i,j;

     if(retransmision_pendiente){

           j = 1;
           
           for(i = 0; i < longitud ; i++){

              if(j == 6){

                 paquete.num_medias = j;        
                 if(call ServerUDP.sendto(&dir_sink, &paquete, 8 + (j * sizeof(gatherer_report))) == SUCCESS);
                 paquete.anterior = 1;
                 j = 0;

              }

              memcpy(&paquete.payload[j], &buffer[sec_retransmision[i]], sizeof(gatherer_report));
              j++;

           }

           paquete.num_medias = j;
           if(call ServerUDP.sendto(&dir_sink, &paquete, 8 + (j * sizeof(gatherer_report))) == SUCCESS);

           retransmision_pendiente = FALSE;

     }else{ 

           paquete.num_medias = 1;
           if(call ServerUDP.sendto(&dir_sink, &paquete, 8 + sizeof(gatherer_report)) == SUCCESS);
     }

     
  }

  task void acumula_datos(){

       if(num_medidas_ok == 0){
          temperatura_acumulada = 0;
          humedad_acumulada = 0;
       }
       
       if(lectura_sensor_ok){
          temperatura_acumulada += buffer_temperatura;
          humedad_acumulada += buffer_humedad;
          num_medidas_ok++; 
       }

       num_medida++;

       if(num_medida == NUM_MEDIDAS)
          if(call Voltaje.read() != SUCCESS)
             fatal_problem();           

  }

  static void fatal_problem() { 

    atomic{
        WDTCTL = 0;  
        while(TRUE);
    }
  }

}
