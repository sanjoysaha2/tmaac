#! /bin/bash 

source ${HOME}/.bashrc_su2

parallel=true
fluid=true

DIR_FLUID=./fluid

ncpu_f=20

INP_F=$DIR_FLUID/NICFD_nozzle.cfg
LOG_F=log_su2.fluid

# Fluid
version=v8.0.0-gcc-fluid
DIR_BIN_F=/opt/SU2/SU2-$version/bin
LD_F=${DIR_BIN_F}/SU2_CFD
#LD_F=SU2_CFD

#--- Make directory
DIR_OUTPUT=("output_restart" "output_flow" "output_surface_flow")
cd $DIR_FLUID
for (( i = 0; i < ${#DIR_OUTPUT[*]}; i++ ))
{
   if [[ ! -e $DIR_OUTPUT[i] ]]; then
     mkdir ${DIR_OUTPUT[i]}
   fi
}
cd ../

#--- Run LD
if $parallel ; then
  mpirun -n $ncpu_f $LD_F $INP_F > $LOG_F 2>&1 &
else
  $LD_F $INP_F > $LOG_F 2>&1 &
fi
PIDParticipant1=$!

echo "Waiting for the participants to exit..., PIDs: ${PIDParticipant1}"
echo "PIDs: ${PIDParticipant1}" > log_run

exit