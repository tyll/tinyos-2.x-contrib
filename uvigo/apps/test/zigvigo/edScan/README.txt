README para edScan

Descripción:

En esta aplicación uno de los nodos actúa como un dispositivo final ZigBee.
Nada más activarse realiza un reseteo de la capa de red ZigBee y después
realiza escaneos de energía (NLME_ED_SCAN) de forma periódica en todos los
canales de la banda de 2,4 GHz. En cuanto se reciben los resultados de un
barrido se envían mediante "printf" por el puerto serie y después se vuelve
a solicitar otro escaneo.

Un nodo secundario puede actuar como inyector de energía en el canal 26. La
tarea del nodo consistirá en estar enviando mensajes continuamente al canal.
Cada vez que se confirma el envío de uno de estos mensajes, el LED1 cambiará
su estado.

El significado de los LEDs es el siguiente:
device:
(ROJO)     LED0 TOGGLE => NLME_ED_SCAN.confirm

txThroughput:
(VERDE)    LED1 TOGGLE => Paquete transmitido


Uso:

1. Instalación del dispositivo:

    $ cd device; makeiz

2. Instalación del inyector:

    $ cd txThroughput; makeiz
