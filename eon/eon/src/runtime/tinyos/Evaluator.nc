
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

  
  StdControl = EvaluatorC.StdControl;
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
