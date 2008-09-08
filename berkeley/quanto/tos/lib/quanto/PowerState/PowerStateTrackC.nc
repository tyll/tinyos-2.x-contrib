/* Configuration that exports all tracked powerstates */

configuration PowerStateTrackC {
    provides interface PowerStateTrack[uint8_t id];
}
implementation {
    components PowerStateG;
    PowerStateTrack = PowerStateG;
}
