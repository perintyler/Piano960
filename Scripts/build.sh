#!/bin/bash

#
#
# Utility script for quickly building Piano960 
#
#

PROJECT_NAME="Piano960"

PIANO960_REPO=$(dirname $( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd ) );

PIANO960_BUILD_DIRECTORY=$PIANO960_REPO/build

PIANO960_INSTALL_PREFIX=/usr/local

PIANO960_SAMPLE_INSTALLATION_DIRECTORY=$PIANO960_INSTALL_PREFIX/include/$PROJECT_NAME

VERBOSE=false; # cli option

SILENT=false; # cli option

CLEAN_BUILD=false; # cli option

echo_help_message() 
{
    echo "options:";
    echo "v   Print out verbose information";
    echo "s   Supress cmake output";
    echo "t   Build and run unit tests";
    echo "i   Add 'install' to the cmake command to install the samples";
}

pushd_silently() { command pushd "$@" > /dev/null; }
popd_silently()  { command popd "$@" > /dev/null; }

echo_stdin_message() { echo; echo "[STDIN]: $@"; echo; }
echo_build_message() { echo; echo "[BUILD MESSAGE]: $@"; echo; }
exit_with_error()    { echo; echo "[ERROR]: $@"; echo; exit; }

create_piano960_build_directory()
{
    echo_build_message "creating Piano960 build directory: $PIANO960_BUILD_DIRECTORY";

    if [ "$VERBOSE" = true ]; then echo_stdin_message "mkdir $PIANO960_BUILD_DIRECTORY"; fi
    mkdir $PIANO960_BUILD_DIRECTORY;

    if [ ! -d "$PIANO960_BUILD_DIRECTORY" ]; then
        exit_with_error "something went wrong while creating the build directory...";
    fi
}

cmake_piano960() 
{
    pushd_silently $PIANO960_BUILD_DIRECTORY;

    cmake_command_arguments="-DCMAKE_INSTALL_PREFIX=$PIANO960_INSTALL_PREFIX";
    
    if [ "$VERBOSE" = true ]; then 
        echo_stdin_message "cmake $PIANO960_REPO $cmake_command_arguments";
        cmake $PIANO960_REPO $cmake_command_arguments;
    elif [ "$SILENT" = true ]; then
        cmake $PIANO960_REPO $cmake_command_arguments > /dev/null;
    else
        cmake $PIANO960_REPO $cmake_command_arguments;
    fi

    if [ $? -ne 0 ]; then
        exit_with_error "'cmake' command failed ('cmake $PIANO960_REPO'). Exiting.";
    fi

    popd_silently;
}

make_piano960()
{
    pushd_silently $PIANO960_BUILD_DIRECTORY;

    make_command_arguments="$@";
    if [ "$VERBOSE" = true ]; then echo_stdin_message "make $make_command_arguments"; fi

    if [ "$SILENT" = true ]; then
        make $make_command_arguments > /dev/null;
    else
        make $make_command_arguments;
    fi

    if [ $? -ne 0 ]; then
        exit_with_error "'make' command failed. Exiting.";
    fi

    popd_silently;
}

# 1) --- handle user input ---

# TODO: support full word options (e.g. --verbose)

make_parameters="" # this gets passed to the 'make' command
function add_make_parameter() { make_parameters="${make_parameters} $@"; }

while getopts "hvscit" option; do
   case $option in
      h) echo_help_message; exit;;                      # -h : display help message
      v) VERBOSE=true;;                                 # -v : turn on verbose mode
      s) SILENT=true;;                                  # -s : turn on silent mode
      c) CLEAN_BUILD=true;;                             # -c : make clean build
      i) add_make_parameter "install";;                 # -i : install samples
      t) add_make_parameter "tests"; RUN_TESTS=true;;   # -t : build and run unit tests
   esac
done

# 2) --- create build files ---

if [ -d "$PIANO960_BUILD_DIRECTORY" ] && [ "$CLEAN_BUILD" = true ]; then
    if [ "$VERBOSE" = true ]; then 
        echo_stdin_message "rm -r " $PIANO960_BUILD_DIRECTORY; 
    fi

    rm -r $PIANO960_BUILD_DIRECTORY;
fi

if [ ! -d "$PIANO960_BUILD_DIRECTORY" ]; then 
    create_piano960_build_directory;
    cmake_piano960;
elif [ "$CLEAN_BUILD" = true ]; then
    cmake_piano960;
fi

# 3) --- build and/or run the executable(s) ---

make_piano960 $make_parameters;

if [ "$RUN_TESTS" = true ]; then
    $PIANO960_BUILD_DIRECTORY/Tests/unit-tests
    # /usr/local/bin/Piano/Tests/unit-tests;
fi

echo_build_message "Successfully built Piano960 to" $PIANO960_BUILD_DIRECTORY;

