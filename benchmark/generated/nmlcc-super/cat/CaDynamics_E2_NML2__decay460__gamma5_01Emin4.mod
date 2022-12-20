NEURON {
  SUFFIX CaDynamics_E2_NML2__decay460__gamma5_01Emin4
  USEION ca WRITE cai READ ica
  RANGE initialConcentration
}

PARAMETER {
  initialConcentration = 0 (mM)
}

STATE { cai }

INITIAL {
  cai = initialConcentration
}

DERIVATIVE dstate {
  LOCAL currDensCa

  currDensCa = -0.009999999776482582 * ica
  cai' = -0.002173913043478261 * (-0.00009999999747378752 + cai) + 0.02596250319564956 * currDensCa
}

BREAKPOINT {
  SOLVE dstate METHOD cnexp

}

