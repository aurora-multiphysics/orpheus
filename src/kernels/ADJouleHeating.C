//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#include "ADJouleHeating.h"
#include "Function.h"

registerMooseObject("orpheusApp", ADJouleHeating);

InputParameters
ADJouleHeating::validParams()
{
  InputParameters params = ADKernelValue::validParams();
  params.addParam<FunctionName>("current_density", "1", "A function that describes the current density");
  params.addParam<MaterialPropertyName>(
      "resistivity",
      1.77e-8,
      "Material property providing resistivity of the material.");
  params.addClassDescription("Calculates the heat source term corresponding to Joule "
                             "heating, with Jacobian contributions calculated using the automatic "
                             "differentiation system.");
  return params;
}

ADJouleHeating::ADJouleHeating(const InputParameters & parameters)
  : ADKernelValue(parameters),
    _current_density(getFunction("current_density")),
    _resistivity(getADMaterialProperty<Real>("resistivity")) 
{
} 

ADReal
ADJouleHeating::precomputeQpResidual()
{
  return -_resistivity[_qp] * Utility::pow<2>(_current_density.value(_t, _q_point[_qp]));
}
