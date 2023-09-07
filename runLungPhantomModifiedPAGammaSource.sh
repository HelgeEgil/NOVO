#!/bin/bash

detectorsetup="front"

mod_values="05"

#for mod in `seq -f %02.0f 11 1 11`; do
for mod in $mod_values; do
   echo "Running geometry: $mod with GammaSource"
   for idx in `seq -f %02.0f 0 1 99`; do
      dicomfile=`ls CTLung_modified/mod_$mod/ | head -n 1`
      npart=`root -q OutputCTLung_modified/mod_"$mod"/gammasPMMA_idx"$idx".root -e "PhaseSpace->GetEntries()" | tail -n 1 | awk '{print $NF}'`
      echo $npart
      dmap="dmap_$mod.mhd"
      echo $dmap
      tsp Gate -a "'[idx,$idx] [mod,$mod] [dicomfile,$dicomfile] [npart,$npart] [dmap,$dmap] [detectorsetup,$detectorsetup]'" LungPhantomModifiedPAGammaSource.mac
   done
done
