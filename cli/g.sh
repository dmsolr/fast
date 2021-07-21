#!/bin/bash

dir="$(cd $(dirname $0); pwd)"
collection=
script_dir="${dir}/../script"

exit_message() {
    echo $1
    exit 1
}

test $# -lt 1 && exit_message "error"

cmd="bash"
args=
post=

while test $# -gt 0
do
    if [[ "$1" =~ "-" ]]; then
        case "$1" in
            -l|--list)
                cmd=ls
                post=' tr "\t" "\n"'
                ;;
            -d|--delete)
                [[ -f $script_dir ]] || exit_message "Failed to remove directory $script_dir"
                exec rm -f "$script_dir"
                ;;
            -c|--cat)
                [[ -f $script_dir ]] || exit_message "Failed to cat directory"
                exec cat $script_dir
                ;;
            -e|--edit|-v|--vim)
                [[ -f $script_dir ]] || exit_message "File[$script_dir] not found."
                exec vim ${script_dir}
                ;;
            -a|--add)
                path="$(dirname $script_dir)"
                [[ -d $path ]] || mkdir -p $path
                [[ -f $script_dir ]] && exit_message "File[$script_dir] existed."
                touch $script_dir || exit_message "Failed to create file[$script_dir]"
                vim $script_dir
                ;;
            *)
                exit_message "Unknown action[$1]"
                ;;
            esac
    else
        script_dir=${script_dir}/$1
    fi

    shift
done

if [[ -n $post ]]; then 
    $cmd $script_dir $args | $post
else
    $cmd $script_dir $args
fi

exit_message "finished"
