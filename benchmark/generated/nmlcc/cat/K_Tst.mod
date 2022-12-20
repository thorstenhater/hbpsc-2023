NEURON {
  SUFFIX K_Tst
  USEION k WRITE ik READ ek
  RANGE conductance
}

PARAMETER {
  conductance = 0.00001 (uS)
}

STATE { gates_h_q gates_m_q }

INITIAL {
  LOCAL gates_m_steadyState_x, gates_h_steadyState_x

  gates_m_steadyState_x = (1 + exp(-0.05263157894736842 * (10 + v)))^-1
  gates_h_steadyState_x = (1 + exp(0.1 * (76 + v)))^-1
  gates_h_q = gates_h_steadyState_x
  gates_m_q = gates_m_steadyState_x
}

DERIVATIVE dstate {
  LOCAL gates_m_steadyState_x, gates_m_timeCourse_t, gates_m_tau, gates_h_steadyState_x, gates_h_timeCourse_t, gates_h_tau

  gates_m_steadyState_x = (1 + exp(-0.05263157894736842 * (10 + v)))^-1
  gates_m_timeCourse_t = 0.3400000035762787 + 0.9200000166893005 * exp(-1 * (0.01694915254237288 * (81 + v))^2)
  gates_m_tau = 0.3386521442740891 * gates_m_timeCourse_t
  gates_h_steadyState_x = (1 + exp(0.1 * (76 + v)))^-1
  gates_h_timeCourse_t = 8 + 49 * exp(-1 * (0.043478260869565216 * (83 + v))^2)
  gates_h_tau = 0.3386521442740891 * gates_h_timeCourse_t
  gates_h_q' = (gates_h_steadyState_x + -1 * gates_h_q) * gates_h_tau^-1
  gates_m_q' = (gates_m_steadyState_x + -1 * gates_m_q) * gates_m_tau^-1
}

BREAKPOINT {
  SOLVE dstate METHOD cnexp
  LOCAL gates_m_fcond, fopen0, g

  gates_m_fcond = gates_m_q * gates_m_q * gates_m_q * gates_m_q
  fopen0 = gates_h_q * gates_m_fcond
  g = conductance * fopen0
  ik = g * (v + -1 * ek)
}

