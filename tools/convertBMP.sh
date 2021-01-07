#!/bin/bash
# This small helper script converts a given 16-color BMP the old BMP3.x format
# that is accepted by the TFT Maximite.

INFILE=$1
OUTFILE=$2

convert ${INFILE} -background black -alpha remove -alpha off -colors 16 -compress none BMP3:${OUTFILE}
