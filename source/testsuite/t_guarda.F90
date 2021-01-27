!  test guarda subroutine
!>  @brief Test stores data in netcdf format
!>  @author Jose Agustin Garcia Reynoso
!>  @date 27/01/2021
!>  @version  1.0
!>  @copyright Universidad Nacional Autonoma de Mexico
program t_guarda
  use var_nei

  call crea_nml
  call crea_data
  HH=0
  call lee_NEI
  call lee_wrfinput
  call guarda_emisiones
  call borra2
  
  contains
  subroutine borra2
  write(6,*) "Borrando domain.nml wrfem_00to12z_d01"
  CALL EXECUTE_COMMAND_LINE("rm domain.nml wrfem_00to12z_d01")
  end subroutine
end program
