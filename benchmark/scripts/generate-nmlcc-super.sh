OUT=generated/nmlcc-super

which nmlcc
python3 -c 'import arbor; print(arbor.__path__)'

rm -fr "${OUT}"
mkdir -p "${OUT}"

(
    time nmlcc bundle -s L5bPyrCellHayEtAl2011/neuroConstruct/generatedNeuroML2/TestL5PC.net.nml "${OUT}"
) 2>&1 | tee "${OUT}/log"


