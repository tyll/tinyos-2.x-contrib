
interface ShutdownDev {

    /*
     * put the SX1211 radio and stm25p to sleep mode
     */

    command void sleep();
    command void flashSleep();
}
