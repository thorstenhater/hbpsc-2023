#!/usr/bin/env bash

python3 -m venv env

cd env
. bin/activate

pip install -U \
    NEURON==8.2.1 \
    eden-simulator==0.2.0 \
    arbor==0.7 \
    pyNeuroML==0.7.2

# git clone --depth 1 --recursive https://github.com/arbor-sim/arbor.git
# pip install ./arbor/

git clone --depth 1 https://github.com/thorstenhater/nmlcc
git -C nmlcc submodule init
git -C nmlcc submodule update
cargo install --root . --path ./nmlcc

#cargo install --git https://github.com/thorstenhater/nmlcc --target-dir .
