#!/bin/bash
inputFolders="DIBH_baseline DIBH_baseline_uke1 DIBH_regression DIBH_regression_uke1"
angle_values="00 45 90"

inputFolders="DIBH_baseline"
angle_values="00"

for inputFolder in $inputFolders; do
   for idx in `seq -f %02.0f 0 1 10`; do
      dicomfile=`ls $inputFolder | head -n 1`
      npartn=`root -q Output/"$inputFolder"/neutronsPMMA_idx"$idx".root -e "PhaseSpace->GetEntries()" | tail -n 1 | awk '{print $NF}'`
      npartg=`root -q Output/"$inputFolder"/gammasPMMA_idx"$idx".root -e "PhaseSpace->GetEntries()" | tail -n 1 | awk '{print $NF}'`
      echo $npart
      dmap="dmap_$inputFolder.mhd"
      echo $dmap

      if [ $inputFolder = "DIBH_baseline" ]; then
	      x0pos=-5.23
         y0pos=-4.53
	      posz=0.3
      elif [ $inputFolder = "DIBH_baseline_uke1" ]; then
	      x0pos=-4.69
         y0pos=-5.14
	      posz=-0.45
      elif [ $inputFolder = "DIBH_regression" ]; then
	      x0pos=-4.43
         y0pos=-2.38
	      posz=-5.1
      elif [ $inputFolder = "DIBH_regression_uke1" ]; then
	      x0pos=-4.82
         y0pos=-2.71
	      posz=-0.45
      fi

      for angle in $angle_values; do
         echo "Running geometry $inputFolder angle $angle with both sources; IDX $idx"
         xpos=`echo "-35*s($angle*0.01744) + $x0pos"|bc -l`
         ypos=`echo "45*c($angle*0.01744) + $y0pos"|bc -l`
         # Neutron source
         tsp Gate -a "'[idx,$idx] [dicomfile,$dicomfile] [inputfolder,$inputFolder] [npart,$npartn] [dmap,$dmap] [detectorsetup,variable] [angle,$angle] [xpos,$xpos] [ypos,$ypos] [zpos,$posz]'" DIBHNeutronSource.mac

         # Gamma source
#         tsp Gate -a "'[idx,$idx] [dicomfile,$dicomfile] [inputfolder,$inputFolder] [npart,$npartg] [dmap,$dmap] [detectorsetup,variable] [angle,$angle] [xpos,$xpos] [ypos,$ypos] [zpos,$posz]'" DIBHGammaSource.mac
      done
   done
done
