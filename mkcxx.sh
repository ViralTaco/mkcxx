#!/usr/bin/env bash

mkcxx() {
  local -r version="$0 version 1.0.4"
  local -r usage="$(cat <<END
Usage:
$0 [-s source] [-b build] [-f] [<flags> ...] [-h|-v]
  -s source:  Path to source directory (default: \$PWD).
  -b build:		Path to build directory (default: \${PWD}/build).
  -f		      Pass --fresh to CMake.
  flags		    The flags to be appended to the CMake command
  -h		      Prints this help message.
  -v          Prints version information.
END
)"
  
  local source_dir; source_dir="$(pwd -P)"
  local build_dir;  build_dir="${source_dir}/build"
  local dirty;
  
  while getopts ":b:s:hdv:" opt; do
    case ${opt} in
      b) build_dir="${OPTARG}"
    ;;
      s) source_dir="${OPTARG}"
    ;;
      d) dirty="--fresh"
    ;;
      h) printf "%s\n" "$usage"
    ;;
      v) printf "%s\n" "$version"
    ;;
      :) printf "Option -%s requires an argument.\n%s\n" "$OPTARG" "$usage"
       return 1
    ;;
      ?) printf "Invalid option: -%s.\n" "${OPTARG}"
       return 1
    ;;
    esac
  done
  # If "$build_dir" doesn't exist create it.
  [[ -d "$build_dir" ]] || command mkdir "$build_dir"
  
  # Advance $@ to the current option, passing the remaing opts to cmake.
  shift "$((OPTIND - 1))"
  command cmake -S "$source_dir" -B "$build_dir" "$dirty" "$@"
  return "$?"
}
  
  mkcxx "$@"