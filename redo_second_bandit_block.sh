#!/bin/bash
set -ex

#I was going to use this script, then I thought aginst it as we might addd 2 lines of -func_ref, really what I should to is use thhis script to remove that line and replace it with the correct one

alldirs=$( find /Volumes/bek/learn/MR_Proc -ipath "*bandit2" -type d | grep -v bbr_exclude )

for d in $alldirs; do
    echo $d
    #d=$( dirname $d )
    num_block=$(echo "${d: -1}")
    #cho $num_block


    set +x
    while [ $(jobs | wc -l) -ge 6 ]
    do
        sleep 10
    done
    set -x
    
    cd "${d}"
    preproc_str=$( less .preproc_cmd | grep -Eo "func_refimg.*$" | grep -Eo "Bandit_taskx?[0-9]" )
    echo $preproc_str
    
    if [ "$preproc_str" = " " ]; then
    	echo "Here"
	continue
    fi
    
    preproc_cmd_func_ref_num=$( echo $preproc_str | grep -Eo "[0-9]" )
    
    if [ "$preproc_cmd_func_ref_num" != "1" ]; then
    	continue
    fi
    
    if [ "$preproc_cmd_func_ref_num" = "1" ] && [ ! -d redo_ref_img ]; then
    	id=$( echo "$d" | perl -pe 's:.*/MR_Proc/([^/]+)/bandit_MB_proc/.*:\1:' )
    	tmp_path=$( find "/Volumes/bek/learn/WPC-6605_MB" -ipath "*${id}" -type d)
    	refimg=$( find -L $tmp_path -iname  "*${num_block}_twix*ref.hdr" | head -1 ) #Stupid naming convenctions aren't consistant
    fi
    
    
    #In if staement make a dir called redo_second_func and replace it with bbr_noref
    
#    if [ ! -d redo_ref_img ]; then
#        sed -i .bak 's/-func_refimg.*$/ /' .preproc_cmd && rm -f .preproc_cmd.bak #Replace the old wrong bandit ref image with nothing, then the correct one
#        sed -i .bak "1s:\$: -func_refimg $refimg:" .preproc_cmd && rm -f .preproc_cmd.bak
#        mkdir redo_ref_img || exists=1
#        mv nfswudktm_bandit* redo_ref_img || nofiles= #bandit specific
#        mv func_to_struct* redo_ref_img || nofiles=1
#    fi
#
#    rm -f mc_target_brain* mc_target_mask* epiref_to_func* epiref_to_struct* nfswudktm_* fswudktm_* swudktm_* wudktm_* wktm_* template* .rescaling_complete .temporal_filtering_complete .warp_complete .prepare_fieldmap_complete .fmunwarp_complete .fieldmap_* .csf_* .wm_* nuisance_regressors.txt func_to_st* struct_to_func.mat fmap2epi_bbr.mat .func2struct_complete preprocessFunctional* .preprocessfunctional_complete subject_mask.nii.gz .func2struct_complete .motion_plots_complete .motion_censor_complete .s
#    preprocessFunctional -resume &
done



