#!/bin/bash
set -ex

alldirs=$( find /Volumes/bek/learn/MR_Proc -ipath "*" -type d | grep -v bbr_exclude )
echo $alldirs


