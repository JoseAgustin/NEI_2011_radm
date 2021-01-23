!
!   convierte.f90
!>  @brief Reads binary files from NEI 2011 and converts into netcdf
!>  @details using wrfinput to set dates, attributes and dimensions for RADM2 mechanism
!>  this is made in two steps:
!>   1) Set hh=0 to indicate thet binary file starting at 00Z will be read
!>      reads wrfiput file obtaining time, attibutes and dimensions.
!>      stores 00z emissions data in netcdf format
!>   2) Set hh=12 to read 12Z binary file
!>      uses previous wrfinput information and stores 12z emissions
!>      data in netcdf format
!>  @author Jose Agustin Garcia Reynoso
!>  @date 26/04/2018
!>  @version  1.0
!>  @copyright Universidad Nacional Autonoma de Mexico
!
program nei_2011
use var_nei

    hh=0
    call lee_NEI

    call lee_wrfinput

    call guarda_emisiones
    hh=12
    call lee_NEI

    call guarda_emisiones

end program nei_2011
