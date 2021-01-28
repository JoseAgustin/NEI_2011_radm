!
!   guarda.f90
!>  @brief Stores emissions in radm categories in netcdf format
!>  @author Jose Agustin Garcia Reynoso
!>  @date 26/04/2018
!>  @version  1.0
!>  @copyright Universidad Nacional Autonoma de Mexico
!>
!
!****************************************************************************
!  Proposito:
!            Guarda los datos del inventario interpolado para el
!            mecanismo RADM2 en formato netcdf
!***************************************************************************
!                            _                         _     _
!   __ _ _   _  __ _ _ __ __| | __ _     ___ _ __ ___ (_)___(_) ___  _ __
!  / _` | | | |/ _` | '__/ _` |/ _` |   / _ \ '_ ` _ \| / __| |/ _ \| '_ \
! | (_| | |_| | (_| | | | (_| | (_| |  |  __/ | | | | | \__ \ | (_) | | | |
!  \__, |\__,_|\__,_|_|  \__,_|\__,_|___\___|_| |_| |_|_|___/_|\___/|_| |_|
!  |___/                           |_____|
subroutine guarda_emisiones
  use netcdf
  use var_nei
  implicit none
  integer :: i,j,l
  integer :: ncid
  integer :: id_varlong,id_varlat,id_unlimit
  integer :: periodo,it,ikk,id,iu,iit,eit
  integer,dimension(NDIMS):: dim,id_dim
  integer,dimension(nradm+1):: id_var
  integer :: dimids2(2),dimids3(3),dimids4(4)
  real,ALLOCATABLE :: ea(:,:,:,:)
  character (len=20) :: FILE_NAME
  character(len=19),dimension(1,1)::Times
  character(8)  :: date
  character(10) :: time
  character(20) :: date_meta
  print *,"Guarda Archivo"
  ! ******************************************************************
  call date_and_time(date,time)
  write(date_meta,'(A4,"-",A2,"-",A2,"T",A2,":",A2,":",A2,"Z")') &
      date(1:4),date(5:6),date(7:8),time(1:2),time(3:4),time(5:6)
  print *,date_meta
  cday="weekday"
  IF(hh.EQ. 0) THEN
  print *,'PERIODO 1'
  FILE_NAME='wrfchemi_00z_d01'         !******
  TITLE="NEI_2011 Emissions for 0 to 11z V4.0"
  PERIODO=1
  iit= 0
  eit=11
  write(current_date(12:13),'(2A)')"00"
  else
  Print *,'PERIODO 2'
  FILE_NAME='wrfchemi_12z_d01'         !******
  TITLE="NEI_2011 Emissions for 12 to 23z V4.0"
  PERIODO=2
  iit=12
  eit=23
  write(current_date(12:13),'(2A)')"12"
  end if
  write(FILE_NAME(16:16),'(I1)')grid_id
  ! Open NETCDF emissions file
  call check( nf90_create(FILE_NAME, nf90_clobber, ncid) )
  !     Define dimensiones
  dim(1)=1
  dim(2)=19
  dim(3)=SIZE(EMISS3D,DIM=1)
  dim(4)=SIZE(EMISS3D,DIM=3)
  dim(5)=1!mkx
  dim(6)=SIZE(EMISS3D,DIM=2) ! VERTICAL DATA
  if(.not.ALLOCATED(ea)) allocate (ea(dim(3),dim(4),dim(6),dim(1)))
  call check( nf90_def_dim(ncid,sdim(1), NF90_UNLIMITED, id_dim(1)) )
  do i=2,NDIMS
  call check( nf90_def_dim(ncid, sdim(i), dim(i), id_dim(i)) )
  end do

  dimids2 = (/id_dim(2),id_dim(1)/)
  dimids3 = (/id_dim(3),id_dim(2),id_dim(1) /)
  dimids4 = (/id_dim(3),id_dim(4),id_dim(6),id_dim(1)/)
  !Attributos Globales NF90_GLOBAL
  call check( nf90_put_att(ncid, NF90_GLOBAL, "TITLE",TITLE))
  call check( nf90_put_att(ncid, NF90_GLOBAL, "START_DATE",current_date))
  call check( nf90_put_att(ncid, NF90_GLOBAL, "SIMULATION_START_DATE",current_date))
  call check( nf90_put_att(ncid, NF90_GLOBAL, "WEST-EAST_GRID_DIMENSION",dim(3)))
  call check( nf90_put_att(ncid, NF90_GLOBAL, "SOUTH-NORTH_GRID_DIMENSION",dim(4)))
  call check( nf90_put_att(ncid, NF90_GLOBAL, "BOTTOM-TOP_GRID_DIMENSION",1))
  call check( nf90_put_att(ncid, NF90_GLOBAL, "DX",dx))
  call check( nf90_put_att(ncid, NF90_GLOBAL, "DY",dy))
  call check( nf90_put_att(ncid, NF90_GLOBAL, "CEN_LAT",cenlat))
  call check( nf90_put_att(ncid, NF90_GLOBAL, "CEN_LON",cenlon))
  call check( nf90_put_att(ncid, NF90_GLOBAL, "TRUELAT1",trulat1))
  call check( nf90_put_att(ncid, NF90_GLOBAL, "TRUELAT2",trulat2))
  call check( nf90_put_att(ncid, NF90_GLOBAL, "MOAD_CEN_LAT",moadcenlat))
  call check( nf90_put_att(ncid, NF90_GLOBAL, "STAND_LON",stdlon))
  call check( nf90_put_att(ncid, NF90_GLOBAL, "POLE_LAT",pollat))
  call check( nf90_put_att(ncid, NF90_GLOBAL, "POLE_LON",pollon))
  call check( nf90_put_att(ncid, NF90_GLOBAL, "GMT",gmt))
  call check( nf90_put_att(ncid, NF90_GLOBAL, "JULYR",julyr))
  call check( nf90_put_att(ncid, NF90_GLOBAL, "JULDAY",julday))
  call check( nf90_put_att(ncid, NF90_GLOBAL, "DAY ",cday))
  call check( nf90_put_att(ncid, NF90_GLOBAL, "MAP_PROJ",mapproj))
  call check( nf90_put_att(ncid, NF90_GLOBAL, "MAP_PROJ_CHAR",cmap_proj_char))
  call check( nf90_put_att(ncid, NF90_GLOBAL, "MMINLU",mminlu))
  call check( nf90_put_att(ncid, nf90_global, "ISWATER",iswater))
  call check( nf90_put_att(ncid, nf90_global, "ISLAKE",islake))
  call check( nf90_put_att(ncid, nf90_global, "ISICE",isice))
  call check( nf90_put_att(ncid, nf90_global, "ISURBAN",isurban))
  call check( nf90_put_att(ncid, nf90_global, "NUM_LAND_CAT",num_land_cat))
  call check( nf90_put_att(ncid, nf90_global, "ISOILWATER",isoilwater))
  call check( nf90_put_att(ncid, nf90_global, "GRID_ID",grid_id))
  call check( nf90_put_att(ncid, NF90_GLOBAL, "MECHANISM","RADM"))
  call check( nf90_put_att(ncid, NF90_GLOBAL, "creator_institution", "Centro de Ciencias de la Atmosfera, UNAM"))
  call check( nf90_put_att(ncid, NF90_GLOBAL,"creator_type","institution"))
  call check( nf90_put_att(ncid, NF90_GLOBAL,"contributor_name","Agustin Garcia, agustin@atmosfera.unam.mx"))
  call check( nf90_put_att(ncid, NF90_GLOBAL,"contributor_role","Researcher"))
  call check( nf90_put_att(ncid, NF90_GLOBAL,"cdm_data_type","Grid"))
  call check( nf90_put_att(ncid, NF90_GLOBAL,"acknowledgment","Centro de Ciencias de la Atmosfera, UNAM"))
  call check( nf90_put_att(ncid, NF90_GLOBAL,"publisher_institution","CCA,UNAM"))
  call check( nf90_put_att(ncid, NF90_GLOBAL,"publisher_url","www.atmosfera.unam.mx"))
  call check( nf90_put_att(ncid, NF90_GLOBAL,"publisher_type","institution"))
  call check( nf90_put_att(ncid, NF90_GLOBAL,"date_issued",date_meta))
  call check( nf90_put_att(ncid, NF90_GLOBAL,"date_created",date_meta))
  call check( nf90_put_att(ncid, NF90_GLOBAL,"date_modified",date_meta))
  call check( nf90_put_att(ncid, NF90_GLOBAL,"date_metadata_modified",date_meta))
  call check( nf90_put_att(ncid, NF90_GLOBAL,"time_coverage_start","2021-01-25T10:41:00Z"))
  call check( nf90_put_att(ncid, NF90_GLOBAL,"time_coverage_end","2021-01-25T10:41:00Z"))
  call check( nf90_put_att(ncid, NF90_GLOBAL,"time_coverage_duration","PT12H"))
  call check( nf90_put_att(ncid, NF90_GLOBAL,"time_coverage_resolution","PT1H"))
  call check( nf90_put_att(ncid, NF90_GLOBAL,"geospatial_lon_units","degrees_east"))
  call check( nf90_put_att(ncid, NF90_GLOBAL,"geospatial_lat_units","degrees_north"))
  call check( nf90_put_att(ncid, NF90_GLOBAL,"product_version","1.0"))
  call check( nf90_put_att(ncid, NF90_GLOBAL,"date_created",date_meta))
  !  Define las variables
  call check( nf90_def_var(ncid, "Times", NF90_CHAR, dimids2,id_unlimit ) )
  !  Attributos para cada variable
  call check( nf90_def_var(ncid, "XLONG", NF90_REAL,(/id_dim(3),id_dim(4),id_dim(1)/),id_varlong ) )
  ! Assign  attributes
  call check( nf90_put_att(ncid, id_varlong, "FieldType", 104 ) )
  call check( nf90_put_att(ncid, id_varlong, "MemoryOrder", "XYZ") )
  call check( nf90_put_att(ncid, id_varlong, "description", "LONGITUDE, WEST IS NEGATIVE") )
  call check( nf90_put_att(ncid, id_varlong, "units", "degree_east"))
  call check( nf90_put_att(ncid, id_varlong, "standard_name", "longitude"))
  call check( nf90_put_att(ncid, id_varlong, "axis", "X") )
  call check( nf90_def_var(ncid, "XLAT", NF90_REAL,(/id_dim(3),id_dim(4),id_dim(1)/),id_varlat ) )
  ! Assign  attributes
  call check( nf90_put_att(ncid, id_varlat, "FieldType", 104 ) )
  call check( nf90_put_att(ncid, id_varlat, "MemoryOrder", "XYZ") )
  call check( nf90_put_att(ncid, id_varlat, "description", "LATITUDE, SOUTH IS NEGATIVE") )
  call check( nf90_put_att(ncid, id_varlat, "units", "degree_north"))
  call check( nf90_put_att(ncid, id_varlat, "standard_name", "latitude"))
  call check( nf90_put_att(ncid, id_varlat, "axis", "Y") )

  do i=1,nradm+1
  if(i.lt.29 .or.i.gt.41) then
  call crea_attr(ncid,1,dimids4,ename(i),cname(i),"mol km^-2 s^-1",id_var(i))
  else
  call crea_attr(ncid,1,dimids4,ename(i),cname(i),"ug m-2 s-1",id_var(i))
  end if
  end do
  !
  !   Terminan definiciones
  call check( nf90_enddef(ncid) )
  !    Inicia loop de tiempo
  tiempo: do it=iit,eit
    write(6,'(3x,A8,I2)')'TIEMPO: ', it
    gases: do ikk=1,radm
      ea=0.0
      if(ikk.eq.1) then
        if (it.lt.10) then
          write(current_date(13:13),'(A1)')char(it+48)
        else
          id = int((it)/10)+48 !  Decenas
          iu = it-10*int((it)/10)+48 ! unidades
          write(current_date(12:13),'(A1,A1)')char(id),char(iu)
        end if
        write(current_date(1:4),'(I4)') julyr
        Times(1,1)=current_date(1:19)
        if (periodo.eq. 1) then
          call check( nf90_put_var(ncid, id_unlimit,Times,start=(/1,it+1/)) )
          call check( nf90_put_var(ncid, id_varlong,xlon,start=(/1,1,it+1/)) )
          call check( nf90_put_var(ncid, id_varlat,xlat,start=(/1,1,it+1/)) )
        else
          call check( nf90_put_var(ncid, id_unlimit,Times,start=(/1,it-11/)) )
          call check( nf90_put_var(ncid, id_varlong,xlon,start=(/1,1,it-11/)) )
          call check( nf90_put_var(ncid, id_varlat,xlat,start=(/1,1,it-11/)) )

endif
      end if   ! for kk == 1
      do i=1, dim(3)
        do j=1, dim(4)
          do l=1,dim(6)
            if(periodo.eq.1) then
              ea(i,j,l,1)=EMISS3D(i,l,j,ikk,it+1)
            else
              ea(i,j,l,1)=EMISS3D(i,l,j,ikk,it-11)
            endif
          end do
        end do
      end do
      if(periodo.eq.1) then
      call check( nf90_put_var(ncid, id_var(ikk),ea,start=(/1,1,1,it+1/)) )
      else
      call check( nf90_put_var(ncid, id_var(ikk),ea,start=(/1,1,1,it-11/)) )        !******
      endif
    end do gases
  end do tiempo
  call check( nf90_close(ncid) )
  if(periodo.eq.2) deallocate(ea,EMISS3D,ename,xlat,xlon)
contains
  !                               _   _
  !   ___ _ __ ___  __ _     __ _| |_| |_ _ __
  !  / __| '__/ _ \/ _` |   / _` | __| __| '__|
  ! | (__| | |  __/ (_| |  | (_| | |_| |_| |
  !  \___|_|  \___|\__,_|___\__,_|\__|\__|_|
  !                    |_____|
  !>   @brief Creates attributes for each variable in the netcdf file
  !>   @details
  !>   @author  Jose Agustin Garcia Reynoso
  !>   @date  07/13/2020
  !>   @version  2.2
  !>   @copyright Universidad Nacional Autonoma de Mexico 2020
  !>   @param ncid netcdf file ID
  !>   @param ifl type of variable 0 for ratio, 1 for emissions 2 for number
  !>   @param dimids ID dimensons array
  !>   @param svar short variable name
  !>   @param cname description variable name
  !>   @param cunits units of the variable
  !>   @param id_var variable ID
  subroutine crea_attr(ncid,ifl,dimids,svar,cname,cunits,id_var)
  use netcdf
      implicit none
      integer, INTENT(IN) ::ncid,ifl
      integer, INTENT(out) :: id_var
      integer, INTENT(IN),dimension(:):: dimids
      character(len=*), INTENT(IN)::svar,cname,cunits
      character(len=60) :: cvar
      if (ifl.eq.0)cvar="temporal_profile "//trim(cname)
      if (ifl.eq.1) cvar="surface_upward_mole_flux_of_"//trim(cname)
      if (ifl.eq.2) cvar="Number vehicles type "//trim(cname)
      call check( nf90_def_var(ncid, svar, NF90_REAL, dimids,id_var ) )
      ! Assign  attributes
      call check( nf90_put_att(ncid, id_var, "FieldType", 104 ) )
      call check( nf90_put_att(ncid, id_var, "MemoryOrder", "XYZ") )
      call check( nf90_put_att(ncid, id_var, "standard_name", cvar) )
      call check( nf90_put_att(ncid, id_var, "description", cvar) )
      call check( nf90_put_att(ncid, id_var, "units", cunits))
      call check( nf90_put_att(ncid, id_var, "stagger", "Z") )
      call check( nf90_put_att(ncid, id_var, "coordinates", "XLONG XLAT") )
      call check( nf90_put_att(ncid, id_var, "coverage_content_type","modelResult"))
      ! print *,"Entro a Attributos de variable",dimids,id,jd
      return
  end subroutine crea_attr
end subroutine guarda_emisiones
