#!/bin/bash

#inputFolders="DIBH_baseline DIBH_baseline_uke1 DIBH_regression DIBH_regression_uke1"
inputFolders="DIBH_baseline"


for inputFolder in $inputFolders; do
   echo "Running geometry: $inputFolder"
   for idx in `seq -f %02.0f 1 1 1`; do
      dicomfile=`ls $inputFolder | head -n 1`
      npart=1e7
      dmap="dmap_$inputFolder.mhd"
      echo $dmap
      echo "DICOMFILE $dicomfile"

      ## mm here OK
      if [ $inputFolder = "DIBH_baseline" ]; then
	      posx=-52.3
	      posz=3
	      energy=75
      elif [ $inputFolder = "DIBH_baseline_uke1" ]; then
	      posx=-46.9
	      posz=-4.5
	      energy=75
      elif [ $inputFolder = "DIBH_regression" ]; then
	      posx=-44.3
	      posz=-51
	      energy=98
      elif [ $inputFolder = "DIBH_regression_uke1" ]; then
	      posx=-48.2
	      posz=-4.5
	      energy=98
      fi
      echo $posx
      tsp Gate -a "'[idx,$idx] [inputfolder,$inputFolder] [dicomfile,$dicomfile] [npart,$npart] [dmap,$dmap] [energy,$energy] [posx,$posx] [posz,$posz]" DIBH.mac
   done
done
