NEURON {
  SUFFIX pas
  NONSPECIFIC_CURRENT i
  RANGE conductance, e
}

PARAMETER {
  conductance = 0.00001 (uS)
  e = 0 (mV)
}

BREAKPOINT {
  LOCAL g

  g = conductance
  i = g * (v + -1 * e)
}

