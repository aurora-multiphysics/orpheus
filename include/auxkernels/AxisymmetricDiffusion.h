#pragma once

#include "AuxKernel.h"

class AxisymmetricDiffusion : public AuxKernel
{
public:
  static InputParameters validParams();

  AxisymmetricDiffusion(const InputParameters & parameters);

protected:
  virtual Real computeValue() override;

private:
  const VariableGradient & _gradient;

  int _component;
};




