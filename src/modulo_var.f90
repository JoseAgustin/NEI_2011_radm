!
!   modulo_var.f90
!   
!
!   Created by Agustin Garcia on 25/04/18.
!   Copyright 2018 ___ORGANIZATIONNAME___. All rights reserved.
!
module nei2011

integer :: IX,JX,KX
integer :: NRADM,IHOUR
real, allocatable:: EMISS3D(:,:,:,:,:)
real,allocatable ::xlon(:,:,:),xlat(:,:,:)! by nx,ny,nh emissions

character (len=9), allocatable:: ENAME(:)


common /nei/ IX,JX,KX

end module
