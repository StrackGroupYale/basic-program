#!/bin/bash

julia solver/pkgs.jl;

echo type cmd:
read cmd
echo give me a mean Vector:
read meanVector
echo give me a shock Vector:
read shockVector
echo give me a distribution:
read distString
echo give me a capacity Vector:
read capVec
echo give me an output filename:
read fileName


julia solver/gen.jl $cmd $meanVector $shockVector $distString $capVec $fileName
