//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#pragma once

#include "Material.h"

/**
 * Calculates resistivity as a function of temperature.
 * It is assumed that resistivity varies linearly with temperature.
 */
template <bool is_ad>
class ResistivityTempl : public Material
{
public:
  static InputParameters validParams();

  ResistivityTempl(const InputParameters & parameters); 

protected:
  virtual void computeQpProperties();

private:
  const Real _ref_resis;
  const Real _temp_coeff;
  const Real _ref_temp;
  const bool _has_temp;
  const GenericVariableValue<is_ad> & _T;

  const std::string _base_name;
  GenericMaterialProperty<Real, is_ad> & _resistivity;
  MaterialProperty<Real> & _dresistivity_dT;
};

typedef ResistivityTempl<false> Resistivity;
typedef ResistivityTempl<true> ADResistivity;
