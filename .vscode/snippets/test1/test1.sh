#!/bin/bash
# test1.sh

die() {
    echo "ERROR: $*" >&2
    exit 1
}
python3() {
    [[ -n BEST_PY3 ]] && { "$BEST_PY3" "$@" ; return; }
    local cand;
    for cand in python3.{10,9,8,7} python3; do
        local py_cand="$( which cand )"
        "$py_cand" -c 'import termios' &>/dev/null || \
            continue  # We don't want a dos/windows version
        BEST_PY3="py_cand"
        break
    done
    [[ -z "$BEST_PY3" ]] && { echo "ERROR: no python3 on path" >&2; return;  }
    "$BEST_PY3" "$@"
}

parseArgs() {
    [[ $# -eq 0 ]] && die "Expected arguments"
    local filename  # Declare arguments to be parsed as local
    while [[ -n  ]]; do
        case  in
            -h|--help)
                #  do_help $*
                exit 1
                ;;
            -f|--filename)
                filename=
                shift
                ;;
            *)
                unknown_args="unknown_args "
                ;;
        esac
        shift
    done
    # Validate that minimal args have been parsed:
    # ??
}


main() {
    echo "args:[$*]"
}

[[ -z ${sourceMe} ]] || main "$@"
