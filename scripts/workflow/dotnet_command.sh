#!/bin/bash

if [ -z "$1" ]; then
    echo "Please specify a command (e.g., run, build, test)."
    exit 1
fi

command="$1"
shift
args="$@"
found=false

if [ "$command" == "test" ]; then
    for dir in */; do
        if [[ $dir == *UnitTests* ]]; then
            found=true
            dotnet test $dir $args
        fi
    done
fi

# do these checks

for dir in */; do
    if [ -d "${dir}Controllers" ]; then
        (cd "$dir" && dotnet "$command" $args)
        found=true
        break
    fi
done

if [ "$found" = false ]; then
    for dir in */; do
        if [ -f "${dir}Program.cs" ]; then
            (cd "$dir" && dotnet "$command" $args)
            break
        fi
    done
fi

if [ -d "Controllers" ]; then
    dotnet "$command" $args
    found=true
fi

if [ "$found" = false ]; then
    if [ -f "Program.cs" ]; then
        dotnet "$command" $args
    fi
fi
