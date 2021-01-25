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
   call lee_NEI
   call borra

 contains
   subroutine crea_data
     implicit none
     integer, parameter:: IHOUR=12
     integer :: IX=20
     integer :: JX=20
     integer :: KX=2
     integer :: HR,ii,i,j,k,n
     character(len=17) :: nfile
     print *,IX,JX,KX
     nfile="wrfem_00to12z_d01"
     NRADM=31
     if (.not. allocated(ename1)) allocate(ename1(NRADM))
     if (.not. allocated(EMISS3D)) allocate(EMISS3D(IX,KX,JX,NRADM,IHOUR))
     ename1=(/"e_so2    ","e_no     ","e_ald    ","e_hcho   ","e_ora2   ",&
     "e_nh3    ","e_hc3    ","e_hc5    ","e_hc8    ","e_eth    ","e_co     ",&
     "e_ol2    ","e_olt    ","e_oli    ","e_tol    ","e_xyl    ","e_ket    ",&
     "e_csl    ","e_iso    ","e_ch4    ","e_pm25i  ","e_pm25j  ","e_so4i   ",&
     "e_so4j   ","e_no3i   ","e_no3j   "," e_orgi  ","e_orgj   ","e_eci    ",&
     "e_ecj    ","e_pm10   "/)

     print *," "
     print *," creating  ",nfile," *****"
  ! Write some values in a section of the array
     EMISS3D=100.
     !call random_number( EMISS3D ) ! section-stride = 3
     OPEN(19,FILE=nfile,FORM='UNFORMATTED',CONVERT="BIG_ENDIAN",ACTION='WRITE')
     write(19) NRADM
     write(19) ename1

     do ii=1,IHOUR
       write(19) ii
       do n=1,NRADM
         write(19) (((EMISS3D(i,k,j,n,ii),i=1,ix),k=1,kx),j=1,jx)
       end do
     end do !IHOUR
     close (19)
     deallocate(ename1,EMISS3D)
   end subroutine

   subroutine borra
     write(6,*) "Borrando domain.nml wrfem_00to12z_d01"
    CALL EXECUTE_COMMAND_LINE("rm domain.nml wrfem_00to12z_d01")
   end subroutine
end program
