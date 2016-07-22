#!/bin/bash

echo -e "# ================================== Run cross frame field ======================================== #"

EXE=../build/bin/compare_cubic_smooth
MESH=../dat/tets/nut.vtk

TYPE=L1
ABS=0.1
WS=1e0
WO=1e3
WP=1e3
MAXITS=1000

OUT_DIR=../result/compare_smooth/nut-abs$ABS-ws$WS-wo$WO-wp$WP-tp$TYPE

if [ ! -d "$OUT_DIR" ]; then
    mkdir -p $OUT_DIR
fi

$EXE -i $MESH -o $OUT_DIR --sm_type=$TYPE --ws=$WS --wo=$WO --wp=$WP --abs_eps=$ABS --maxits=$MAXITS | tee $OUT_DIR/log.txt


echo -e "# ============================== Visualize sigularity of frame field ============================== #"

cd ../bin
export LD_LIBRARY_PATH=./3rd:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=./sys:$LD_LIBRARY_PATH

FF_EXE=./frame_field
MESH_FILE=$OUT_DIR/tet.vtk
FRAME_FILE=$OUT_DIR/frames.txt
SING_FILE=$OUT_DIR/sing.vtk

if [ "$TYPE" == "SH" ]; then
    $FF_EXE prog=draw_3d_frame_sing tet=$MESH_FILE zyz=$FRAME_FILE out=$SING_FILE
elif [ "$TYPE" == "L1" ]; then
    $FF_EXE prog=draw_3d_frame_sing tet=$MESH_FILE ff=$FRAME_FILE out=$SING_FILE
else
    echo -e "{error} return"
fi

echo -e "# ================================================================================================= #"
