NEURON {
  SUFFIX NaTa_t
  USEION na WRITE ina READ ena
  RANGE conductance
}

PARAMETER {
  conductance = 0.00001 (uS)
}

STATE { gates_h_q gates_m_q }

INITIAL {
  LOCAL gates_m_reverseRate_x, gates_m_reverseRate_r, gates_m_forwardRate_x, gates_m_forwardRate_r, gates_m_inf, gates_h_reverseRate_x, gates_h_reverseRate_r, gates_h_forwardRate_x, gates_h_forwardRate_r, gates_h_inf

  gates_m_reverseRate_x = -0.16666666666666666 * (38 + v)
  if (gates_m_reverseRate_x != 0) {
    gates_m_reverseRate_r = 0.7440000176429749 * gates_m_reverseRate_x * (1 + -1 * exp(-1 * gates_m_reverseRate_x))^-1
  } else {
    if (gates_m_reverseRate_x == 0) {
      gates_m_reverseRate_r = 0.7440000176429749
    } else {
      gates_m_reverseRate_r = 0
    }
  }
  gates_m_forwardRate_x = 0.16666666666666666 * (38 + v)
  if (gates_m_forwardRate_x != 0) {
    gates_m_forwardRate_r = 1.0920000076293945 * gates_m_forwardRate_x * (1 + -1 * exp(-1 * gates_m_forwardRate_x))^-1
  } else {
    if (gates_m_forwardRate_x == 0) {
      gates_m_forwardRate_r = 1.0920000076293945
    } else {
      gates_m_forwardRate_r = 0
    }
  }
  gates_m_inf = gates_m_forwardRate_r * (gates_m_forwardRate_r + gates_m_reverseRate_r)^-1
  gates_h_reverseRate_x = 0.16666666666666666 * (66 + v)
  if (gates_h_reverseRate_x != 0) {
    gates_h_reverseRate_r = 0.09000000357627869 * gates_h_reverseRate_x * (1 + -1 * exp(-1 * gates_h_reverseRate_x))^-1
  } else {
    if (gates_h_reverseRate_x == 0) {
      gates_h_reverseRate_r = 0.09000000357627869
    } else {
      gates_h_reverseRate_r = 0
    }
  }
  gates_h_forwardRate_x = -0.16666666666666666 * (66 + v)
  if (gates_h_forwardRate_x != 0) {
    gates_h_forwardRate_r = 0.09000000357627869 * gates_h_forwardRate_x * (1 + -1 * exp(-1 * gates_h_forwardRate_x))^-1
  } else {
    if (gates_h_forwardRate_x == 0) {
      gates_h_forwardRate_r = 0.09000000357627869
    } else {
      gates_h_forwardRate_r = 0
    }
  }
  gates_h_inf = gates_h_forwardRate_r * (gates_h_forwardRate_r + gates_h_reverseRate_r)^-1
  gates_h_q = gates_h_inf
  gates_m_q = gates_m_inf
}

DERIVATIVE dstate {
  LOCAL gates_m_reverseRate_x, gates_m_reverseRate_r, gates_m_forwardRate_x, gates_m_forwardRate_r, gates_m_inf, gates_m_tau, gates_h_reverseRate_x, gates_h_reverseRate_r, gates_h_forwardRate_x, gates_h_forwardRate_r, gates_h_inf, gates_h_tau

  gates_m_reverseRate_x = -0.16666666666666666 * (38 + v)
  if (gates_m_reverseRate_x != 0) {
    gates_m_reverseRate_r = 0.7440000176429749 * gates_m_reverseRate_x * (1 + -1 * exp(-1 * gates_m_reverseRate_x))^-1
  } else {
    if (gates_m_reverseRate_x == 0) {
      gates_m_reverseRate_r = 0.7440000176429749
    } else {
      gates_m_reverseRate_r = 0
    }
  }
  gates_m_forwardRate_x = 0.16666666666666666 * (38 + v)
  if (gates_m_forwardRate_x != 0) {
    gates_m_forwardRate_r = 1.0920000076293945 * gates_m_forwardRate_x * (1 + -1 * exp(-1 * gates_m_forwardRate_x))^-1
  } else {
    if (gates_m_forwardRate_x == 0) {
      gates_m_forwardRate_r = 1.0920000076293945
    } else {
      gates_m_forwardRate_r = 0
    }
  }
  gates_m_inf = gates_m_forwardRate_r * (gates_m_forwardRate_r + gates_m_reverseRate_r)^-1
  gates_m_tau = (2.9528825283050537 * (gates_m_forwardRate_r + gates_m_reverseRate_r))^-1
  gates_h_reverseRate_x = 0.16666666666666666 * (66 + v)
  if (gates_h_reverseRate_x != 0) {
    gates_h_reverseRate_r = 0.09000000357627869 * gates_h_reverseRate_x * (1 + -1 * exp(-1 * gates_h_reverseRate_x))^-1
  } else {
    if (gates_h_reverseRate_x == 0) {
      gates_h_reverseRate_r = 0.09000000357627869
    } else {
      gates_h_reverseRate_r = 0
    }
  }
  gates_h_forwardRate_x = -0.16666666666666666 * (66 + v)
  if (gates_h_forwardRate_x != 0) {
    gates_h_forwardRate_r = 0.09000000357627869 * gates_h_forwardRate_x * (1 + -1 * exp(-1 * gates_h_forwardRate_x))^-1
  } else {
    if (gates_h_forwardRate_x == 0) {
      gates_h_forwardRate_r = 0.09000000357627869
    } else {
      gates_h_forwardRate_r = 0
    }
  }
  gates_h_inf = gates_h_forwardRate_r * (gates_h_forwardRate_r + gates_h_reverseRate_r)^-1
  gates_h_tau = (2.9528825283050537 * (gates_h_forwardRate_r + gates_h_reverseRate_r))^-1
  gates_h_q' = (gates_h_inf + -1 * gates_h_q) * gates_h_tau^-1
  gates_m_q' = (gates_m_inf + -1 * gates_m_q) * gates_m_tau^-1
}

BREAKPOINT {
  SOLVE dstate METHOD cnexp
  LOCAL gates_m_fcond, fopen0, g

  gates_m_fcond = gates_m_q * gates_m_q * gates_m_q
  fopen0 = gates_h_q * gates_m_fcond
  g = conductance * fopen0
  ina = g * (v + -1 * ena)
}

