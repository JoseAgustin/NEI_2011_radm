!  Test for check subroutine
program test_check
use var_nei, only :check
integer ::istatus =0

        print *,"Status= ",istatus
	call check(istatus)

end program test_check
