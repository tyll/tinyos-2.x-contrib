README para sync

Descripción:

En esta aplicación uno de los nodos toma el rol de coordinador ZigBee. Nada más
activarse realiza un reseteo de la capa de red ZigBee, después intenta crear
una nueva red en el canal 26 (2480 MHz) y activa su radio de para aceptar
peticiones de conexión a su PAN.
Cada vez que un dispositivo intenta asociarse, el coordinador ZigBee se lo
permite y le asigna una nueva dirección de red. Después comienza a transmitir
de forma indirecta (el router se especificará
CapabilityInformation.ReceiverOnWhenIdle == 0 al conectarse a la red) una trama
cada segundo al router de forma indefinida.

Un segundo nodo actúa como router ZigBee con
CapabilityInformation.ReceiverOnWhenIdle == 0; resetea su capa de red, e
intentará conectarse a la red de PANId 0xFFEEDDCCBBAA0099LL mediante el
procedimiento de red (RejoinNetwork = 0x02). Una vez conectado, sondeará a su
nodo padre cada segundo en espera de paquetes de datos para él.

El significado de los LEDs es el siguiente:
COORDINADOR:
(ROJO)     LED0 ON     => NLME_JOIN.indication
(VERDE)    LED1 TOGGLE => NLDE_DATA.confirm [Status == NWK_SUCCESS]

ROUTER
(ROJO)     LED0 ON     => NLME_JOIN.confirm  [Status == NWK_SUCCESS]
(VERDE)    LED1 TOGGLE => NLDE_DATA.indication
(AMARILLO) LED2 TOGGLE => NLME_SYNC.confirm [Status == NWK_SUCCESS]

Uso:

1. Instalación del coordinador:

    $ cd coordinator; makeiz

2. Instalación del router:

    $ cd router; makeiz
