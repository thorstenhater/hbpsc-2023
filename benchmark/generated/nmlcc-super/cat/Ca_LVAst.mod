NEURON {
  SUFFIX Ca_LVAst
  USEION ca WRITE ica READ eca
  RANGE conductance
}

PARAMETER {
  conductance = 0.00001 (uS)
}

STATE { gates_h_q gates_m_q }

INITIAL {
  LOCAL gates_m_steadyState_x, gates_h_steadyState_x

  gates_m_steadyState_x = (1 + exp(-0.16666666666666666 * (40 + v)))^-1
  gates_h_steadyState_x = (1 + exp(0.1562499976716936 * (90 + v)))^-1
  gates_h_q = gates_h_steadyState_x
  gates_m_q = gates_m_steadyState_x
}

DERIVATIVE dstate {
  LOCAL gates_m_steadyState_x, gates_m_timeCourse_t, gates_m_tau, gates_h_steadyState_x, gates_h_timeCourse_t, gates_h_tau

  gates_m_steadyState_x = (1 + exp(-0.16666666666666666 * (40 + v)))^-1
  gates_m_timeCourse_t = 5 + 20 * (1 + exp(0.2 * (35 + v)))^-1
  gates_m_tau = 0.3386521442740891 * gates_m_timeCourse_t
  gates_h_steadyState_x = (1 + exp(0.1562499976716936 * (90 + v)))^-1
  gates_h_timeCourse_t = 20 + 50 * (1 + exp(0.14285714285714285 * (50 + v)))^-1
  gates_h_tau = 0.3386521442740891 * gates_h_timeCourse_t
  gates_h_q' = (gates_h_steadyState_x + -1 * gates_h_q) * gates_h_tau^-1
  gates_m_q' = (gates_m_steadyState_x + -1 * gates_m_q) * gates_m_tau^-1
}

BREAKPOINT {
  SOLVE dstate METHOD cnexp
  LOCAL gates_m_fcond, fopen0, g

  gates_m_fcond = gates_m_q * gates_m_q
  fopen0 = gates_h_q * gates_m_fcond
  g = conductance * fopen0
  ica = g * (v + -1 * eca)
}

