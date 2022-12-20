NEURON {
  SUFFIX Im
  USEION k WRITE ik READ ek
  RANGE conductance
}

PARAMETER {
  conductance = 0.00001 (uS)
}

STATE { gates_m_q }

INITIAL {
  LOCAL gates_m_forwardRate_r, gates_m_reverseRate_r, gates_m_inf

  gates_m_forwardRate_r = 0.0032999999821186066 * exp(0.1 * (35 + v))
  gates_m_reverseRate_r = 0.0032999999821186066 * exp(-0.1 * (35 + v))
  gates_m_inf = gates_m_forwardRate_r * (gates_m_forwardRate_r + gates_m_reverseRate_r)^-1
  gates_m_q = gates_m_inf
}

DERIVATIVE dstate {
  LOCAL gates_m_forwardRate_r, gates_m_reverseRate_r, gates_m_inf, gates_m_tau

  gates_m_forwardRate_r = 0.0032999999821186066 * exp(0.1 * (35 + v))
  gates_m_reverseRate_r = 0.0032999999821186066 * exp(-0.1 * (35 + v))
  gates_m_inf = gates_m_forwardRate_r * (gates_m_forwardRate_r + gates_m_reverseRate_r)^-1
  gates_m_tau = (2.9528825283050537 * (gates_m_forwardRate_r + gates_m_reverseRate_r))^-1
  gates_m_q' = (gates_m_inf + -1 * gates_m_q) * gates_m_tau^-1
}

BREAKPOINT {
  SOLVE dstate METHOD cnexp
  LOCAL g

  g = conductance * gates_m_q
  ik = g * (v + -1 * ek)
}

