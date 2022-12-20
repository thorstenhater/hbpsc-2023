NEURON {
  SUFFIX SKv3_1
  USEION k WRITE ik READ ek
  RANGE conductance
}

PARAMETER {
  conductance = 0.00001 (uS)
}

STATE { gates_m_q }

INITIAL {
  LOCAL gates_m_steadyState_x

  gates_m_steadyState_x = (1 + exp(-0.10309278553230808 * (-18.700000762939453 + v)))^-1
  gates_m_q = gates_m_steadyState_x
}

DERIVATIVE dstate {
  LOCAL gates_m_steadyState_x, gates_m_timeCourse_t

  gates_m_steadyState_x = (1 + exp(-0.10309278553230808 * (-18.700000762939453 + v)))^-1
  gates_m_timeCourse_t = 4 * (1 + exp(-0.022655188351328265 * (46.560001373291016 + v)))^-1
  gates_m_q' = (gates_m_steadyState_x + -1 * gates_m_q) * gates_m_timeCourse_t^-1
}

BREAKPOINT {
  SOLVE dstate METHOD cnexp
  LOCAL g

  g = conductance * gates_m_q
  ik = g * (v + -1 * ek)
}

