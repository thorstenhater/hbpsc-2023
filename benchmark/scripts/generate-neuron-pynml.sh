mkdir generated/pynml-neuron

pynml \
    L5bPyrCellHayEtAl2011/neuroConstruct/generatedNeuroML2/LEMS_TestL5PC.xml \
    -neuron \
    -outputdir generated/pynml-neuron

(
    cd generated/pynml-neuron
    nrnivmodl *.mod
)
