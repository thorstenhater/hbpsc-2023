NEURON {
  SUFFIX L5PC_basal_dends_and_soma
  NONSPECIFIC_CURRENT ihcn
  RANGE Ih_conductance
}

PARAMETER {
  Ih_conductance = 0.00020000000298023223 (S_per_cm2)
}

STATE { Ih_gates_m_q }

INITIAL {
  LOCAL Ih_gates_m_reverseRate_r, Ih_gates_m_forwardRate_x, Ih_gates_m_forwardRate_r, Ih_gates_m_inf

  Ih_gates_m_reverseRate_r = 0.19300000369548798 * exp(0.030211481755258694 * v)
  Ih_gates_m_forwardRate_x = -0.08403361613918324 * (154.89999389648438 + v)
  if (Ih_gates_m_forwardRate_x != 0) {
    Ih_gates_m_forwardRate_r = 0.0765170007944107 * Ih_gates_m_forwardRate_x * (1 + -1 * exp(-1 * Ih_gates_m_forwardRate_x))^-1
  } else {
    if (Ih_gates_m_forwardRate_x == 0) {
      Ih_gates_m_forwardRate_r = 0.0765170007944107
    } else {
      Ih_gates_m_forwardRate_r = 0
    }
  }
  Ih_gates_m_inf = Ih_gates_m_forwardRate_r * (Ih_gates_m_forwardRate_r + Ih_gates_m_reverseRate_r)^-1
  Ih_gates_m_q = Ih_gates_m_inf
}

DERIVATIVE dstate {
  LOCAL Ih_gates_m_reverseRate_r, Ih_gates_m_forwardRate_x, Ih_gates_m_forwardRate_r, Ih_gates_m_inf, Ih_gates_m_tau

  Ih_gates_m_reverseRate_r = 0.19300000369548798 * exp(0.030211481755258694 * v)
  Ih_gates_m_forwardRate_x = -0.08403361613918324 * (154.89999389648438 + v)
  if (Ih_gates_m_forwardRate_x != 0) {
    Ih_gates_m_forwardRate_r = 0.0765170007944107 * Ih_gates_m_forwardRate_x * (1 + -1 * exp(-1 * Ih_gates_m_forwardRate_x))^-1
  } else {
    if (Ih_gates_m_forwardRate_x == 0) {
      Ih_gates_m_forwardRate_r = 0.0765170007944107
    } else {
      Ih_gates_m_forwardRate_r = 0
    }
  }
  Ih_gates_m_inf = Ih_gates_m_forwardRate_r * (Ih_gates_m_forwardRate_r + Ih_gates_m_reverseRate_r)^-1
  Ih_gates_m_tau = (Ih_gates_m_forwardRate_r + Ih_gates_m_reverseRate_r)^-1
  Ih_gates_m_q' = (Ih_gates_m_inf + -1 * Ih_gates_m_q) * Ih_gates_m_tau^-1
}

BREAKPOINT {
  SOLVE dstate METHOD cnexp
  LOCAL Ih_g

  Ih_g = Ih_conductance * Ih_gates_m_q
  ihcn = Ih_g * (45 + v)
}

