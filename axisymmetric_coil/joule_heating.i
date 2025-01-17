[Mesh]
    [coil]
      type = FileMeshGenerator 
      file = axi_coil.e
    []
    coord_type = rz
    rz_coord_axis = y
  []
  
  [Problem] 
      type = FEProblem
  []
  
  [Kernels]
    [joule_heating] 
      type = ADJouleHeating #calculates Q = rho*J^2
      block = 2 #only the wire undergoes Joule heating due to presence of current density 
      variable = T
      current_density = J
    []
    [heat_conduction_tdot]
      type = ADHeatConductionTimeDerivative #implements density * specific_heat * dT/dt
      variable = T
    []
    [heat_conduction]
      type = ADHeatConduction #implements Q = -k*del(T)
      variable = T
    []
  []
  
  [BCs]
    [temp_edge]
      type = DirichletBC
      variable = T
      boundary = 'top left bottom right'
      value = 293.0
    []
    [convective_dissipation]
      type = ADConvectiveHeatFluxBC
      variable = T
      boundary = 'wire_edge'
      T_infinity = 293.0
      heat_transfer_coefficient = 10
    []
    [radiative_dissipation]
      type = ADFunctionRadiativeBC
      variable = T
      boundary = 'wire_edge'
      emissivity_function = '0.03' #approximate emissivity of copper wire
    []
  []

  [Variables]
    [T]
      initial_condition = 293.0
    []
  []
  
  [Materials]
    [k_air]
      type = ADGenericConstantMaterial
      prop_names = 'thermal_conductivity'
      prop_values = '0.03' #air in W/(m K)
      block = 1 #air block
    []
    [cp_air]
      type = ADGenericConstantMaterial
      prop_names = 'specific_heat'
      prop_values = '1000' #air in J/(kg K)
      block = 1
    []
    [rho_air]
      type = ADGenericConstantMaterial
      prop_names = 'density'
      prop_values = '1.293' #air in kg/(m^3)
      block = 1
    []
    [k_copper]
      type = ADGenericConstantMaterial
      prop_names = 'thermal_conductivity'
      prop_values = '397.48' #copper in W/(m K)
      block = 2 #copper block
    []
    [cp_copper]
      type = ADGenericConstantMaterial
      prop_names = 'specific_heat'
      prop_values = '385.0' #copper in J/(kg K)
      block = 2
    []
    [rho_copper]
      type = ADGenericConstantMaterial
      prop_names = 'density'
      prop_values = '8920.0' #copper in kg/(m^3)
      block = 2
    []
    [resistivity_copper]
      type = ADResistivity 
      temperature = T
      block = 2
    []
  []

  [Functions]
    [J]
      type = ParsedFunction
      expression = 'J'
      symbol_names = 'J'
      symbol_values = '1e8' #current density
    []
  []

  [Preconditioning]
    [SMP]
      type = SMP
      full = true
    []
  []

  [Executioner]
    type = Transient
    steady_state_detection = true
    steady_state_tolerance = 1e-5
    scheme = bdf2
    solve_type = NEWTON
    petsc_options_iname = '-pc_type'
    petsc_options_value = 'hypre'
    dt = 5
    end_time = 100
    automatic_scaling = true
  []
  
  [Outputs]
    exodus = true
  []