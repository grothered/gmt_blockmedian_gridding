# Use blockmedian (GMT) to decimate the blanche bay data, in the harbour near rabaul only

outfile=rabaul_bay_blockmedian.xyz

echo -e 'Easting\t Northing\t Elevation' > $outfile

# Note we use awk to print only the first 3 columns, and skip the header
awk 'NR>1 {print $1, $2, $3}' blanche_bay_points.xyz | blockmedian -R152.148/152.236/-4.311/-4.199 -I20e -C -fo >> $outfile 

# Now we grid the decimated data
awk 'NR>1' $outfile | nearneighbor -Gnearneighbourbathy.grd -R152.148/152.236/-4.311/-4.199 -I50e -S100e
