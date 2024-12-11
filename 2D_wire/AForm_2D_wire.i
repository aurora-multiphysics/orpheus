  [Mesh]
    [wire]
      type = FileMeshGenerator 
      file = 2D_wire.e
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
    [body_force] # d2A/dz2 = J*mu_0
      type = BodyForce
      variable = A
      block = 2
      value = '1.256e-6' # mu_0
      function = 'J'
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
  []
  
  [Functions]
    [J]
      type = ParsedFunction
      expression = '1/(mu_0*(sqrt((x-2)^2+y^2)))'
      symbol_names = 'mu_0'
      symbol_values = 1.256e-6
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