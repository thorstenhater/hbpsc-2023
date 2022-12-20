#!/usr/bin/env bash


# . env/bin/activate

while true; do
    echo "Delete the generated directory prior to running this to"
    echo "re-generate using nmlcc"
    echo "WARNING! This script assumes the result directory is empty"
    read -p "Delete? [Y/N]" yn
    case $yn in
        [Yy]* ) rm -fr results; break;;
        [Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
done

if [ ! -d generated ]
then
    bash scripts/generate-all.sh
fi

run () {
    echo "################################################################################"
    echo "# Running $@ #"
    echo "################################################################################"
    (
    cd scripts
    $@ | python3 miniterm.py
    )
    echo
    echo
}

mkdir -p results

for _ in `seq 5`
do
    dt=0.025
    run python3 run-neuron-pynml.py
    run python3 run-nmlcc.py --jnml nmlcc 4a
    run python3 run-nmlcc.py --jnml nmlcc 4b
    run python3 run-nmlcc.py --jnml nmlcc 5a
    run python3 run-eden.py
    run python3 run-nmlcc.py nmlcc-super 4a ${dt}
    run python3 run-nmlcc.py nmlcc-super 4b ${dt}
    run python3 run-nmlcc.py nmlcc-super 5a ${dt}
    run python3 run-nmlcc.py nmlcc 4a ${dt}
    run python3 run-nmlcc.py nmlcc 4b ${dt}
    run python3 run-nmlcc.py nmlcc 5a ${dt}
    run python3 run-neuron-4a.py
    run python3 run-neuron-4b.py
    run python3 run-neuron-5a.py
    run python3 run-neuron-4a.py ${dt}
    run python3 run-neuron-4b.py ${dt}
    run python3 run-neuron-5a.py ${dt}
done
