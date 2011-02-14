interface OneWireDeviceMapper{
    commands error_t refresh();
    event void refreshDone(error_t result);
}
