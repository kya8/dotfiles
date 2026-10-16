#!/bin/sh

set -eu

prog=cjpegli
prog_args="-d 1 --chroma_subsampling=444 -p 0"
keep_original=false

cmd_exists() {
    command -v "$1" >/dev/null 2>&1
}

if ! cmd_exists ${prog}; then
    echo "${prog} not found."
    exit 1
fi

usage() {
    echo "Usage: ${0##*/} [-k] FILE..."
    echo
    echo "Convert input images to JPEG using ${prog}."
    echo
    echo "Options:"
    echo "  -k  Keep the original file after conversion"
    echo "  -h  Show this help message"
    echo "  -s  Show arguments passed to ${prog} invocation"
}

while getopts ":khs" opt; do
    case "$opt" in
        k)
            keep_original=true
            ;;
        h)
            usage
            exit 0
            ;;
        s)
            echo "${prog} ${prog_args}"
            exit 0
            ;;
        \?)
            echo "Error: invalid option '-${OPTARG}'" >&2
            usage >&2
            exit 2
            ;;
    esac
done
shift $((OPTIND - 1))

if [ "$#" -eq 0 ]; then
    usage
    exit 2
fi

has_error=false

# Loop through all arguments passed to the script
for file in "$@"; do
    if [ ! -f "$file" ]; then
        echo "Warning: '$file' not found. Skipping."
        has_error=true
        continue
    fi

    stem="${file%.*}"
    out_name="${stem}.jpg"

    counter=1
    while [ -e "$out_name" ]; do
        out_name="${stem}-${counter}.jpg"
        counter=$((counter + 1))
    done

    if ${prog} ${prog_args} "$file" "$out_name" >/dev/null 2>&1; then
        touch -r "${file}" "${out_name}"
        if [ "$keep_original" = false ]; then
            rm -- "$file"
        fi
        echo "${file}" converted to "${out_name}"
    else
        echo Failed to convert "${file}"
        has_error=true
    fi

done

if [ "$has_error" = true ]; then
    exit 1
fi
