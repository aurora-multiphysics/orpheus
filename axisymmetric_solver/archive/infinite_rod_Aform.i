[Mesh]
  type = GeneratedMesh
  dim = 2
  xmin = -10
  xmax = 10
  ymin = -10
  ymax = 10
  nx = 100
  ny = 100
[]

[Variables]
  [./A_x]
    order = FIRST
    family = LAGRANGE
  [../]
  [./A_y]
    order = FIRST
    family = LAGRANGE
  [../]
[]

[Kernels]
  [./curl_A_x]
    type = VectorCurl
    variable = A_x
  [../]
  [./curl_A_y]
    type = VectorCurl
    variable = A_y
  [../]
  [./current_source]
    type = Source
    variable = A_z
    value = '1.0'
    function = current_density
  [../]
[]

[BCs]
  [./left]
    type = DirichletBC
    variable = A_y
    boundary = left
    value = 0
  [../]
  [./right]
    type = DirichletBC
    variable = A_y
    boundary = right
    value = 0
  [../]
  [./bottom]
    type = DirichletBC
    variable = A_x
    boundary = bottom
    value = 0
  [../]
  [./top]
    type = DirichletBC
    variable = A_x
    boundary = top
    value = 0
  [../]
[]

[Functions]
  [./current_density]
    type = ParsedFunction
    value = '1.0'  # Define the current density value here
  [../]
[]

[Materials]
  [./mu]
    type = GenericConstantMaterial
    prop_names = 'mu'
    prop_values = '1.0'
  [../]
[]

[AuxVariables]
  [./B_x]
    order = FIRST
    family = LAGRANGE
  [../]
  [./B_y]
    order = FIRST
    family = LAGRANGE
  [../]
[]

[AuxKernels]
  [./Bx_aux]
    type = CurlAux
    variable = B_x
    field = A_y
  [../]
  [./By_aux]
    type = CurlAux
    variable = B_y
    field = A_x
  [../]
[]

[Executioner]
  type = Steady
  solve_type = 'NEWTON'
[]

[Outputs]
  exodus = true
[]
