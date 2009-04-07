configuration TestRemoteControlAppC {
} implementation {
  components new AutoStartC(), ActiveMessageC as AM;

  // initialization and startup
  AutoStartC.SplitControl-> AM.SplitControl;

  // RemoteControll components
  components LedCommandsC;
}
