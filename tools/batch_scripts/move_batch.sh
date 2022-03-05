#!/bin/bash

for i in `seq -f "%03g" 18 1 20`
do
    mv ./task_file/A501_${i}_* ./A501_result/A501_${i}/
done



