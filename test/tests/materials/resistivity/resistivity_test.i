# Test for resistivity material property with copper as default values 

[Mesh]
    type = GeneratedMesh
    dim = 2
    nx = 2
    ny = 2
    xmax = 1
    ymax = 1
  []
  
  [Problem]
    solve = false
  []
  
  [Variables]
    [T]
    []
  []
  
  [Materials]
    [resistivity]
      type = Resistivity
      temperature = T
      reference_resistivity = 1.68e-8
      temperature_coefficient = 0.00386
      reference_temperature = 293.0
      output_properties = 'resistivity dresistivity_dT' 
      outputs = exodus
    []
  []
  
  [Executioner]
    type = Steady
  []
  
  [Outputs]
    exodus = true
  []