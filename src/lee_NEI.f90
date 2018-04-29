!
!   lee_NEI.f90
!   
!
!   Created by Agustin Garcia on 25/04/18.
!   Copyright 2018 Universidad Nacional Autonoma de Mexico. All rights reserved.
!
!   Lee archivos binarios del NEI2011
!     25 abril para RADM
!

subroutine lee_NEI
use var_nei
implicit none
  integer, parameter:: IX=160
  integer, parameter:: JX=160
  integer, parameter:: KX=8
  integer, parameter:: IHOUR=12
  integer :: HR,ii,i,j,k,n
  character(len=17) :: nfile
  nfile="wrfem_12to24z_d01"
  if(hh.eq.00) then
   nfile="wrfem_00to12z_d01"
   print *,"    ***************  "
   print *,"    ** Convierte **  "
   print *,"    ***************  "
  end if
  print *," "
  print *," ***** ",nfile," *****"
  OPEN(19,FILE=nfile,FORM='UNFORMATTED',CONVERT="BIG_ENDIAN")
  read(19) NRADM
  if (.not. allocated(ename)) allocate(ename(NRADM))
  if (.not. allocated(EMISS3D)) allocate(EMISS3D(IX,KX,JX,NRADM,IHOUR))
  read(19) ename
  print *, nradm
  print *,ename
  do ii=1,IHOUR
    read(19) HR
    !print *,HR
    do n=1,NRADM
    read(19) (((EMISS3D(i,k,j,n,ii),i=1,ix),k=1,kx),j=1,jx)
    !if(hr.eq.12) print *,ename(n)!
    end do
  end do !IHOUR
  close (19)
end subroutine lee_NEI
