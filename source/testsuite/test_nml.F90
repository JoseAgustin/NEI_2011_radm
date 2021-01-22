! test_nml.F90
!>  @brief Program to obtain the domain's dimensions
!>  @author Jose Agustin Garcia Reynoso
!>  @date 01/22/2021
!>  @version  1.0
!>  @copyright Universidad Nacional Autonoma de Mexico
program nml_read
  use var_nei
  integer ::IX,JX,KX
  call lee_nml(IX,JX,KX)
  write(6,'(3(I4))') IX,JX,KX
end program
