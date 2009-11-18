README para directJoin

Descripción:

En esta aplicación uno de los nodos toma el rol de coordinador ZigBee. Nada más
activarse realiza un reseteo de la capa de red ZigBee, después intenta crear
una nueva red en el canal 26 (2480 MHz). Tras esto asociará de manera directa
al router de dirección IEEE extendida 0x1122334455667788.

Un segundo nodo actúa como router ZigBee; resetea su capa de red y tratará de
conectarse de forma directa (RejoinNetwork = 0x01) a la red.

El significado de los LEDs es el siguiente:
COORDINADOR:
(ROJO)     LED0 ON  => NLME_DIRECT_JOIN.confirm [Status == NWK_SUCCESS]
(VERDE)    LED1 ON  => NLME_JOIN.indication

ROUTER
(ROJO)     LED0 ON     => NLME_JOIN.confirm  [Status == NWK_SUCCESS]

Uso:

1. Instalación del coordinador:

    $ cd coordinator; makeiz

2. Instalación del router:

    $ cd router; makeiz
