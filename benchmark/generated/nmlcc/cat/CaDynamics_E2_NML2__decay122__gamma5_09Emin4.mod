NEURON {
  SUFFIX CaDynamics_E2_NML2__decay122__gamma5_09Emin4
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
  cai' = -0.00819672131147541 * (-0.00009999999747378752 + cai) + 0.02637707426752184 * currDensCa
}

BREAKPOINT {
  SOLVE dstate METHOD cnexp

}

