#!/bin/bash
set -ex

alldirs=$( find /Volumes/bek/learn/MR_Proc -ipath "*bandit[0-9]" -type d | grep -v bbr_exclude )

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

    id=$( echo "$d" | perl -pe 's:.*/MR_Proc/([^/]+)/bandit_MB_proc/.*:\1:' )
    cd "${d}"
    tmp_path=$( find "/Volumes/bek/learn/WPC-6605_MB" -ipath "*${id}" -type d)
    refimg=$( find -L $tmp_path -iname  "*${num_block}_twix*ref.hdr" | head -1 ) #Stupid naming convenctions aren't consistant
    if [ ! -d bbr_noref ]; then
        sed -i .bak 's/-func_struc_dof 6/-func_struc_dof bbr/' .preproc_cmd && rm -f .preproc_cmd.bak
        sed -i .bak "1s:\$: -func_refimg $refimg:" .preproc_cmd && rm -f .preproc_cmd.bak
        mkdir bbr_noref || exists=1
        mv nfswudktm_bandit* bbr_noref || nofiles= #bandit specific
        mv func_to_struct* bbr_noref || nofiles=1
    fi

    rm -f mc_target_brain* mc_target_mask* epiref_to_func* epiref_to_struct* nfswudktm_* fswudktm_* swudktm_* wudktm_* wktm_* template* .rescaling_complete .temporal_filtering_complete .warp_complete .prepare_fieldmap_complete .fmunwarp_complete .fieldmap_* .csf_* .wm_* nuisance_regressors.txt func_to_st* struct_to_func.mat fmap2epi_bbr.mat .func2struct_complete preprocessFunctional* .preprocessfunctional_complete subject_mask.nii.gz .func2struct_complete .motion_plots_complete .motion_censor_complete .smoothing_complete wktm_* wudktm_* swudktm_*
    preprocessFunctional -resume &
done



