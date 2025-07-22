#!/bin/bash

# sample=VBS_lvjj_OSWW_WpLtojj_WmLtolv
sample=simpletest

nohup ./submit_cmsconnect_gridpack_generation.sh ${sample} cards/vbs_lvjj/${sample}/ 4 15000 el9_amd64_gcc12 CMSSW_15_0_9 > mysubmit_${sample}.debug 2>&1 & 
