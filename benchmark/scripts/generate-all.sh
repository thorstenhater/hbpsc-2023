#!/usr/bin/env bash

# . env/bin/activate

run () {
    echo "################################################################################"
    echo "# Running $1 #"
    echo "################################################################################"
    bash "$1" | python3 scripts/miniterm.py
    echo
    echo
}

run scripts/generate-nmlcc.sh
run scripts/generate-nmlcc-super.sh
run scripts/generate-neuron.sh
run scripts/generate-neuron-pynml.sh

# run scripts/run-neuron.sh
# run scripts/run-eden.sh

