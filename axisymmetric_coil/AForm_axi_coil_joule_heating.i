[Mesh]
    [coil]
      type = FileMeshGenerator 
      file = axi_coil.e
    []
    [tmg]
      type = TiledMeshGenerator
      input = coil
      left_boundary = left
      right_boundary = right
      top_boundary = top
      bottom_boundary = bottom
      x_tiles = 1
      y_tiles = 1   #change to number of turns in coil
    []
    coord_type = rz
    rz_coord_axis = y
  []
  
  [Problem]
      type = FEProblem
  []
  
  [Kernels]
    [laplacian_A] # d2A/dz2 = 0
      type = ADDiffusion
      variable = A
    []
    [body_force] # d2A/dz2 = J*mu_0
      type = ADBodyForce
      variable = A
      block = '2'
      value = '1.257e-6' # mu_0
      function = 'J'
    []
    [joule_heating] 
      type = ADJouleHeating #calculates Q = rho*J^2
      block = 2 #only the wire undergoes Joule heating due to presence of current density 
      variable = T
      resistivity = resistivity
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
    [A_edge]
      type = DirichletBC
      variable = A
      boundary = 'top left bottom right'
      value = 0
    []
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

  [AuxKernels]
    [dAdx_aux]
      type = VariableGradientComponent
      variable = dAdx
      component = x 
      gradient_variable = A
    []
    [dAdy_aux]
      type = VariableGradientComponent
      variable = dAdy
      component = y
      gradient_variable = A
    []
    [mag_B_aux]
      type = ParsedAux
      variable = mag_B
      coupled_variables = 'dAdx dAdy'
      expression = 'sqrt(dAdx^2 + dAdy^2)'
    []
    [Bx_unit_aux]
      type = ParsedAux
      variable = Bx_unit
      coupled_variables = 'dAdy mag_B'
      expression = 'dAdy / mag_B'
    []
    [By_unit_aux]
      type = ParsedAux
      variable = By_unit
      coupled_variables = 'dAdx mag_B'
      expression = '-dAdx / mag_B'
    []
  []
  
  [AuxVariables]
    [dAdx]
      family = MONOMIAL
    []
    [dAdy]
      family = MONOMIAL
    []
    [mag_B]
      family = MONOMIAL
    []
    [Bx_unit]
      family = MONOMIAL
    []
    [By_unit]
      family = MONOMIAL
    []
  []

  [Variables]
    [A]
    []
    [T]
      initial_condition = 293.0
    []
  []

  [Materials]
    [k_air]
      type = ADGenericConstantMaterial
      prop_names = 'thermal_conductivity'
      prop_values = '0.03' #air in W/(m K)
      block = 1
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
      block = 2
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
      reference_resistivity = 1.68e-8
      temperature_coefficient = 0.00386
      reference_temperature = 293.0
      block = 2
    []
  []
  
  [Functions]
    [J]
      type = ParsedFunction
      expression = 'J'
      symbol_names = 'J'
      symbol_values = '1e8'
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
    dt = 100
    end_time = 2000
    automatic_scaling = true
  []
  
  [Outputs]
    exodus = true
  []