   subroutine crea_nml
     integer ::  outFileID=0
     integer :: IX=20
     integer :: JX=20
     integer :: KX=2
     namelist/dom_dims/IX,JX,KX
     open(newunit=outFileID, file="domain.nml")
  write(outFileID, nml=dom_dims)
  close(outFileID)
   end subroutine

