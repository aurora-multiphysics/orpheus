  [Mesh]
    [wire]
      type = FileMeshGenerator 
      file = wire_normal.e
    []
  []
  
  [Problem]
      type = FEProblem
  []
  
  [Kernels]
    [laplacian_A] # d2A/dz2 = 0
      type = ADDiffusion
      variable = A
    []
  
    [body_force] # d2A/dz2 = J/mu_0
      type = BodyForce
      variable = A
      block = 2
      value = '7.958e5' # 1/mu_0
      function = 'J'
    []

    [laplacian_A_vec] # d2A/dz2 = 0
      type = VectorDiffusion
      variable = A_vec
    []
  
    [body_force_A_vec] # d2A/dz2 = J/mu_0
      type = VectorBodyForce
      variable = A_vec
      block = 2
      value = '7.958e5' # 1/mu_0
      function_x = 0
      function_z = 'J'
    []

    [mag_B]
      type = BMagnitude
      variable = A_vec
    []
  []

  [BCs]
    [edge]
      type = DirichletBC
      variable = A
      boundary = 'top left bottom right'
      value = 0
    []
  []

  [Variables]
    [A]
    []
    [A_vec]
      type = VectorMooseVariable
      family = LAGRANGE_VEC
    []
  []
  
  [Functions]
    [J]
      type = ParsedFunction
      expression = 'J'
      symbol_names = 'J'
      symbol_values = '50'
    []
  []
  
  [Executioner]
    type = Steady
    solve_type = NEWTON
    petsc_options_iname = '-pc_type -pc_hypre_type'
    petsc_options_value = ' hypre    boomeramg'
  []
  
  [Outputs]
    exodus = true
  []
  
  