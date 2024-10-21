#include "orpheusApp.h"
#include "Moose.h"
#include "AppFactory.h"
#include "ModulesApp.h"
#include "MooseSyntax.h"

InputParameters
orpheusApp::validParams()
{
  InputParameters params = MooseApp::validParams();
  params.set<bool>("use_legacy_material_output") = false;
  params.set<bool>("use_legacy_initial_residual_evaluation_behavior") = false;
  return params;
}

orpheusApp::orpheusApp(InputParameters parameters) : MooseApp(parameters)
{
  orpheusApp::registerAll(_factory, _action_factory, _syntax);
}

orpheusApp::~orpheusApp() {}

void
orpheusApp::registerAll(Factory & f, ActionFactory & af, Syntax & s)
{
  ModulesApp::registerAllObjects<orpheusApp>(f, af, s);
  Registry::registerObjectsTo(f, {"orpheusApp"});
  Registry::registerActionsTo(af, {"orpheusApp"});

  /* register custom execute flags, action syntax, etc. here */
}

void
orpheusApp::registerApps()
{
  registerApp(orpheusApp);
}

/***************************************************************************************************
 *********************** Dynamic Library Entry Points - DO NOT MODIFY ******************************
 **************************************************************************************************/
extern "C" void
orpheusApp__registerAll(Factory & f, ActionFactory & af, Syntax & s)
{
  orpheusApp::registerAll(f, af, s);
}
extern "C" void
orpheusApp__registerApps()
{
  orpheusApp::registerApps();
}
