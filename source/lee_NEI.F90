!
!   lee_NEI.f90
!>  @brief Reads binary emissions file with radm categories
!>  @details uses a global variable hh to read 00z or 12z.
!>  @author Jose Agustin Garcia Reynoso
!>  @date 25/04/2018
!>  @version  1.0
!>  @copyright Universidad Nacional Autonoma de Mexico
!>
!   Lee archivos binarios del NEI2011
!     25 abril para RADM
!     28 abril 2018 MOZART

subroutine lee_NEI
use var_nei
implicit none
  integer, parameter:: IHOUR=12
  integer :: IX=100
  integer :: JX=100
  integer :: KX=2
  integer :: HR,ii,i,j,k,n
  character(len=17) :: nfile
  call lee_nml(IX,JX,KX)
  print *,IX,JX,KX
  nfile="wrfem_12to24z_d01"
  if(hh.eq.00) then
   nfile="wrfem_00to12z_d01"
   print *,"    ***************  "
   print *,"    ** Converts  **  "
   print *,"    ***************  "
  end if
  print *," "
  print *," ***** ",nfile," *****"
  OPEN(19,FILE=nfile,FORM='UNFORMATTED',CONVERT="BIG_ENDIAN",STATUS='OLD',ACTION='READ')
  read(19) NRADM
  if (.not. allocated(ename1)) allocate(ename1(NRADM))
  if (.not. allocated(ename)) allocate(ename(NRADM+1))
  if (.not. allocated(EMISS3D)) allocate(EMISS3D(IX,KX,JX,NRADM+1,IHOUR))
  read(19) ename1
  write(6,'(3x,"Number of emission variables:",I3)') nradm
    ename(NRADM+1)="E_NO2"
  do n=1,NRADM
    ename(n)=to_upper(ename1(n))
    if(ename1(n).eq."E_CH3COCH") ename(n)="E_CH3COCH3"
  end do
  write(6,'(7(x,A7),A8)') ename
  do ii=1,IHOUR
    read(19) HR
    !print *,HR
    do n=1,NRADM
    read(19) (((EMISS3D(i,k,j,n,ii),i=1,ix),k=1,kx),j=1,jx)
    !if(hr.eq.12) print *,ename(n)!
    if( ename(n).eq."E_NO".or.ename(n).eq."e_no") then
        do i=1,ix
            do j=1,jx
                do k=1,kx
            EMISS3D(i,k,j,NRADM+1,ii)=EMISS3D(i,k,j,n,ii)*0.1
            EMISS3D(i,k,j,n,ii)=EMISS3D(i,k,j,n,ii)*0.9
                end do
            end do
        end do
    end if
    end do
  end do !IHOUR
  close (19)
contains
!>  @brief Converting text from lower to uppercase
!>  @details Adapted from http://www.star.le.ac.uk/~cgp/fortran.html
!>  @date 25 May 2012
!>  @author Clive Page, modified by:Milan Curcic
!>  @version  2.0
!>  @param strIn text to be converted to uppecase
!  _
! | |_ ___    _   _ _ __  _ __   ___ _ __
! | __/ _ \  | | | | '_ \| '_ \ / _ \ '__|
! | || (_) | | |_| | |_) | |_) |  __/ |
!  \__\___/___\__,_| .__/| .__/ \___|_|
!        |_____|   |_|   |_|
function to_upper(strIn) result(strOut)
     implicit none
     character(len=*), intent(in) :: strIn
     character(len=len(strIn)) :: strOut
     integer :: i,j

     do i = 1, len(strIn)
          j = iachar(strIn(i:i))
          if ( iachar("a")<=j .and. j<=iachar("z") ) then
               strOut(i:i) = achar(iachar(strIn(i:i))-32)
          else
               strOut(i:i) = strIn(i:i)
          end if
     end do

end function to_upper
end subroutine lee_NEI
