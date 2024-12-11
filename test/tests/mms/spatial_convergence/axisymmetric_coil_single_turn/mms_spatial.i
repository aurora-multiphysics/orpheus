[Mesh]
    [coil]
      type = FileMeshGenerator 
      file = /Users/vc6725/projects/orpheus/axisymmetric_coil/axi_coil.e
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
      function = 'force'
    []
  []
  
  [BCs]
    [edge]
      type = FunctionDirichletBC
      variable = A
      boundary = 'top left bottom right'
      function = 'exact'
    []
  [] 

  [Variables]
    [A]
    []
  []
  
  [Functions]
    [exact]
      type = ParsedFunction
      expression = '-sin(2*x*pi)*sin(2*y*pi)'
    []
    [force]
      type = ParsedFunction
      expression = '(2*pi/x)*cos(2*pi*x)*sin(2*pi*y)-8*pi^2*sin(2*x*pi)*sin(2*y*pi)'
    []
  []

  [Postprocessors]
    [error]
      type = ElementL2Error
      function = exact
      variable = A
    []
    [h]
      type = AverageElementSize
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
    csv = true
  []