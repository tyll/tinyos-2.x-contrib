configuration MultiContextTrackC {
    provides interface MultiContextTrack[uint8_t id];
}
implementation {
    components MultiContextG;
    MultiContextTrack = MultiContextG;
}
