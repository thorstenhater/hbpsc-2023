NEURON {
  SUFFIX L5PC_apical_dends
  USEION ca WRITE ica READ cai, eca
  USEION k WRITE ik READ ek
  USEION na WRITE ina READ ena
  NONSPECIFIC_CURRENT i
  RANGE Ca_HVA_conductance, Ca_LVAst_conductance, Ih_conductance
}

PARAMETER {
  Ca_HVA_conductance = 0.00001 (uS)
  Ca_LVAst_conductance = 0.00001 (uS)
  Ih_conductance = 0.00001 (uS)
}

STATE { Ca_HVA_gates_h_q Ca_HVA_gates_m_q Ca_LVAst_gates_h_q Ca_LVAst_gates_m_q Ih_gates_m_q Im_gates_m_q NaTa_t_gates_h_q NaTa_t_gates_m_q SK_E2_gates_z_q SKv3_1_gates_m_q }

INITIAL {
  LOCAL SKv3_1_gates_m_steadyState_x, SK_E2_gates_z_steadyState_ca_conc, SK_E2_gates_z_steadyState_x, NaTa_t_gates_m_reverseRate_x, NaTa_t_gates_m_reverseRate_r, NaTa_t_gates_m_forwardRate_x, NaTa_t_gates_m_forwardRate_r, NaTa_t_gates_m_inf, NaTa_t_gates_h_reverseRate_x, NaTa_t_gates_h_reverseRate_r, NaTa_t_gates_h_forwardRate_x, NaTa_t_gates_h_forwardRate_r, NaTa_t_gates_h_inf, Im_gates_m_forwardRate_r, Im_gates_m_reverseRate_r, Im_gates_m_inf, Ih_gates_m_reverseRate_r, Ih_gates_m_forwardRate_x, Ih_gates_m_forwardRate_r, Ih_gates_m_inf, Ca_LVAst_gates_m_steadyState_x, Ca_LVAst_gates_h_steadyState_x, Ca_HVA_gates_m_reverseRate_r, Ca_HVA_gates_m_forwardRate_x, Ca_HVA_gates_m_forwardRate_r, Ca_HVA_gates_m_inf, Ca_HVA_gates_h_forwardRate_r, Ca_HVA_gates_h_reverseRate_r, Ca_HVA_gates_h_inf

  SKv3_1_gates_m_steadyState_x = (1 + exp(-0.10309278553230808 * (-18.700000762939453 + v)))^-1
  SK_E2_gates_z_steadyState_ca_conc = 0.000001 * cai
  SK_E2_gates_z_steadyState_x = (1 + (0.0000000004300000078227839 * SK_E2_gates_z_steadyState_ca_conc^-1)^4.800000190734863)^-1
  NaTa_t_gates_m_reverseRate_x = -0.16666666666666666 * (38 + v)
  if (NaTa_t_gates_m_reverseRate_x != 0) {
    NaTa_t_gates_m_reverseRate_r = 0.7440000176429749 * NaTa_t_gates_m_reverseRate_x * (1 + -1 * exp(-1 * NaTa_t_gates_m_reverseRate_x))^-1
  } else {
    if (NaTa_t_gates_m_reverseRate_x == 0) {
      NaTa_t_gates_m_reverseRate_r = 0.7440000176429749
    } else {
      NaTa_t_gates_m_reverseRate_r = 0
    }
  }
  NaTa_t_gates_m_forwardRate_x = 0.16666666666666666 * (38 + v)
  if (NaTa_t_gates_m_forwardRate_x != 0) {
    NaTa_t_gates_m_forwardRate_r = 1.0920000076293945 * NaTa_t_gates_m_forwardRate_x * (1 + -1 * exp(-1 * NaTa_t_gates_m_forwardRate_x))^-1
  } else {
    if (NaTa_t_gates_m_forwardRate_x == 0) {
      NaTa_t_gates_m_forwardRate_r = 1.0920000076293945
    } else {
      NaTa_t_gates_m_forwardRate_r = 0
    }
  }
  NaTa_t_gates_m_inf = NaTa_t_gates_m_forwardRate_r * (NaTa_t_gates_m_forwardRate_r + NaTa_t_gates_m_reverseRate_r)^-1
  NaTa_t_gates_h_reverseRate_x = 0.16666666666666666 * (66 + v)
  if (NaTa_t_gates_h_reverseRate_x != 0) {
    NaTa_t_gates_h_reverseRate_r = 0.09000000357627869 * NaTa_t_gates_h_reverseRate_x * (1 + -1 * exp(-1 * NaTa_t_gates_h_reverseRate_x))^-1
  } else {
    if (NaTa_t_gates_h_reverseRate_x == 0) {
      NaTa_t_gates_h_reverseRate_r = 0.09000000357627869
    } else {
      NaTa_t_gates_h_reverseRate_r = 0
    }
  }
  NaTa_t_gates_h_forwardRate_x = -0.16666666666666666 * (66 + v)
  if (NaTa_t_gates_h_forwardRate_x != 0) {
    NaTa_t_gates_h_forwardRate_r = 0.09000000357627869 * NaTa_t_gates_h_forwardRate_x * (1 + -1 * exp(-1 * NaTa_t_gates_h_forwardRate_x))^-1
  } else {
    if (NaTa_t_gates_h_forwardRate_x == 0) {
      NaTa_t_gates_h_forwardRate_r = 0.09000000357627869
    } else {
      NaTa_t_gates_h_forwardRate_r = 0
    }
  }
  NaTa_t_gates_h_inf = NaTa_t_gates_h_forwardRate_r * (NaTa_t_gates_h_forwardRate_r + NaTa_t_gates_h_reverseRate_r)^-1
  Im_gates_m_forwardRate_r = 0.0032999999821186066 * exp(0.1 * (35 + v))
  Im_gates_m_reverseRate_r = 0.0032999999821186066 * exp(-0.1 * (35 + v))
  Im_gates_m_inf = Im_gates_m_forwardRate_r * (Im_gates_m_forwardRate_r + Im_gates_m_reverseRate_r)^-1
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
  Ca_LVAst_gates_m_steadyState_x = (1 + exp(-0.16666666666666666 * (40 + v)))^-1
  Ca_LVAst_gates_h_steadyState_x = (1 + exp(0.1562499976716936 * (90 + v)))^-1
  Ca_HVA_gates_m_reverseRate_r = 0.9399999976158142 * exp(-0.058823529411764705 * (75 + v))
  Ca_HVA_gates_m_forwardRate_x = 0.26315789803903855 * (27 + v)
  if (Ca_HVA_gates_m_forwardRate_x != 0) {
    Ca_HVA_gates_m_forwardRate_r = 0.20900000631809235 * Ca_HVA_gates_m_forwardRate_x * (1 + -1 * exp(-1 * Ca_HVA_gates_m_forwardRate_x))^-1
  } else {
    if (Ca_HVA_gates_m_forwardRate_x == 0) {
      Ca_HVA_gates_m_forwardRate_r = 0.20900000631809235
    } else {
      Ca_HVA_gates_m_forwardRate_r = 0
    }
  }
  Ca_HVA_gates_m_inf = Ca_HVA_gates_m_forwardRate_r * (Ca_HVA_gates_m_forwardRate_r + Ca_HVA_gates_m_reverseRate_r)^-1
  Ca_HVA_gates_h_forwardRate_r = 0.0004569999873638153 * exp(-0.02 * (13 + v))
  Ca_HVA_gates_h_reverseRate_r = 0.006500000134110451 * (1 + exp(-0.03571428571428571 * (15 + v)))^-1
  Ca_HVA_gates_h_inf = Ca_HVA_gates_h_forwardRate_r * (Ca_HVA_gates_h_forwardRate_r + Ca_HVA_gates_h_reverseRate_r)^-1
  Ca_HVA_gates_h_q = Ca_HVA_gates_h_inf
  Ca_HVA_gates_m_q = Ca_HVA_gates_m_inf
  Ca_LVAst_gates_h_q = Ca_LVAst_gates_h_steadyState_x
  Ca_LVAst_gates_m_q = Ca_LVAst_gates_m_steadyState_x
  Ih_gates_m_q = Ih_gates_m_inf
  Im_gates_m_q = Im_gates_m_inf
  NaTa_t_gates_h_q = NaTa_t_gates_h_inf
  NaTa_t_gates_m_q = NaTa_t_gates_m_inf
  SK_E2_gates_z_q = SK_E2_gates_z_steadyState_x
  SKv3_1_gates_m_q = SKv3_1_gates_m_steadyState_x
}

DERIVATIVE dstate {
  LOCAL SKv3_1_gates_m_steadyState_x, SKv3_1_gates_m_timeCourse_t, SK_E2_gates_z_steadyState_ca_conc, SK_E2_gates_z_steadyState_x, NaTa_t_gates_m_reverseRate_x, NaTa_t_gates_m_reverseRate_r, NaTa_t_gates_m_forwardRate_x, NaTa_t_gates_m_forwardRate_r, NaTa_t_gates_m_inf, NaTa_t_gates_m_tau, NaTa_t_gates_h_reverseRate_x, NaTa_t_gates_h_reverseRate_r, NaTa_t_gates_h_forwardRate_x, NaTa_t_gates_h_forwardRate_r, NaTa_t_gates_h_inf, NaTa_t_gates_h_tau, Im_gates_m_forwardRate_r, Im_gates_m_reverseRate_r, Im_gates_m_inf, Im_gates_m_tau, Ih_gates_m_reverseRate_r, Ih_gates_m_forwardRate_x, Ih_gates_m_forwardRate_r, Ih_gates_m_inf, Ih_gates_m_tau, Ca_LVAst_gates_m_steadyState_x, Ca_LVAst_gates_m_timeCourse_t, Ca_LVAst_gates_m_tau, Ca_LVAst_gates_h_steadyState_x, Ca_LVAst_gates_h_timeCourse_t, Ca_LVAst_gates_h_tau, Ca_HVA_gates_m_reverseRate_r, Ca_HVA_gates_m_forwardRate_x, Ca_HVA_gates_m_forwardRate_r, Ca_HVA_gates_m_inf, Ca_HVA_gates_m_tau, Ca_HVA_gates_h_forwardRate_r, Ca_HVA_gates_h_reverseRate_r, Ca_HVA_gates_h_inf, Ca_HVA_gates_h_tau

  SKv3_1_gates_m_steadyState_x = (1 + exp(-0.10309278553230808 * (-18.700000762939453 + v)))^-1
  SKv3_1_gates_m_timeCourse_t = 4 * (1 + exp(-0.022655188351328265 * (46.560001373291016 + v)))^-1
  SK_E2_gates_z_steadyState_ca_conc = 0.000001 * cai
  SK_E2_gates_z_steadyState_x = (1 + (0.0000000004300000078227839 * SK_E2_gates_z_steadyState_ca_conc^-1)^4.800000190734863)^-1
  NaTa_t_gates_m_reverseRate_x = -0.16666666666666666 * (38 + v)
  if (NaTa_t_gates_m_reverseRate_x != 0) {
    NaTa_t_gates_m_reverseRate_r = 0.7440000176429749 * NaTa_t_gates_m_reverseRate_x * (1 + -1 * exp(-1 * NaTa_t_gates_m_reverseRate_x))^-1
  } else {
    if (NaTa_t_gates_m_reverseRate_x == 0) {
      NaTa_t_gates_m_reverseRate_r = 0.7440000176429749
    } else {
      NaTa_t_gates_m_reverseRate_r = 0
    }
  }
  NaTa_t_gates_m_forwardRate_x = 0.16666666666666666 * (38 + v)
  if (NaTa_t_gates_m_forwardRate_x != 0) {
    NaTa_t_gates_m_forwardRate_r = 1.0920000076293945 * NaTa_t_gates_m_forwardRate_x * (1 + -1 * exp(-1 * NaTa_t_gates_m_forwardRate_x))^-1
  } else {
    if (NaTa_t_gates_m_forwardRate_x == 0) {
      NaTa_t_gates_m_forwardRate_r = 1.0920000076293945
    } else {
      NaTa_t_gates_m_forwardRate_r = 0
    }
  }
  NaTa_t_gates_m_inf = NaTa_t_gates_m_forwardRate_r * (NaTa_t_gates_m_forwardRate_r + NaTa_t_gates_m_reverseRate_r)^-1
  NaTa_t_gates_m_tau = (2.9528825283050537 * (NaTa_t_gates_m_forwardRate_r + NaTa_t_gates_m_reverseRate_r))^-1
  NaTa_t_gates_h_reverseRate_x = 0.16666666666666666 * (66 + v)
  if (NaTa_t_gates_h_reverseRate_x != 0) {
    NaTa_t_gates_h_reverseRate_r = 0.09000000357627869 * NaTa_t_gates_h_reverseRate_x * (1 + -1 * exp(-1 * NaTa_t_gates_h_reverseRate_x))^-1
  } else {
    if (NaTa_t_gates_h_reverseRate_x == 0) {
      NaTa_t_gates_h_reverseRate_r = 0.09000000357627869
    } else {
      NaTa_t_gates_h_reverseRate_r = 0
    }
  }
  NaTa_t_gates_h_forwardRate_x = -0.16666666666666666 * (66 + v)
  if (NaTa_t_gates_h_forwardRate_x != 0) {
    NaTa_t_gates_h_forwardRate_r = 0.09000000357627869 * NaTa_t_gates_h_forwardRate_x * (1 + -1 * exp(-1 * NaTa_t_gates_h_forwardRate_x))^-1
  } else {
    if (NaTa_t_gates_h_forwardRate_x == 0) {
      NaTa_t_gates_h_forwardRate_r = 0.09000000357627869
    } else {
      NaTa_t_gates_h_forwardRate_r = 0
    }
  }
  NaTa_t_gates_h_inf = NaTa_t_gates_h_forwardRate_r * (NaTa_t_gates_h_forwardRate_r + NaTa_t_gates_h_reverseRate_r)^-1
  NaTa_t_gates_h_tau = (2.9528825283050537 * (NaTa_t_gates_h_forwardRate_r + NaTa_t_gates_h_reverseRate_r))^-1
  Im_gates_m_forwardRate_r = 0.0032999999821186066 * exp(0.1 * (35 + v))
  Im_gates_m_reverseRate_r = 0.0032999999821186066 * exp(-0.1 * (35 + v))
  Im_gates_m_inf = Im_gates_m_forwardRate_r * (Im_gates_m_forwardRate_r + Im_gates_m_reverseRate_r)^-1
  Im_gates_m_tau = (2.9528825283050537 * (Im_gates_m_forwardRate_r + Im_gates_m_reverseRate_r))^-1
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
  Ca_LVAst_gates_m_steadyState_x = (1 + exp(-0.16666666666666666 * (40 + v)))^-1
  Ca_LVAst_gates_m_timeCourse_t = 5 + 20 * (1 + exp(0.2 * (35 + v)))^-1
  Ca_LVAst_gates_m_tau = 0.3386521442740891 * Ca_LVAst_gates_m_timeCourse_t
  Ca_LVAst_gates_h_steadyState_x = (1 + exp(0.1562499976716936 * (90 + v)))^-1
  Ca_LVAst_gates_h_timeCourse_t = 20 + 50 * (1 + exp(0.14285714285714285 * (50 + v)))^-1
  Ca_LVAst_gates_h_tau = 0.3386521442740891 * Ca_LVAst_gates_h_timeCourse_t
  Ca_HVA_gates_m_reverseRate_r = 0.9399999976158142 * exp(-0.058823529411764705 * (75 + v))
  Ca_HVA_gates_m_forwardRate_x = 0.26315789803903855 * (27 + v)
  if (Ca_HVA_gates_m_forwardRate_x != 0) {
    Ca_HVA_gates_m_forwardRate_r = 0.20900000631809235 * Ca_HVA_gates_m_forwardRate_x * (1 + -1 * exp(-1 * Ca_HVA_gates_m_forwardRate_x))^-1
  } else {
    if (Ca_HVA_gates_m_forwardRate_x == 0) {
      Ca_HVA_gates_m_forwardRate_r = 0.20900000631809235
    } else {
      Ca_HVA_gates_m_forwardRate_r = 0
    }
  }
  Ca_HVA_gates_m_inf = Ca_HVA_gates_m_forwardRate_r * (Ca_HVA_gates_m_forwardRate_r + Ca_HVA_gates_m_reverseRate_r)^-1
  Ca_HVA_gates_m_tau = (Ca_HVA_gates_m_forwardRate_r + Ca_HVA_gates_m_reverseRate_r)^-1
  Ca_HVA_gates_h_forwardRate_r = 0.0004569999873638153 * exp(-0.02 * (13 + v))
  Ca_HVA_gates_h_reverseRate_r = 0.006500000134110451 * (1 + exp(-0.03571428571428571 * (15 + v)))^-1
  Ca_HVA_gates_h_inf = Ca_HVA_gates_h_forwardRate_r * (Ca_HVA_gates_h_forwardRate_r + Ca_HVA_gates_h_reverseRate_r)^-1
  Ca_HVA_gates_h_tau = (Ca_HVA_gates_h_forwardRate_r + Ca_HVA_gates_h_reverseRate_r)^-1
  Ca_HVA_gates_h_q' = (Ca_HVA_gates_h_inf + -1 * Ca_HVA_gates_h_q) * Ca_HVA_gates_h_tau^-1
  Ca_HVA_gates_m_q' = (Ca_HVA_gates_m_inf + -1 * Ca_HVA_gates_m_q) * Ca_HVA_gates_m_tau^-1
  Ca_LVAst_gates_h_q' = (Ca_LVAst_gates_h_steadyState_x + -1 * Ca_LVAst_gates_h_q) * Ca_LVAst_gates_h_tau^-1
  Ca_LVAst_gates_m_q' = (Ca_LVAst_gates_m_steadyState_x + -1 * Ca_LVAst_gates_m_q) * Ca_LVAst_gates_m_tau^-1
  Ih_gates_m_q' = (Ih_gates_m_inf + -1 * Ih_gates_m_q) * Ih_gates_m_tau^-1
  Im_gates_m_q' = (Im_gates_m_inf + -1 * Im_gates_m_q) * Im_gates_m_tau^-1
  NaTa_t_gates_h_q' = (NaTa_t_gates_h_inf + -1 * NaTa_t_gates_h_q) * NaTa_t_gates_h_tau^-1
  NaTa_t_gates_m_q' = (NaTa_t_gates_m_inf + -1 * NaTa_t_gates_m_q) * NaTa_t_gates_m_tau^-1
  SK_E2_gates_z_q' = SK_E2_gates_z_steadyState_x + -1 * SK_E2_gates_z_q
  SKv3_1_gates_m_q' = (SKv3_1_gates_m_steadyState_x + -1 * SKv3_1_gates_m_q) * SKv3_1_gates_m_timeCourse_t^-1
}

BREAKPOINT {
  SOLVE dstate METHOD cnexp
  LOCAL NaTa_t_gates_m_fcond, NaTa_t_fopen0, NaTa_t_g, g_na, Im_g, SK_E2_g, SKv3_1_g, g_k, Ca_LVAst_gates_m_fcond, Ca_LVAst_fopen0, Ca_LVAst_g, Ca_HVA_gates_m_fcond, Ca_HVA_fopen0, Ca_HVA_g, g_ca, Ih_g

  NaTa_t_gates_m_fcond = NaTa_t_gates_m_q * NaTa_t_gates_m_q * NaTa_t_gates_m_q
  NaTa_t_fopen0 = NaTa_t_gates_h_q * NaTa_t_gates_m_fcond
  NaTa_t_g = 0.02129999923706055 * NaTa_t_fopen0
  g_na = NaTa_t_g
  Im_g = 0.00006750000268220902 * Im_gates_m_q
  SK_E2_g = 0.0012000000476837158 * SK_E2_gates_z_q
  SKv3_1_g = 0.00026100000739097596 * SKv3_1_gates_m_q
  g_k = Im_g + SK_E2_g + SKv3_1_g
  Ca_LVAst_gates_m_fcond = Ca_LVAst_gates_m_q * Ca_LVAst_gates_m_q
  Ca_LVAst_fopen0 = Ca_LVAst_gates_h_q * Ca_LVAst_gates_m_fcond
  Ca_LVAst_g = Ca_LVAst_conductance * Ca_LVAst_fopen0
  Ca_HVA_gates_m_fcond = Ca_HVA_gates_m_q * Ca_HVA_gates_m_q
  Ca_HVA_fopen0 = Ca_HVA_gates_h_q * Ca_HVA_gates_m_fcond
  Ca_HVA_g = Ca_HVA_conductance * Ca_HVA_fopen0
  g_ca = Ca_HVA_g + Ca_LVAst_g
  Ih_g = Ih_conductance * Ih_gates_m_q
  i = 0.00005889999866485596 * (90 + v) + Ih_g * (45 + v)
  ica = g_ca * (v + -1 * eca)
  ik = g_k * (v + -1 * ek)
  ina = g_na * (v + -1 * ena)
}

