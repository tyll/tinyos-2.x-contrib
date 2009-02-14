interface QuantoLog {
    command error_t record();
    command error_t flush();
    event void full();
    event void flushDone();
}
