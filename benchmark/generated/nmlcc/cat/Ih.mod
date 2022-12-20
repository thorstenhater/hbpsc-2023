NEURON {
  SUFFIX Ih
  NONSPECIFIC_CURRENT ihcn
  RANGE conductance, ehcn
}

PARAMETER {
  conductance = 0.00001 (uS)
  ehcn = 0 (mV)
}

STATE { gates_m_q }

INITIAL {
  LOCAL gates_m_reverseRate_r, gates_m_forwardRate_x, gates_m_forwardRate_r, gates_m_inf

  gates_m_reverseRate_r = 0.19300000369548798 * exp(0.030211481755258694 * v)
  gates_m_forwardRate_x = -0.08403361613918324 * (154.89999389648438 + v)
  if (gates_m_forwardRate_x != 0) {
    gates_m_forwardRate_r = 0.0765170007944107 * gates_m_forwardRate_x * (1 + -1 * exp(-1 * gates_m_forwardRate_x))^-1
  } else {
    if (gates_m_forwardRate_x == 0) {
      gates_m_forwardRate_r = 0.0765170007944107
    } else {
      gates_m_forwardRate_r = 0
    }
  }
  gates_m_inf = gates_m_forwardRate_r * (gates_m_forwardRate_r + gates_m_reverseRate_r)^-1
  gates_m_q = gates_m_inf
}

DERIVATIVE dstate {
  LOCAL gates_m_reverseRate_r, gates_m_forwardRate_x, gates_m_forwardRate_r, gates_m_inf, gates_m_tau

  gates_m_reverseRate_r = 0.19300000369548798 * exp(0.030211481755258694 * v)
  gates_m_forwardRate_x = -0.08403361613918324 * (154.89999389648438 + v)
  if (gates_m_forwardRate_x != 0) {
    gates_m_forwardRate_r = 0.0765170007944107 * gates_m_forwardRate_x * (1 + -1 * exp(-1 * gates_m_forwardRate_x))^-1
  } else {
    if (gates_m_forwardRate_x == 0) {
      gates_m_forwardRate_r = 0.0765170007944107
    } else {
      gates_m_forwardRate_r = 0
    }
  }
  gates_m_inf = gates_m_forwardRate_r * (gates_m_forwardRate_r + gates_m_reverseRate_r)^-1
  gates_m_tau = (gates_m_forwardRate_r + gates_m_reverseRate_r)^-1
  gates_m_q' = (gates_m_inf + -1 * gates_m_q) * gates_m_tau^-1
}

BREAKPOINT {
  SOLVE dstate METHOD cnexp
  LOCAL g

  g = conductance * gates_m_q
  ihcn = g * (v + -1 * ehcn)
}

