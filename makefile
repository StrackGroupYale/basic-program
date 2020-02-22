#!/bin/bash

julia solver/pkgs.jl;

echo type cmd:
read cmd
cmd="\""$cmd"\""
echo give me a mean Vector:
read meanVector
meanVector="\""$meanVector"\""
echo give me a shock Vector:
read shockVector
shockVector="\""$shockVector"\""
echo give me a distribution:
read distString
distString="\""$distString"\""
echo give me a capacity Vector:
read capVec
capVec="\""$capVec"\""
echo give me an output filename:
read fileName
fileName="\""$fileName"\""

echo "Calculating"


julia solver/gen.jl $cmd $meanVector $shockVector $distString $capVec $fileName
