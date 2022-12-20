NEURON {
  SUFFIX SK_E2
  USEION ca READ cai
  USEION k WRITE ik READ ek
  RANGE conductance
}

PARAMETER {
  conductance = 0.00001 (uS)
}

STATE { gates_z_q }

INITIAL {
  LOCAL gates_z_steadyState_ca_conc, gates_z_steadyState_x

  gates_z_steadyState_ca_conc = 0.000001 * cai
  gates_z_steadyState_x = (1 + (0.0000000004300000078227839 * gates_z_steadyState_ca_conc^-1)^4.800000190734863)^-1
  gates_z_q = gates_z_steadyState_x
}

DERIVATIVE dstate {
  LOCAL gates_z_steadyState_ca_conc, gates_z_steadyState_x

  gates_z_steadyState_ca_conc = 0.000001 * cai
  gates_z_steadyState_x = (1 + (0.0000000004300000078227839 * gates_z_steadyState_ca_conc^-1)^4.800000190734863)^-1
  gates_z_q' = gates_z_steadyState_x + -1 * gates_z_q
}

BREAKPOINT {
  SOLVE dstate METHOD cnexp
  LOCAL g

  g = conductance * gates_z_q
  ik = g * (v + -1 * ek)
}

