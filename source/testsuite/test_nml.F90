! test_nml.F90
program nml_read
  use var_nei
  integer ::IX,JX,KX
  call lee_nml(IX,JX,KX)
  write(6,'(3(I4))') IX,JX,KX
end program
