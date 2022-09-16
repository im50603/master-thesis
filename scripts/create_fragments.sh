#!/bin/bash

cd tmp/$1 || exit
/storage2/imartinovic/rosetta/main/tools/fragment_tools/make_fragments.pl "$1.$2"
cd ../..
