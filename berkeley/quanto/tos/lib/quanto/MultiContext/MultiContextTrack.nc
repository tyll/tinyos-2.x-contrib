
interface MultiContextTrack {
    async event void added(act_t activity);
    async event void removed(act_t activity);
    async event void idle();
}
