#!/bin/bash

#badFiles="8 12 43 79 94"
modValues="00 01 03 04 05 06 07 08 09 10 11"
#modValues="00 01 03 04 05 11"
modValues="01"

#for mod in `seq -f %02.0f 6 10`; do
for mod in $modValues; do
   echo "Running geometry: $mod"
   for idx in `seq -f %02.0f 0 1 99`; do
      dicomfile=`ls CTLung_modified/mod_$mod/ | head -n 1`
      npart=1e7
      dmap="dmap_$mod.mhd"
      echo $dmap
      tsp Gate -a "'[idx,$idx] [mod,$mod] [dicomfile,$dicomfile] [npart,$npart] [dmap,$dmap] [energyname,high] [energy,85]" LungPhantomModifiedPA.mac
#      tsp Gate -a "'[idx,$idx] [mod,$mod] [dicomfile,$dicomfile] [npart,$npart] [dmap,$dmap] [energyname,low] [energy,84.595]" LungPhantomModifiedPA.mac
   done
done
