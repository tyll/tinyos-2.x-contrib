configuration SingleContextTrackC {
    provides interface SingleContextTrack[uint8_t id];
}
implementation {
    components SingleContextG;
    SingleContextTrack = SingleContextG;
}
