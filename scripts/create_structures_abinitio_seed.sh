#!/bin/bash

mkdir -p ../data/created_structures/$2/$3
cd ../data/created_structures/$2/$3 || exit
/storage2/imartinovic/rosetta/main/source/bin/AbinitioRelax.cxx11thread.linuxgccrelease @$1 -seed_offset $3 > /dev/null
cd /storage2/imartinovic/SnakemakePipeline || exit
