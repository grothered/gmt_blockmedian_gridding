# This script converts scatterd xyz points to a raster (all in geographic WGS
# 84 projection), by first applying 'blockmedian', and then rasterising. It
# produces several output files (xyz, .grd and .tif of the blockmedian points,
# and a UTM tif).

# Filename parameters
infile=blanche_bay_points.xyz
outfile_xyz=rabaul_bay_blockmedian.xyz
outfile_grd=gridded_rabaul.grd
outfile_tif=gridded_rabaul.tif
outfile_utm_tif=gridded_rabaul_UTM.tif

# Parameters defining the geographic extent and resolution, using GMT notation
outfile_wesn=152.148/152.200/-4.311/-4.199 
outfile_gridsize=100e

# 
#infile=pomeo_points.xyz


###############
#
# MAIN SCRIPT
#
##############

# Make file header
echo -e 'Easting\t Northing\t Elevation' > $outfile_xyz

# Blockmedian the input data. Use awk to print only the first 3 columns, and skip the header
awk 'NR>1 {print $1, $2, $3}' $infile | blockmedian -R$outfile_wesn -I$outfile_gridsize -C -fo >> $outfile_xyz

# Now we grid the decimated data
awk 'NR>1' $outfile_xyz | xyz2grd -G$outfile_grd -R$outfilewesn -I$outfile_gridsize

# Now, we have to convert this .nc file to a .tif for it to display correctly in QGIS (otherwise it flips). 
# I think this is a reported bug with an old version of gdal, which is still being used in the QGIS import.
gdal_translate -a_srs EPSG:4326 $outfile_grd $outfile_tif

# To get to UTM, note that the associated EPSG code is EPSG:32756
gdalwarp -overwrite -s_srs EPSG:4326 -t_srs EPSG:32756 $outfile_tif $outfile_utm_tif 
