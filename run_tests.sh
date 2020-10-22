#!/bin/bash

export SINGULARITY_IMAGE="${SINGULARITY_IMAGE:-singularity-r.simg}"
echo "Using Singularity image: ${SINGULARITY_IMAGE}"

version () {
  singularity inspect "${SINGULARITY_IMAGE}" | \
    grep "R_VERSION" | \
    awk -F'"' '{print $4}'
}

set -e
set -x

# Verify R version
singularity exec R -q -e "stopifnot(getRversion() == '$(version)')"

# Install library
singularity exec R -q -e "install.packages('dplyr', dependencies = TRUE)"
singularity exec "${SINGULARITY_IMAGE}" install2.r --error --deps TRUE dplyr

{ set +x; } 2>/dev/null
echo "All tests passed!"
