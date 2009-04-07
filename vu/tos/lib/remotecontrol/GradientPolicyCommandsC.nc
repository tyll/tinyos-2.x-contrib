configuration GradientPolicyCommandsC {
}
implementation {
  components GradientFieldP, RemoteControlC, GradientPolicyCommandsP;

  GradientPolicyCommandsP.GradientField -> GradientFieldP;
  RemoteControlC.IntCommand[0x71] -> GradientPolicyCommandsP;

}

