README para coord+Router+Device

Descripción:

En esta aplicación se probará a conectar un dispositivo final a un router
diferente del coordinador, esto es, una conexión con un router que ya se
encuentre conectado al coordinador. Primero hay que cargar la aplicación en el
router y después, en un mismo nodo cargar el coordinador que permita asociarse
al router y finalmente cargar el código del device.

El coordinador inicia la red y queda a la espera de nuevas conexiones a las que
asignar direcciones de red.

El router se conecta al coordinador y también se quedará a la espera de
conexiones.

Un tercer nodo hará una búsqueda de las redes disponibles, y al encontrar al
router (entonces ya se habrá apagado el coordinador) intentará asociarse a
través de él.

El significado de los LEDs es el siguiente:
COORDINADOR:
(ROJO)     LED0 ON     => NLME_PERMIT_JOINING.confirm [Status == NWK_SUCCESS]
(VERDE)    LED1 ON     => NLDE_JOIN.indication

ROUTER
(ROJO)     LED0 ON     => NLME_JOIN.confirm  [Status == NWK_SUCCESS]
(VERDE)    LED1 ON     => NLDE_JOIN.indication
(AMARILLO) LED2 ON     => NLME_PERMIT_JOINING.confirm [Status == NWK_SUCCESS]

DEVICE
(ROJO)     LED0 ON     => NLME_JOIN.confirm  [Status == NWK_SUCCESS]


Uso:

1. Instalación del router:

    $ cd router; makeiz

2. Instalación del coordinador:

    $ cd coordinador; makeiz

2. Instalación del device:

    $ cd device; makeiz
