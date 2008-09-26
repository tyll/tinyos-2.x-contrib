
configuration Evaluator
{
  provides
  {
    interface StdControl;
    interface IEval;
  }

}

implementation
{
  components EvaluatorC, SolarSrc, LoadModel, ConsumeModel, Idle;

  components MainC;
  MainC.SoftwareInit -> EvaluatorC.Init;
  
  
  
  
  StdControl = SolarSrc.StdControl;
  StdControl = LoadModel.StdControl;
  StdControl = ConsumeModel.StdControl;
  StdControl = Idle.StdControl;
  IEval = EvaluatorC.IEval;

  EvaluatorC.IEnergySrc -> SolarSrc;
  EvaluatorC.ILoadModel -> LoadModel;
  EvaluatorC.IConsumeModel -> ConsumeModel;
  EvaluatorC.IIdle -> Idle;

}
