#!/bin/bash
set -ex
#reset fieldmap dirs to original dicoms

#rawdir=/Volumes/bek/neurofeedback/sonrisa2/raw/SON2_001_Nalt

#Script will now take a path to the raw files and txt file of subjects that need reset
#Example call: ./resetFieldmaps.bash /Volumes/bek/neurofeedback/sonrisa2/raw/
#Where there is a son2 file in the local reset_fm_text_files dir

IFS=$'\r\n' GLOBIGNORE='*' command eval 'rawdir=($(cat reset_fm_text_files/son2_tmp))'

basedir=$1

for r in ${rawdir[@]}; do
	
	#Grab the mag dirs
	echo1dirs=$(find $basedir$r -iname "echo1" -type d -ipath "*gre_field*")

	echo $echo1dirs

	for d in $echo1dirs; do
	    cd $d
	    rm -f fm_magnitude_echo1.nii.gz fm_magnitude_echo1_brain.nii.gz fm_magnitude_echo1_brain_mask.nii.gz
	    tar xvzf fm_magnitude_echo1_dicom.tar.gz
	    mv MR* ../
	    rm -f fm_magnitude_echo1_dicom.tar.gz
	    cd ../ && rmdir echo1
	    [ -f .fieldmap_magnitude] && rm -f .fieldmap_magnitude
	done

	echo2dirs=$(find $basedir$r -iname "echo2" -type d -ipath "*gre_field*")

	for d in $echo2dirs; do
	    cd $d
	    rm -f fm_magnitude_echo2.nii.gz
	    tar xvzf fm_magnitude_echo2_dicom.tar.gz
	    mv MR* ../
	    rm -f fm_magnitude_echo2_dicom.tar.gz
	    cd ../ && rmdir echo2
	done
	
	#Grab phase dirs
	phasedirs=$(find $basedir$r -iname "fm_phase_dicom.tar.gz" -type f -ipath "*gre_field*")

	for d in $phasedirs; do
	    cd $(dirname $d)
	    tar xvzf fm_phase_dicom.tar.gz
	    rm -f fm_phase_dicom.tar.gz fm_phase.nii.gz fm_phase_radians.nii.gz fm_phase_radians_unwrapped.nii.gz fm_phase_rps.nii.gz FM_UD_fmap.nii.gz
	    [ -f .fieldmap_phase] && rm -f .fieldmap_phase
	done

done
