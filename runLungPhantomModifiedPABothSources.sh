#!/bin/bash

detectorsetup="variable"
mod_values="00 01 03 04 05 06 07 08 09 10 11"
#mod_values="01"
#low=""
x0pos=-7
y0pos=-5

angle_values="00 45 90"

for mod in $mod_values; do
   for idx in `seq -f %02.0f 0 1 99`; do
      dicomfile=`ls CTLung_modified/mod_$mod/ | head -n 1`
      npartn=`root -q OutputCTLung_modified/mod_"$mod"/neutronsPMMA_idx"$idx".root -e "PhaseSpace->GetEntries()" | tail -n 1 | awk '{print $NF}'`
      npartg=`root -q OutputCTLung_modified/mod_"$mod"/gammasPMMA_idx"$idx".root -e "PhaseSpace->GetEntries()" | tail -n 1 | awk '{print $NF}'`
      echo $npart
      dmap="dmap_$mod.mhd"
      echo $dmap
      for angle in $angle_values; do
         echo "Running geometry $mod angle $angle with both sources; IDX $idx"
         xpos=`echo "-35*s($angle*0.01744) + $x0pos"|bc -l` # was -35
         ypos=`echo "40*c($angle*0.01744) + $y0pos"|bc -l`
         # Neutron source
         tsp Gate -a "'[idx,$idx] [mod,$mod] [dicomfile,$dicomfile] [npart,$npartn] [dmap,$dmap] [detectorsetup,$detectorsetup] [angle,$angle] [xpos,$xpos] [ypos,$ypos] [energyname,low]'" LungPhantomModifiedPANeutronSource.mac
         tsp Gate -a "'[idx,$idx] [mod,$mod] [dicomfile,$dicomfile] [npart,$npartn] [dmap,$dmap] [detectorsetup,$detectorsetup] [angle,$angle] [xpos,$xpos] [ypos,$ypos] [energyname,high]'" LungPhantomModifiedPANeutronSource.mac

         # Gamma source
         tsp Gate -a "'[idx,$idx] [mod,$mod] [dicomfile,$dicomfile] [npart,$npartg] [dmap,$dmap] [detectorsetup,$detectorsetup] [angle,$angle] [xpos,$xpos] [ypos,$ypos] [energyname,low]'" LungPhantomModifiedPAGammaSource.mac
         tsp Gate -a "'[idx,$idx] [mod,$mod] [dicomfile,$dicomfile] [npart,$npartg] [dmap,$dmap] [detectorsetup,$detectorsetup] [angle,$angle] [xpos,$xpos] [ypos,$ypos] [energyname,high]'" LungPhantomModifiedPAGammaSource.mac
      done
   done
done

#mod_values="00 01 03 04 05 06 07 08 09 10 11"
#low="low"
#
#angle_values="00"
#
#for mod in $mod_values; do
#   for idx in `seq -f %02.0f 0 1 99`; do
#      dicomfile=`ls CTLung_modified/mod_$mod/ | head -n 1`
#      npartn=`root -q OutputCTLung_modified/mod_"$mod"low/neutronsPMMA_idx"$idx".root -e "PhaseSpace->GetEntries()" | tail -n 1 | awk '{print $NF}'`
#      npartg=`root -q OutputCTLung_modified/mod_"$mod"low/gammasPMMA_idx"$idx".root -e "PhaseSpace->GetEntries()" | tail -n 1 | awk '{print $NF}'`
#      echo $npart
#      dmap="dmap_$mod.mhd"
#      echo $dmap
#      for angle in $angle_values; do
#         echo "Running geometry $mod angle $angle with both sources"
#         xpos=`echo "35*s($angle*0.01744) + $x0pos"|bc -l` # was -35
#         ypos=`echo "45*c($angle*0.01744) + $y0pos"|bc -l`
#         tsp Gate -a "'[idx,$idx] [mod,$mod] [dicomfile,$dicomfile] [npart,$npartn] [dmap,$dmap] [detectorsetup,$detectorsetup] [angle,$angle] [xpos,$xpos] [ypos,$ypos] [low,$low]'" LungPhantomModifiedPANeutronSource.mac
#         tsp Gate -a "'[idx,$idx] [mod,$mod] [dicomfile,$dicomfile] [npart,$npartg] [dmap,$dmap] [detectorsetup,$detectorsetup] [angle,$angle] [xpos,$xpos] [ypos,$ypos] [low,$low]'" LungPhantomModifiedPAGammaSource.mac
#      done
#   done
#done
