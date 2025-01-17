//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#pragma once

#include "ADKernelValue.h"

class Function;

/**
 * This kernel calculates the heat source term corresponding to joule heating,
 * Q = J * E = rho * J^2.
 */
class ADJouleHeating : public ADKernelValue
{
public:
  static InputParameters validParams();

  ADJouleHeating(const InputParameters & parameters);

protected:
  virtual ADReal precomputeQpResidual() override;

private:
  const Function & _current_density;

  const ADMaterialProperty<Real> & _resistivity;
};