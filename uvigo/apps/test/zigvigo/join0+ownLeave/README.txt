README para join0+OwnLeave

Descripción:

En esta aplicación uno de los nodos toma el rol de coordinador ZigBee. Nada más
activarse realiza un reseteo de la capa de red ZigBee, después intenta crear
una nueva red en el canal 26 (2480 MHz) y finalmente activa su radio de para
aceptar peticiones de conexión a su PAN. Cada vez que un dispositivo intenta
asociarse, el coordinador ZigBee se lo permite y le asigna una nueva dirección
de red.

Un segundo nodo actúa como router ZigBee; resetea su capa de red, realiza una
búsqueda en el canal 26 de redes en su área de cobertura e intentará conectarse
al coordinador ZigBee (PAN Id extendida 0xFFEEDDCCBBAA0099) mediante el
procedimiento de asociación. Tras conseguir conectarse a la red comenzará a
transmitir una trama al coordinador cada segundo hasta un total de nueve.
Finalmente se desconectará de la red solicitando a la capa de red su propio
abandono.

El significado de los LEDs es el siguiente:
COORDINADOR:
(ROJO)     LED0 ON     => NLME_JOIN.indication
(VERDE)    LED1 TOGGLE => NLDE_DATA.indication
(AMARILLO) LED2 ON     => NLME_LEAVE.indication

ROUTER
(ROJO)     LED0 ON     => NLME_JOIN.confirm  [Status == NWK_SUCCESS]
(VERDE)    LED1 TOGGLE => NLDE_DATA.confirm  [Status == NWK_SUCCESS]
(AMARILLO) LED2 ON     => NLME_LEAVE.confirm [Status == NWK_SUCCESS]

Uso:

1. Instalación del coordinador:

    $ cd coordinator; makeiz

2. Instalación del router:

    $ cd router; makeiz
