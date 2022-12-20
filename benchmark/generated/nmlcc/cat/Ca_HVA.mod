NEURON {
  SUFFIX Ca_HVA
  USEION ca WRITE ica READ eca
  RANGE conductance
}

PARAMETER {
  conductance = 0.00001 (uS)
}

STATE { gates_h_q gates_m_q }

INITIAL {
  LOCAL gates_m_reverseRate_r, gates_m_forwardRate_x, gates_m_forwardRate_r, gates_m_inf, gates_h_forwardRate_r, gates_h_reverseRate_r, gates_h_inf

  gates_m_reverseRate_r = 0.9399999976158142 * exp(-0.058823529411764705 * (75 + v))
  gates_m_forwardRate_x = 0.26315789803903855 * (27 + v)
  if (gates_m_forwardRate_x != 0) {
    gates_m_forwardRate_r = 0.20900000631809235 * gates_m_forwardRate_x * (1 + -1 * exp(-1 * gates_m_forwardRate_x))^-1
  } else {
    if (gates_m_forwardRate_x == 0) {
      gates_m_forwardRate_r = 0.20900000631809235
    } else {
      gates_m_forwardRate_r = 0
    }
  }
  gates_m_inf = gates_m_forwardRate_r * (gates_m_forwardRate_r + gates_m_reverseRate_r)^-1
  gates_h_forwardRate_r = 0.0004569999873638153 * exp(-0.02 * (13 + v))
  gates_h_reverseRate_r = 0.006500000134110451 * (1 + exp(-0.03571428571428571 * (15 + v)))^-1
  gates_h_inf = gates_h_forwardRate_r * (gates_h_forwardRate_r + gates_h_reverseRate_r)^-1
  gates_h_q = gates_h_inf
  gates_m_q = gates_m_inf
}

DERIVATIVE dstate {
  LOCAL gates_m_reverseRate_r, gates_m_forwardRate_x, gates_m_forwardRate_r, gates_m_inf, gates_m_tau, gates_h_forwardRate_r, gates_h_reverseRate_r, gates_h_inf, gates_h_tau

  gates_m_reverseRate_r = 0.9399999976158142 * exp(-0.058823529411764705 * (75 + v))
  gates_m_forwardRate_x = 0.26315789803903855 * (27 + v)
  if (gates_m_forwardRate_x != 0) {
    gates_m_forwardRate_r = 0.20900000631809235 * gates_m_forwardRate_x * (1 + -1 * exp(-1 * gates_m_forwardRate_x))^-1
  } else {
    if (gates_m_forwardRate_x == 0) {
      gates_m_forwardRate_r = 0.20900000631809235
    } else {
      gates_m_forwardRate_r = 0
    }
  }
  gates_m_inf = gates_m_forwardRate_r * (gates_m_forwardRate_r + gates_m_reverseRate_r)^-1
  gates_m_tau = (gates_m_forwardRate_r + gates_m_reverseRate_r)^-1
  gates_h_forwardRate_r = 0.0004569999873638153 * exp(-0.02 * (13 + v))
  gates_h_reverseRate_r = 0.006500000134110451 * (1 + exp(-0.03571428571428571 * (15 + v)))^-1
  gates_h_inf = gates_h_forwardRate_r * (gates_h_forwardRate_r + gates_h_reverseRate_r)^-1
  gates_h_tau = (gates_h_forwardRate_r + gates_h_reverseRate_r)^-1
  gates_h_q' = (gates_h_inf + -1 * gates_h_q) * gates_h_tau^-1
  gates_m_q' = (gates_m_inf + -1 * gates_m_q) * gates_m_tau^-1
}

BREAKPOINT {
  SOLVE dstate METHOD cnexp
  LOCAL gates_m_fcond, fopen0, g

  gates_m_fcond = gates_m_q * gates_m_q
  fopen0 = gates_h_q * gates_m_fcond
  g = conductance * fopen0
  ica = g * (v + -1 * eca)
}

