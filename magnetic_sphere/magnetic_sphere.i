[Mesh]
  type = ExclusiveMFEMMesh
  file = ./magnetic_sphere.e
[]

[Problem]
  type = MFEMProblem
[]

[Formulation]
  type = MagnetostaticFormulation
  magnetic_vector_potential_name = magnetic_vector_potential
  magnetic_reluctivity_name = magnetic_reluctivity
  magnetic_permeability_name = magnetic_permeability

  magnetic_flux_density_name = magnetic_flux_density
  # current_density_name = source_current_density
  external_current_density_name = source_current_density
  lorentz_force_density_name = lorentz_force_density
[]

[FESpaces]
  [H1FESpace]
    type = MFEMFESpace
    fespace_type = H1
    order = FIRST
  []
  [HCurlFESpace]
    type = MFEMFESpace
    fespace_type = ND
    order = FIRST
  []
  [HDivFESpace]
    type = MFEMFESpace
    fespace_type = RT
    order = CONSTANT
  []
  [VectorL2FESpace]
    type = MFEMFESpace
    fespace_type = L2
    vdim = 3
    order = CONSTANT
  []  
[]

[AuxVariables]
  [magnetic_vector_potential]
    type = MFEMVariable
    fespace = HCurlFESpace
  []
  [magnetic_flux_density]
    type = MFEMVariable
    fespace = HDivFESpace
  []
  [source_current_density]
    type = MFEMVariable
    fespace = HDivFESpace
  []
  [source_electric_field]
    type = MFEMVariable
    fespace = HCurlFESpace
  []
  [source_electric_potential]
    type = MFEMVariable
    fespace = H1FESpace
  []
  [total_current_density]
    type = MFEMVariable
    fespace = HDivFESpace
  []
  [lorentz_force_density]
    type = MFEMVariable
    fespace = VectorL2FESpace
  []  
[]

[Sources]
  [SourceCoil]
    type = MFEMClosedCoilSource
    total_current_coefficient = CurrentCoef
    source_current_density_gridfunction = source_current_density
    source_electric_field_gridfunction = source_electric_field
    hcurl_fespace = HCurlFESpace
    h1_fespace = H1FESpace
    coil_xsection_boundary = 2
    block = '2 5'
  []
[]

[Materials]
  [coil]
    type = MFEMConductor
    electrical_conductivity_coeff = SphereEConductivity
    electric_permittivity_coeff = SpherePermittivity
    magnetic_permeability_coeff = SpherePermeability
    block = '2 5'
  []
  [void]
    type = MFEMConductor
    electrical_conductivity_coeff = VoidEConductivity
    electric_permittivity_coeff = VoidPermittivity
    magnetic_permeability_coeff = VoidPermeability
    block = '1 2 4 5'
  []
  [hollow_sphere]
    type = MFEMConductor
    electrical_conductivity_coeff = SphereEConductivity
    electric_permittivity_coeff = SpherePermittivity
    magnetic_permeability_coeff = SpherePermeability
    block = 3
  []
[]

[Coefficients]
  [VoidEConductivity]
    type = MFEMConstantCoefficient
    value = 1.0 # S/m
  []
  [VoidPermeability]
    type = MFEMConstantCoefficient
    value = 1.25663706e-6 # T m/A
  []
  [VoidPermittivity]
    type = MFEMConstantCoefficient
    value = 0.0 # (dummy value for A form)
  []
  [SphereEConductivity]
    type = MFEMConstantCoefficient
    value = 3.526e7 # S/m
  []
  [SpherePermeability]
    type = MFEMConstantCoefficient
    value = 6.2831853e-4 # T m/A
  []
  [SpherePermittivity]
    type = MFEMConstantCoefficient
    value = 0.0 # (dummy value for A form)
  []
  [CurrentCoef]
    type = MFEMConstantCoefficient
    value = 20000 # A
  []
[]

[Executioner]
  type = Steady
  l_tol = 1e-16
  l_max_its = 1000
[]

[Outputs]
  [ParaViewDataCollection]
    type = MFEMParaViewDataCollection
    file_base = OutputData/SphereMagnetostatic
  []
[]
