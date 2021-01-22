!
!   module_var_nei.f90
!
!
!   Created by Agustin Garcia on 25/04/18.
!   Copyright 2018 Universidad Nacional Autonoma de Mexico. All rights reserved.
!
module var_nei
! Emissions Inventories Variables
  integer :: zlev       ! Emission Layer
  integer :: hh,NRADM
  integer,parameter :: nh=24
  integer,parameter :: radm=32
  integer,parameter :: NDIMS=6
  real,allocatable:: EMISS3D(:,:,:,:,:) ! emissions by nx,ny,level,nh,radm
  real,allocatable:: dlat(:,:),dlon(:,:)     ! by nx,ny from NEW DOMAIN
  real,allocatable ::xlon(:,:,:),xlat(:,:,:)! by nx,ny,nh emissions
  integer:: grid_id
  integer:: julyr,julday,mapproj,iswater,islake,isice,isurban,isoilwater
  real :: cenlat,cenlon, dx,dy
  real :: trulat1, trulat2,moadcenlat,stdlon,pollat,pollon
  real :: gmt,num_land_cat
  character(len=3) :: cday
  CHARACTER (len= 9), allocatable :: ENAME1(:)
  CHARACTER (len=10), allocatable :: ENAME(:)
  character(len=19)::mminlu,map_proj_char
  character(len=19):: iTime
  character(len=38):: Title
  character(len=19),dimension(1,1)::Times
  character (len=19),dimension(NDIMS) ::sdim=(/"Time               ",&
  & "DateStrLen         ","west_east          ","south_north        ",&
  &"bottom_top         ","emissions_zdim_stag"/)
  character(len= 19),dimension(radm):: cname=(/'Sulfur Dioxide  ',&
  'Nitrogen oxide  ','Aldehydes       ','HCHO            ','Acetic Acid     ',&
  'Ammonia         ','Butanes         ','Pentanes        ','Alkane          ',&
  'Ethane          ','Carbon Monoxide ','Alkanes         ','Terminal Alkenes',&
  'Alkenes         ','Toluene         ','Xylene          ','Acetone         ',&
  'Cresol          ','Isoprene        ','Methane         ','PM25I           ',&
  'PM25J           ','SulfatesI       ','SulfatesJ       ','Nitrates        ',&
  'NitratesJ       ','OrganicI        ','OrganicJ        ','Elemental Carb I',&
  'Elemental Carb J','PM_10           ','Nitrogen Dioxide'/)
  character (len=19) :: current_date,mecha

  ! Domain Variables
  common /domain/ NRADM,zlev,dx,dy,Title,sdim
  common /date/ hh,id_grid,current_date,cday,mecha,cname,Times
  common /wrf/ julyr,julday,mapproj,iswater,islake,isice,isurban,isoilwater,&
  cenlat,cenlon,trulat1, trulat2,moadcenlat,stdlon,pollat,pollon,num_land_cat,&
  gmt,mminlu,map_proj_char

contains
  !       _               _
  !   ___| |__   ___  ___| | __
  !  / __| '_ \ / _ \/ __| |/ /
  ! | (__| | | |  __/ (__|   <
  !  \___|_| |_|\___|\___|_|\_\
  !> @brief Verifies no error in netcdf function call
  !> @param status NetCDF functions return a non-zero status codes on error.
  !> @copyright 1993-2020 University Corporation for Atmospheric Research/Unidata
  ! Copyright 1993-2020 University Corporation for Atmospheric Research/Unidata
  !
  !Portions of this software were developed by the Unidata Program at the
  !University Corporation for Atmospheric Research.
  !
  !Redistribution and use in source and binary forms, with or without
  !modification, are permitted provided that the following conditions are met:
  !
  ! 1. Redistributions of source code must retain the above copyright notice,
  ! this list of conditions and the following disclaimer.
  ! 2. Redistributions in binary form must reproduce the above copyright notice,
  ! this list of conditions and the following disclaimer in the documentation
  ! and/or other materials provided with the distribution.
  ! 3. Neither the name of the copyright holder nor the names of its contributors
  ! may be used to endorse or promote products derived from this software without
  ! specific prior written permission.
  ! THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
  ! AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
  ! THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
  ! PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
  ! CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
  ! EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
  ! PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
  ! OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
  ! WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
  ! OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
  ! OF THE POSSIBILITY OF SUCH DAMAGE.
  subroutine check(status)
  USE netcdf
    integer, intent ( in) :: status
    if(status /= nf90_noerr) then
      print *, trim(nf90_strerror(status))
      stop 2
    end if
end subroutine check
!>  @brief Reads dimensions from namelist file
!>
!> Obtains from domain.nml file dimension of domain dimensions.
!>  @author Jose Agustin Garcia Reynoso
!>  @date 01/22/2021
!>  @version  1.0
!>  @copyright Universidad Nacional Autonoma de Mexico
!> @param IX number of cell grid in W-E direction
!> @param JX number of cell grid in S-N direction
!> @param KX number of cell grid in vertical direction
!  _                               _
! | | ___  ___     _ __  _ __ ___ | |
! | |/ _ \/ _ \   | '_ \| '_ ` _ \| |
! | |  __/  __/   | | | | | | | | | |
! |_|\___|\___|___|_| |_|_| |_| |_|_|
!           |_____|
subroutine lee_nml(IX,JX,KX)
  integer,intent(OUT)::IX
  integer,intent(OUT)::JX
  integer,intent(OUT)::KX
  integer :: nmlFileID=0
  ! namelist-group dom_dims.
  namelist/dom_dims/IX,JX,KX
  open(newunit=nmlFileID, file="domain.nml")
  read(nmlFileID, nml=dom_dims)
  close(nmlFileID)
end subroutine lee_nml
end module var_nei
