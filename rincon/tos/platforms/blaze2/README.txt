This platform contains both CC1100 and CC2500 radios.


  [ Standard AMSenderC / AMQueue ]   Queue up a bunch of messages
                 ||
                 \/                  Configure the outbound messages:
           [ MsgRegistry ]~~~~~o)~~~~[ Application Specific NetworkRegistry ]
                 ||
                 \/
           [ RfResource ]            Turn on the correct radio
                 ||
                 \/
          [ ActiveMessageP ]         Send commands to the correct radio stack
                 ||
                 \/
  [ CC1100 ] [ CC2500 ] [ NBD ]      Radio stacks


