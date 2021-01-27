!>
!>  @brief Test Reads binary emissions file with radm categories
!>  @details uses a global variable hh to read 00z or 12z.
!>  @author Jose Agustin Garcia Reynoso
!>  @date 25/04/2018
!>  @version  1.0
!>  @copyright Universidad Nacional Autonoma de Mexico
program test_read_NEI
   use var_nei
   
   call crea_nml
   call crea_data
   HH=0
   call lee_NEI
   call borra

 contains

!  _
! | |__   ___  _ __ _ __ __ _
! | '_ \ / _ \| '__| '__/ _` |
! | |_) | (_) | |  | | | (_| |
! |_.__/ \___/|_|  |_|  \__,_|
   subroutine borra
     write(6,*) "Borrando domain.nml wrfem_00to12z_d01"
    CALL EXECUTE_COMMAND_LINE("rm domain.nml wrfem_00to12z_d01")
   end subroutine
end program
