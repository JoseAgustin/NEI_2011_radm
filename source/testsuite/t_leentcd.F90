!
!>  @brief Testing subroutine lee_netcdf
!>  @author Jose Agustin Garcia Reynoso
!>  @date 25/01/2021
!>  @version  1.0
!>  @copyright Universidad Nacional Autonoma de Mexico
program test_lee_netcdf
  use var_nei

  print *,"   ***** Testing lee_wrfinput  ****"
  if (.not. allocated(EMISS3D)) allocate(EMISS3D(20,2,20,1,1))

  call lee_wrfinput

  deallocate(EMISS3D,XLON,XLAT)
  print *,"    ",current_date
  print *,"   ***** END Testing lee_wrfinput  ****"
end program
