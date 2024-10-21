//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html
#include "orpheusTestApp.h"
#include "orpheusApp.h"
#include "Moose.h"
#include "AppFactory.h"
#include "MooseSyntax.h"

InputParameters
orpheusTestApp::validParams()
{
  InputParameters params = orpheusApp::validParams();
  params.set<bool>("use_legacy_material_output") = false;
  params.set<bool>("use_legacy_initial_residual_evaluation_behavior") = false;
  return params;
}

orpheusTestApp::orpheusTestApp(InputParameters parameters) : MooseApp(parameters)
{
  orpheusTestApp::registerAll(
      _factory, _action_factory, _syntax, getParam<bool>("allow_test_objects"));
}

orpheusTestApp::~orpheusTestApp() {}

void
orpheusTestApp::registerAll(Factory & f, ActionFactory & af, Syntax & s, bool use_test_objs)
{
  orpheusApp::registerAll(f, af, s);
  if (use_test_objs)
  {
    Registry::registerObjectsTo(f, {"orpheusTestApp"});
    Registry::registerActionsTo(af, {"orpheusTestApp"});
  }
}

void
orpheusTestApp::registerApps()
{
  registerApp(orpheusApp);
  registerApp(orpheusTestApp);
}

/***************************************************************************************************
 *********************** Dynamic Library Entry Points - DO NOT MODIFY ******************************
 **************************************************************************************************/
// External entry point for dynamic application loading
extern "C" void
orpheusTestApp__registerAll(Factory & f, ActionFactory & af, Syntax & s)
{
  orpheusTestApp::registerAll(f, af, s);
}
extern "C" void
orpheusTestApp__registerApps()
{
  orpheusTestApp::registerApps();
}
