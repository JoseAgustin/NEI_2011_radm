# NEI_2011
Reads binary files and converts into a NetCDF files for
modeling air quality in WRF-chem using the RADM2 chemical
mechanism.

Input files

  - wrfem_00to12z_d01  binary file generated by NEI_2011 from 1 to 12 hour
  - wrfem_12to24z_d01  binary file generated by NEI_2011 from 12 to 24 hour
  - wrfinput           Same projection and dimensions as wrfem files

Output files

  - wrfchemi_00z_d01  netcdf file with attributes, dimensions from wrfinput and emissions from wrfem_00to12z_d01
  - wrfchemi_12z_d01  netcdf file with attributes, dimensions from wrfinput and emissions from wrfem_12to24z_d01
