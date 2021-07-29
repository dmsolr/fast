#!/bin/bash

dir=$(cd $(dirname $0); pwd)

sed -e 's%script_dir="${dir}/../script"%script_dir="'$dir'/script"%g' ${dir}/cli/g.sh > ./g
chmod +x ./g

mv ./g /usr/local/bin/g
