configuration SingleContextP {
    provides {
        interface SingleContext[uint8_t local_res_id];
        interface SingleContextTrack[uint8_t local_res_id];
        interface Init;
    }
}

implementation {
    components SingleContextImplP, ActivityTypeP;

    SingleContext = SingleContextImplP;
    SingleContextTrack = SingleContextImplP;
    Init = SingleContextImplP;

    SingleContextImplP.ActivityType -> ActivityTypeP;
}
