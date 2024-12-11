#include "AxisymmetricDiffusion.h"

registerMooseObject("MooseApp", AxisymmetricDiffusion);

InputParameters
AxisymmetricDiffusion::validParams()
{
  MooseEnum component("x=0 y=1 z=2");
  InputParameters params = AuxKernel::validParams();
  params.addRequiredCoupledVar("gradient_variable",
                               "The variable from which to compute the gradient component");
  params.addParam<MooseEnum>("component", component, "The gradient component to compute");
  return params;
}

AxisymmetricDiffusion::AxisymmetricDiffusion(const InputParameters & parameters) : AuxKernel(parameters),
_gradient(coupledGradient("gradient_variable")),
_component(getParam<MooseEnum>("component")) 
{}

Real
AxisymmetricDiffusion::computeValue()
{
  return (1/x)*_gradient[_qp](_component);
}