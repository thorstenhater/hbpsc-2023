NEURON {
  SUFFIX K_Pst
  USEION k WRITE ik READ ek
  RANGE conductance
}

PARAMETER {
  conductance = 0.00001 (uS)
}

STATE { gates_h_q gates_m_q }

INITIAL {
  LOCAL gates_m_steadyState_x, gates_h_steadyState_x

  gates_m_steadyState_x = (1 + exp(-0.08333333333333333 * (11 + v)))^-1
  gates_h_steadyState_x = (1 + exp(0.09090909090909091 * (64 + v)))^-1
  gates_h_q = gates_h_steadyState_x
  gates_m_q = gates_m_steadyState_x
}

DERIVATIVE dstate {
  LOCAL gates_m_steadyState_x, gates_m_timeCourse_t, gates_m_tau, gates_h_steadyState_x, gates_h_timeCourse_t, gates_h_tau

  gates_m_steadyState_x = (1 + exp(-0.08333333333333333 * (11 + v)))^-1
  if (v < -60) {
    gates_m_timeCourse_t = 1.25 + 175.02999877929688 * exp(0.026000000536441803 * (10 + v))
  } else {
    gates_m_timeCourse_t = 1.25 + 13 * exp(-0.026000000536441803 * (10 + v))
  }
  gates_m_tau = 0.3386521442740891 * gates_m_timeCourse_t
  gates_h_steadyState_x = (1 + exp(0.09090909090909091 * (64 + v)))^-1
  gates_h_timeCourse_t = 360 + (1010 + 24 * (65 + v)) * exp(-0.00043402777777777775 * (85 + v)^2)
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
  ik = g * (v + -1 * ek)
}

