#!/bin/bash

export SINGULARITY_IMAGE="${SINGULARITY_IMAGE:-r.simg}"
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

# Test littler r script
singularity exec ${SINGULARITY_IMAGE} r -e "R.Version()"

{ set +x; } 2>/dev/null
echo "All tests passed!"
