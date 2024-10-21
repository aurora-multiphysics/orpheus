[Mesh]
  [wire]
    type = CartesianMeshGenerator
    dim = 2
    dx = '4.5 1 4.5'
    dy = '20'
    subdomain_id = '1 2 3'
  []
[]

[Problem]
    type = FEProblem
[]

[Kernels]
  [curl_curl_A] # ∇x(∇xA)
    type = CurlCurlField
    variable = A
  []

  [body_force] # ∇x(∇xA) = mu*J
    type = VectorBodyForce
    variable = A
    block = 2
    value = '1.2566370614e-6'
    function = 'J'
  []
[]

[Variables]
  [A]
    family = LAGRANGE_VEC
  []
[]

[Functions]
  [J]
    type = ParsedVectorFunction
    expression_x = 0
    expression_y = 'J'
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

