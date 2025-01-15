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
  []
  
  [Problem]
      type = FEProblem
  []
  
  [Kernels]
    [joule_heating] 
      type = ADJouleHeatingSource
      block = 2
      variable = T
      elec = elec
    []
    [electric_potential]
      type = ADHeatConduction
      variable = elec
      thermal_conductivity = 0.025 # air in W/(m K)
    []
    [body_force]
      type = ADBodyForce
      variable = T
      block = 2
      value = 0
    []
    [heat_conduction]
      type = ADHeatConductionTimeDerivative
      variable = T
      block = 1
    []
  []
  
  [BCs]
    [edge]
      type = DirichletBC
      variable = T
      boundary = 'top left bottom right'
      value = 293.0
    []
    [elec_edge]
      type = DirichletBC
      boundary = 'wire_top wire_left wire_right wire_bottom'
      value = 1
      variable = elec
    []
  []

  [Variables]
    [T]
      initial_condition = 293.0
    []
    [elec]
    []
  []
  
  [Materials]
    [cp]
      type = ADGenericConstantMaterial
      prop_names = 'specific_heat'
      prop_values = '1000' #air in J/(kg K)
      block = 1
    []
    [rho]
      type = ADGenericConstantMaterial
      prop_names = 'density'
      prop_values = '1.293' #air in kg/(m^3)
      block = 1
    []
    [sigma] #copper is default material
      type = ADElectricalConductivity
      temperature = T
      block = 2
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
    scheme = bdf2
    solve_type = NEWTON
    petsc_options_iname = '-pc_type'
    petsc_options_value = 'hypre'
    dt = 0.2
    end_time = 1
    automatic_scaling = true
  []
  
  [Outputs]
    exodus = true
  []