#!/bin/csh
source ~/cshrc 
xrun -f file.f -access +rwc -uvm +SVSEED=random  -covdut tb_top -coverage U #-gui
# imc -load ./cov_work/scope/test 