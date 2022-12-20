NEURON {
  SUFFIX CaDynamics_E2_NML2
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
  cai' = -0.0125 * (-0.00009999999747378752 + cai) + 2.591068360642384 * currDensCa
}

BREAKPOINT {
  SOLVE dstate METHOD cnexp

}

