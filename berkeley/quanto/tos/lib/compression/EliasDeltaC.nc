configuration EliasDeltaC {
   provides interface EliasDelta;
}
implementation {
   components EliasDeltaP, EliasGammaC;
   EliasDelta = EliasDeltaP;
   EliasDeltaP.EliasGamma -> EliasGammaC;
}

