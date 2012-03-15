# Use blockmedian (GMT) to decimate the blanche bay data, in the harbour near rabaul only

outfile=rabaul_bay_blockmedian.xyz

echo -e 'Easting\t Northing\t Elevation' > $outfile

# Note we use awk to print only the first 3 columns, and skip the header
awk 'NR>1 {print $1, $2, $3}' blanche_bay_points.xyz | blockmedian -R152.148/152.200/-4.311/-4.199 -I100e -C -fo >> $outfile 

# Now we grid the decimated data
#awk 'NR>1' $outfile | nearneighbor -Gnearneighbourbathy.grd -R152.148/152.236/-4.311/-4.199 -I50e -S100e
awk 'NR>1' $outfile | xyz2grd -Ggridded_rabaul.grd -R152.148/152.200/-4.311/-4.199 -I100e

# Now, we have to convert this .nc file to a .tif for it to display correctly in QGIS (otherwise it flips). 
# I think this is a reported bug with an old version of gdal, which is still being used in the QGIS import.
gdal_translate -a_srs EPSG:4326 gridded_rabaul.grd gridded_rabaul.tif

# To get to UTM, note that the associated EPSG code is EPSG:32756
gdalwarp -s_srs EPSG:4326 -t_srs EPSG:32756 gridded_rabaul.tif gridded_rabaul_UTM.tif
