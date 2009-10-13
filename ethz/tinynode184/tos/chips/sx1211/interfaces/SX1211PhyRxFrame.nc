interface SX1211PhyRxFrame {
    /**
     *
     *  signal irq0 in rxFrame
     *
     */
    async event void rxFrameStarted();
    
    /**
     *
     * signal a possible crc failed in rxFrame
     *
     */
    async event void rxFrameCrcFailed();

}
