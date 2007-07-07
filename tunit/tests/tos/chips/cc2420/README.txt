The following tests should be created:

* BaseStation functionality: No address recognition + software acks
* BaseStation functionality: No address recognition, no software acks
* LPL & No-LPL invalid destination address with ack verification
* LPL sleep @ various intervals
* LPL ability to change duty cycles on the fly
* LPL broadcast behavior with multiple receivers
* LPL throughput and ack success rate
* LPL detection ability/throughput with very large payloads
* LPL Make sure we're duty cycling properly and the radio is really turning
  on and off.


Think:  How can we quantify how long the radio is on? i.e. during
        receive checks / LPL?

