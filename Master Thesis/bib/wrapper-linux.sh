#!/usr/bin/sh --login
echo original DISPLAY: ${DISPLAY}
export DISPLAY=$(hostname)${DISPLAY}
echo updated DISPLAY: ${DISPLAY}

module load jdk/1.8.0-201 &> /dev/null

bsub -Is -R "select[osrel=70]" echo $DISPLAY; pwd; module list; timeout 45m ./run-tests.sh
