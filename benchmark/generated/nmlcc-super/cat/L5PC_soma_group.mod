NEURON {
  SUFFIX L5PC_soma_group
  USEION ca WRITE ica READ cai, eca
  USEION k WRITE ik READ ek
  USEION na WRITE ina READ ena
  NONSPECIFIC_CURRENT i
  RANGE Ca_HVA_conductance, Ca_LVAst_conductance
}

PARAMETER {
  Ca_HVA_conductance = 0.0009919999837875366 (S_per_cm2)
  Ca_LVAst_conductance = 0.003430000066757202 (S_per_cm2)
}

STATE { Ca_HVA_gates_h_q Ca_HVA_gates_m_q Ca_LVAst_gates_h_q Ca_LVAst_gates_m_q K_Pst_gates_h_q K_Pst_gates_m_q K_Tst_gates_h_q K_Tst_gates_m_q NaTa_t_gates_h_q NaTa_t_gates_m_q Nap_Et2_gates_h_q Nap_Et2_gates_m_q SK_E2_gates_z_q SKv3_1_gates_m_q }

INITIAL {
  LOCAL SKv3_1_gates_m_steadyState_x, SK_E2_gates_z_steadyState_ca_conc, SK_E2_gates_z_steadyState_x, Nap_Et2_gates_m_steadyState_x, Nap_Et2_gates_h_steadyState_x, NaTa_t_gates_m_reverseRate_x, NaTa_t_gates_m_reverseRate_r, NaTa_t_gates_m_forwardRate_x, NaTa_t_gates_m_forwardRate_r, NaTa_t_gates_m_inf, NaTa_t_gates_h_reverseRate_x, NaTa_t_gates_h_reverseRate_r, NaTa_t_gates_h_forwardRate_x, NaTa_t_gates_h_forwardRate_r, NaTa_t_gates_h_inf, K_Tst_gates_m_steadyState_x, K_Tst_gates_h_steadyState_x, K_Pst_gates_m_steadyState_x, K_Pst_gates_h_steadyState_x, Ca_LVAst_gates_m_steadyState_x, Ca_LVAst_gates_h_steadyState_x, Ca_HVA_gates_m_reverseRate_r, Ca_HVA_gates_m_forwardRate_x, Ca_HVA_gates_m_forwardRate_r, Ca_HVA_gates_m_inf, Ca_HVA_gates_h_forwardRate_r, Ca_HVA_gates_h_reverseRate_r, Ca_HVA_gates_h_inf

  SKv3_1_gates_m_steadyState_x = (1 + exp(-0.10309278553230808 * (-18.700000762939453 + v)))^-1
  SK_E2_gates_z_steadyState_ca_conc = 0.000001 * cai
  SK_E2_gates_z_steadyState_x = (1 + (0.0000000004300000078227839 * SK_E2_gates_z_steadyState_ca_conc^-1)^4.800000190734863)^-1
  Nap_Et2_gates_m_steadyState_x = (1 + exp(-0.21739130885479366 * (52.599998474121094 + v)))^-1
  Nap_Et2_gates_h_steadyState_x = (1 + exp(0.1 * (48.79999923706055 + v)))^-1
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
  K_Tst_gates_m_steadyState_x = (1 + exp(-0.05263157894736842 * (10 + v)))^-1
  K_Tst_gates_h_steadyState_x = (1 + exp(0.1 * (76 + v)))^-1
  K_Pst_gates_m_steadyState_x = (1 + exp(-0.08333333333333333 * (11 + v)))^-1
  K_Pst_gates_h_steadyState_x = (1 + exp(0.09090909090909091 * (64 + v)))^-1
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
  K_Pst_gates_h_q = K_Pst_gates_h_steadyState_x
  K_Pst_gates_m_q = K_Pst_gates_m_steadyState_x
  K_Tst_gates_h_q = K_Tst_gates_h_steadyState_x
  K_Tst_gates_m_q = K_Tst_gates_m_steadyState_x
  NaTa_t_gates_h_q = NaTa_t_gates_h_inf
  NaTa_t_gates_m_q = NaTa_t_gates_m_inf
  Nap_Et2_gates_h_q = Nap_Et2_gates_h_steadyState_x
  Nap_Et2_gates_m_q = Nap_Et2_gates_m_steadyState_x
  SK_E2_gates_z_q = SK_E2_gates_z_steadyState_x
  SKv3_1_gates_m_q = SKv3_1_gates_m_steadyState_x
}

DERIVATIVE dstate {
  LOCAL SKv3_1_gates_m_steadyState_x, SKv3_1_gates_m_timeCourse_t, SK_E2_gates_z_steadyState_ca_conc, SK_E2_gates_z_steadyState_x, Nap_Et2_gates_m_steadyState_x, Nap_Et2_gates_m_reverseRate_x, Nap_Et2_gates_m_reverseRate_r, Nap_Et2_gates_m_forwardRate_x, Nap_Et2_gates_m_forwardRate_r, Nap_Et2_gates_m_timeCourse_t, Nap_Et2_gates_m_tau, Nap_Et2_gates_h_steadyState_x, Nap_Et2_gates_h_reverseRate_x, Nap_Et2_gates_h_reverseRate_r, Nap_Et2_gates_h_forwardRate_x, Nap_Et2_gates_h_forwardRate_r, Nap_Et2_gates_h_tau, NaTa_t_gates_m_reverseRate_x, NaTa_t_gates_m_reverseRate_r, NaTa_t_gates_m_forwardRate_x, NaTa_t_gates_m_forwardRate_r, NaTa_t_gates_m_inf, NaTa_t_gates_m_tau, NaTa_t_gates_h_reverseRate_x, NaTa_t_gates_h_reverseRate_r, NaTa_t_gates_h_forwardRate_x, NaTa_t_gates_h_forwardRate_r, NaTa_t_gates_h_inf, NaTa_t_gates_h_tau, K_Tst_gates_m_steadyState_x, K_Tst_gates_m_timeCourse_t, K_Tst_gates_m_tau, K_Tst_gates_h_steadyState_x, K_Tst_gates_h_timeCourse_t, K_Tst_gates_h_tau, K_Pst_gates_m_steadyState_x, K_Pst_gates_m_timeCourse_t, K_Pst_gates_m_tau, K_Pst_gates_h_steadyState_x, K_Pst_gates_h_timeCourse_t, K_Pst_gates_h_tau, Ca_LVAst_gates_m_steadyState_x, Ca_LVAst_gates_m_timeCourse_t, Ca_LVAst_gates_m_tau, Ca_LVAst_gates_h_steadyState_x, Ca_LVAst_gates_h_timeCourse_t, Ca_LVAst_gates_h_tau, Ca_HVA_gates_m_reverseRate_r, Ca_HVA_gates_m_forwardRate_x, Ca_HVA_gates_m_forwardRate_r, Ca_HVA_gates_m_inf, Ca_HVA_gates_m_tau, Ca_HVA_gates_h_forwardRate_r, Ca_HVA_gates_h_reverseRate_r, Ca_HVA_gates_h_inf, Ca_HVA_gates_h_tau

  SKv3_1_gates_m_steadyState_x = (1 + exp(-0.10309278553230808 * (-18.700000762939453 + v)))^-1
  SKv3_1_gates_m_timeCourse_t = 4 * (1 + exp(-0.022655188351328265 * (46.560001373291016 + v)))^-1
  SK_E2_gates_z_steadyState_ca_conc = 0.000001 * cai
  SK_E2_gates_z_steadyState_x = (1 + (0.0000000004300000078227839 * SK_E2_gates_z_steadyState_ca_conc^-1)^4.800000190734863)^-1
  Nap_Et2_gates_m_steadyState_x = (1 + exp(-0.21739130885479366 * (52.599998474121094 + v)))^-1
  Nap_Et2_gates_m_reverseRate_x = -0.16666666666666666 * (38 + v)
  if (Nap_Et2_gates_m_reverseRate_x != 0) {
    Nap_Et2_gates_m_reverseRate_r = 0.7440000176429749 * Nap_Et2_gates_m_reverseRate_x * (1 + -1 * exp(-1 * Nap_Et2_gates_m_reverseRate_x))^-1
  } else {
    if (Nap_Et2_gates_m_reverseRate_x == 0) {
      Nap_Et2_gates_m_reverseRate_r = 0.7440000176429749
    } else {
      Nap_Et2_gates_m_reverseRate_r = 0
    }
  }
  Nap_Et2_gates_m_forwardRate_x = 0.16666666666666666 * (38 + v)
  if (Nap_Et2_gates_m_forwardRate_x != 0) {
    Nap_Et2_gates_m_forwardRate_r = 1.0920000076293945 * Nap_Et2_gates_m_forwardRate_x * (1 + -1 * exp(-1 * Nap_Et2_gates_m_forwardRate_x))^-1
  } else {
    if (Nap_Et2_gates_m_forwardRate_x == 0) {
      Nap_Et2_gates_m_forwardRate_r = 1.0920000076293945
    } else {
      Nap_Et2_gates_m_forwardRate_r = 0
    }
  }
  if (Nap_Et2_gates_m_forwardRate_r + Nap_Et2_gates_m_reverseRate_r == 0) {
    Nap_Et2_gates_m_timeCourse_t = 0
  } else {
    if (Nap_Et2_gates_m_forwardRate_r + Nap_Et2_gates_m_reverseRate_r > 0) {
      Nap_Et2_gates_m_timeCourse_t = 6 * (Nap_Et2_gates_m_forwardRate_r + Nap_Et2_gates_m_reverseRate_r)^-1
    } else {
      Nap_Et2_gates_m_timeCourse_t = 0
    }
  }
  Nap_Et2_gates_m_tau = 0.3386521442740891 * Nap_Et2_gates_m_timeCourse_t
  Nap_Et2_gates_h_steadyState_x = (1 + exp(0.1 * (48.79999923706055 + v)))^-1
  Nap_Et2_gates_h_reverseRate_x = 0.38022812033701325 * (64.4000015258789 + v)
  if (Nap_Et2_gates_h_reverseRate_x != 0) {
    Nap_Et2_gates_h_reverseRate_r = 0.00001825219987949822 * Nap_Et2_gates_h_reverseRate_x * (1 + -1 * exp(-1 * Nap_Et2_gates_h_reverseRate_x))^-1
  } else {
    if (Nap_Et2_gates_h_reverseRate_x == 0) {
      Nap_Et2_gates_h_reverseRate_r = 0.00001825219987949822
    } else {
      Nap_Et2_gates_h_reverseRate_r = 0
    }
  }
  Nap_Et2_gates_h_forwardRate_x = -0.21598271604378827 * (17 + v)
  if (Nap_Et2_gates_h_forwardRate_x != 0) {
    Nap_Et2_gates_h_forwardRate_r = 0.000013334400136955082 * Nap_Et2_gates_h_forwardRate_x * (1 + -1 * exp(-1 * Nap_Et2_gates_h_forwardRate_x))^-1
  } else {
    if (Nap_Et2_gates_h_forwardRate_x == 0) {
      Nap_Et2_gates_h_forwardRate_r = 0.000013334400136955082
    } else {
      Nap_Et2_gates_h_forwardRate_r = 0
    }
  }
  Nap_Et2_gates_h_tau = (2.9528825283050537 * (Nap_Et2_gates_h_forwardRate_r + Nap_Et2_gates_h_reverseRate_r))^-1
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
  K_Tst_gates_m_steadyState_x = (1 + exp(-0.05263157894736842 * (10 + v)))^-1
  K_Tst_gates_m_timeCourse_t = 0.3400000035762787 + 0.9200000166893005 * exp(-1 * (0.01694915254237288 * (81 + v))^2)
  K_Tst_gates_m_tau = 0.3386521442740891 * K_Tst_gates_m_timeCourse_t
  K_Tst_gates_h_steadyState_x = (1 + exp(0.1 * (76 + v)))^-1
  K_Tst_gates_h_timeCourse_t = 8 + 49 * exp(-1 * (0.043478260869565216 * (83 + v))^2)
  K_Tst_gates_h_tau = 0.3386521442740891 * K_Tst_gates_h_timeCourse_t
  K_Pst_gates_m_steadyState_x = (1 + exp(-0.08333333333333333 * (11 + v)))^-1
  if (v < -60) {
    K_Pst_gates_m_timeCourse_t = 1.25 + 175.02999877929688 * exp(0.026000000536441803 * (10 + v))
  } else {
    K_Pst_gates_m_timeCourse_t = 1.25 + 13 * exp(-0.026000000536441803 * (10 + v))
  }
  K_Pst_gates_m_tau = 0.3386521442740891 * K_Pst_gates_m_timeCourse_t
  K_Pst_gates_h_steadyState_x = (1 + exp(0.09090909090909091 * (64 + v)))^-1
  K_Pst_gates_h_timeCourse_t = 360 + (1010 + 24 * (65 + v)) * exp(-0.00043402777777777775 * (85 + v)^2)
  K_Pst_gates_h_tau = 0.3386521442740891 * K_Pst_gates_h_timeCourse_t
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
  K_Pst_gates_h_q' = (K_Pst_gates_h_steadyState_x + -1 * K_Pst_gates_h_q) * K_Pst_gates_h_tau^-1
  K_Pst_gates_m_q' = (K_Pst_gates_m_steadyState_x + -1 * K_Pst_gates_m_q) * K_Pst_gates_m_tau^-1
  K_Tst_gates_h_q' = (K_Tst_gates_h_steadyState_x + -1 * K_Tst_gates_h_q) * K_Tst_gates_h_tau^-1
  K_Tst_gates_m_q' = (K_Tst_gates_m_steadyState_x + -1 * K_Tst_gates_m_q) * K_Tst_gates_m_tau^-1
  NaTa_t_gates_h_q' = (NaTa_t_gates_h_inf + -1 * NaTa_t_gates_h_q) * NaTa_t_gates_h_tau^-1
  NaTa_t_gates_m_q' = (NaTa_t_gates_m_inf + -1 * NaTa_t_gates_m_q) * NaTa_t_gates_m_tau^-1
  Nap_Et2_gates_h_q' = (Nap_Et2_gates_h_steadyState_x + -1 * Nap_Et2_gates_h_q) * Nap_Et2_gates_h_tau^-1
  Nap_Et2_gates_m_q' = (Nap_Et2_gates_m_steadyState_x + -1 * Nap_Et2_gates_m_q) * Nap_Et2_gates_m_tau^-1
  SK_E2_gates_z_q' = SK_E2_gates_z_steadyState_x + -1 * SK_E2_gates_z_q
  SKv3_1_gates_m_q' = (SKv3_1_gates_m_steadyState_x + -1 * SKv3_1_gates_m_q) * SKv3_1_gates_m_timeCourse_t^-1
}

BREAKPOINT {
  SOLVE dstate METHOD cnexp
  LOCAL Nap_Et2_gates_m_fcond, Nap_Et2_fopen0, Nap_Et2_g, NaTa_t_gates_m_fcond, NaTa_t_fopen0, NaTa_t_g, g_na, SK_E2_g, SKv3_1_g, K_Tst_gates_m_fcond, K_Tst_fopen0, K_Tst_g, K_Pst_gates_m_fcond, K_Pst_fopen0, K_Pst_g, g_k, Ca_LVAst_gates_m_fcond, Ca_LVAst_fopen0, Ca_LVAst_g, Ca_HVA_gates_m_fcond, Ca_HVA_fopen0, Ca_HVA_g, g_ca

  Nap_Et2_gates_m_fcond = Nap_Et2_gates_m_q * Nap_Et2_gates_m_q * Nap_Et2_gates_m_q
  Nap_Et2_fopen0 = Nap_Et2_gates_h_q * Nap_Et2_gates_m_fcond
  Nap_Et2_g = 0.0017200000286102296 * Nap_Et2_fopen0
  NaTa_t_gates_m_fcond = NaTa_t_gates_m_q * NaTa_t_gates_m_q * NaTa_t_gates_m_q
  NaTa_t_fopen0 = NaTa_t_gates_h_q * NaTa_t_gates_m_fcond
  NaTa_t_g = 2.04 * NaTa_t_fopen0
  g_na = NaTa_t_g + Nap_Et2_g
  SK_E2_g = 0.04409999847412109 * SK_E2_gates_z_q
  SKv3_1_g = 0.693 * SKv3_1_gates_m_q
  K_Tst_gates_m_fcond = K_Tst_gates_m_q * K_Tst_gates_m_q * K_Tst_gates_m_q * K_Tst_gates_m_q
  K_Tst_fopen0 = K_Tst_gates_h_q * K_Tst_gates_m_fcond
  K_Tst_g = 0.08119999694824219 * K_Tst_fopen0
  K_Pst_gates_m_fcond = K_Pst_gates_m_q * K_Pst_gates_m_q
  K_Pst_fopen0 = K_Pst_gates_h_q * K_Pst_gates_m_fcond
  K_Pst_g = 0.0022300000190734865 * K_Pst_fopen0
  g_k = K_Pst_g + K_Tst_g + SK_E2_g + SKv3_1_g
  Ca_LVAst_gates_m_fcond = Ca_LVAst_gates_m_q * Ca_LVAst_gates_m_q
  Ca_LVAst_fopen0 = Ca_LVAst_gates_h_q * Ca_LVAst_gates_m_fcond
  Ca_LVAst_g = Ca_LVAst_conductance * Ca_LVAst_fopen0
  Ca_HVA_gates_m_fcond = Ca_HVA_gates_m_q * Ca_HVA_gates_m_q
  Ca_HVA_fopen0 = Ca_HVA_gates_h_q * Ca_HVA_gates_m_fcond
  Ca_HVA_g = Ca_HVA_conductance * Ca_HVA_fopen0
  g_ca = Ca_HVA_g + Ca_LVAst_g
  i = 0.000033799998462200166 * (90 + v)
  ica = g_ca * (v + -1 * eca)
  ik = g_k * (v + -1 * ek)
  ina = g_na * (v + -1 * ena)
}

