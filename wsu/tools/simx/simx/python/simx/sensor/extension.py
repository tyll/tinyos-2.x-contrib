from simx.base import Extension


class SensorNodeMixin(object):
    """
    Extension Mixin for L{Node}.

    B{REQUIRES:} The sensor_controller attribute should be defined on
    the instance.
    """
    def connect_sensor(self, channel_id, read_func, delay):
        """
        Connect a sensor channel.

        See L{SensorController.connect}.
        """
        self.sensor_controller.connect(self.id(), channel_id, read_func, delay)


    def disconnect_sensor(self, channel_id):
        """
        Disconnect a channel from a node.
        """
        raise NotImplementedError("not done")


class SensorExtension(Extension):
    """
    Sensor extension for L{TossimBase}.
    """

    def __init__(self, sensor_controller):
        """
        Initializer.

        @type  sensor_controller: L{SensorController}
        @param sensor_controller: backing sensor controller
        """
        Extension.__init__(self, extension_name="sensor")
        self.sensor_controller = sensor_controller


    def decorate_node_class(self, node_class):
        Extension.mixin(node_class, SensorNodeMixin)


    def decorate_node(self, node):
        node.sensor_controller = self.sensor_controller
