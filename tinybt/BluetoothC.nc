/**
 *
 * $Rev:: 48          $:  Revision of last commit
 * $Author$:  Author of last commit
 * $Date$:  Date of last commit
 *
 **/
configuration BluetoothC
{
     provides {
          interface Bluetooth;
     }
}
implementation
{
     components HCICoreC;
     Bluetooth = HCICoreC.Bluetooth;
}
