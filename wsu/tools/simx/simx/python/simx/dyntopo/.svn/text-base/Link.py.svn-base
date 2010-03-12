import math

class BasicLinkModel():    
    """
    A basic Link Layer model derived off of the USC generator.

    This basic model assumes homogenous transmission characteristics
    and does not generate a noise model.

    Some code/ideas from this class taken from LinkLayerModel.java, by
    USC, found in TinyOS.
    """

    def __init__(self):
        # path loss exponent (base is 10)
        self.n = 3
        # reference distance. txmap maps to reference values.
        self.d0 = 1
        # stddev. shadowing variance
        self.sigma = 1


    def txmap(gain):
        """
        Map a txgain (at mote) to simulation gain (at pld0) value.

        gain is the transmit power of the mote, in dBm. This is
        closely tied to d0 (the reference distance) and n (the path
        loss exponent).
        """
        return gain - 55

    txmap = staticmethod(txmap)


    def gain(self, a, b):
        """
        Returns a tuple of (gain a->b, gain b->a).

        a and b are Motes with extended information.
        """
        dx = a.ro_pos[0] - b.ro_pos[0]
        dy = a.ro_pos[1] - b.ro_pos[1]
        d = math.sqrt(dx*dx + dy*dy)

        if d > 0:
            pathloss = 10 * self.n * math.log(d/self.d0, 10)
        else:
            pathloss = 0

        return (a.ro_pld0 - pathloss, b.ro_pld0 - pathloss)
