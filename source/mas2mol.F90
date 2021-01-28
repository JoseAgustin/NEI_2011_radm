
  integer,parameter :: evars=39
character(len=9),dimension(evars):: cem
real,dimension(evars):: wtm

cem=(/'E_CO   ','E_NH3  ','E_NO   ', 'E_NO2  ',&
'E_SO2  ','E_ALD  ','E_CH4  ','E_CSL  ','E_ETH  ','E_GLY  ', 'E_HC3  ',&
'E_HC5  ','E_HC8  ','E_HCHO ','E_ISO  ','E_KET  ','E_MACR ', 'E_MGLY ',&
'E_MVK  ','E_OL2  ','E_OLI  ','E_OLT  ','E_ORA1 ','E_ORA2 ', 'E_TOL  ',&
'E_XYL  ','E_CO2  ',&
'E_PM_10','E_PM25 ','E_SO4I ','E_NO3I ','E_PM25I',&
'E_ORGI ','E_ECI  ','E_SO4J ','E_NO3J ','E_PM25J','E_ORGJ ', 'E_ECJ  '/)
WTM=(/28., 17., 30., 46.,             &
      64., 44., 16.,108.,30.,58.,44., &
      72.,114., 30.,68., 72.,70.,72., &
      70., 28., 56., 42.,46.,60.,92., &
     106.,44.,&
    3600.,3600.,3600.,3600.,3600.,&
    3600.,3600.,3600.,3600.,3600.,3600.,3600.]! MW 3600 for unit conversion to ug/s
