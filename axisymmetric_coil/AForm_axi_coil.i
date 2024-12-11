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
      expression = 'J'
      symbol_names = 'J'
      symbol_values = '50'
    []
  []
  
  [Executioner]
    type = Steady
    automatic_scaling = true
    compute_scaling_once = false
    solve_type = NEWTON
    petsc_options_iname = '-pc_type -pc_factor_mat_solver_package'
    petsc_options_value = ' lu    mumps'
  []
  
  [Outputs]
    exodus = true
  []