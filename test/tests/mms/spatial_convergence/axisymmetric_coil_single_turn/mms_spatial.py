import mms

df1 = mms.run_spatial('/Users/vc6725/projects/orpheus/test/tests/mms/spatial_convergence/axisymmetric_coil_single_turn/mms_spatial.i', 4, console=False)
df2 = mms.run_spatial('/Users/vc6725/projects/orpheus/test/tests/mms/spatial_convergence/axisymmetric_coil_single_turn/mms_spatial.i', 4, 'Mesh/second_order=true', 'Variables/A/order=SECOND', console=False)

fig = mms.ConvergencePlot(xlabel='Element Size ($h$)', ylabel='$L_2$ Error')
fig.plot(df1, label='1st Order', marker='o', markersize=8)
fig.plot(df2, label='2nd Order', marker='o', markersize=8)
fig.save('/Users/vc6725/projects/orpheus/test/tests/mms/spatial_convergence/axisymmetric_coil_single_turn/mms_spatial.png')

df1.to_csv('/Users/vc6725/projects/orpheus/test/tests/mms/spatial_convergence/axisymmetric_coil_single_turn/mms_spatial_1st_order.csv')
df2.to_csv('/Users/vc6725/projects/orpheus/test/tests/mms/spatial_convergence/axisymmetric_coil_single_turn/mms_spatial_2nd_order.csv')