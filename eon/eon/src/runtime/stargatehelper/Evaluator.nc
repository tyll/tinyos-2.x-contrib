
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
  components EvaluatorC, HelioSrc, LoadModel, ConsumeModel, Idle;

  
  StdControl = EvaluatorC.StdControl;
  StdControl = HelioSrc.StdControl;
  StdControl = LoadModel.StdControl;
  StdControl = ConsumeModel.StdControl;
  StdControl = Idle.StdControl;
  IEval = EvaluatorC.IEval;

  EvaluatorC.IEnergySrc -> HelioSrc;
  EvaluatorC.ILoadModel -> LoadModel;
  EvaluatorC.IConsumeModel -> ConsumeModel;
  EvaluatorC.IIdle -> Idle;

}
