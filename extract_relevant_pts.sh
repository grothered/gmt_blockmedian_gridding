# 3/3/2012
# Script to extract just the points we might be interested in for the ANUGA
# tsunami model in East New Britain. 
#
# The metadata file (in the 'metadata' directory) indicates that all points
# should be assumed to be in WGS84, with the vertical datum processed to MSL if
# possible.

# Around rabaul, the extent of interest is 
# 152.0438 - 152.5, -4.3701, -3.9999

mydir=$(pwd)
datadir="/media/Windows7_OS/Users/Gareth/Documents/work/png/PNG/PMD_bathymetry/dir_-2.-8.149.155/xyz_data/"
filename=blanche_bay_points.xyz

echo "Easting Northing Elevation File" > $filename

# Move into the data directory and do the extraction Note that we do not
# accept points from the 'gdat_XXXX' files, because these points seem clearly
# wrong in places.
cd $datadir
file_counter=0
for i in *.xyz;
    do cat $i | awk '$1>152.0438 && $1<152.5 && $2>-4.3701 && $2<-3.9999' | awk '{print $1,$2,$3, ENVIRON["i"]}'| awk '!/gdat/' >> $mydir/$filename
    done

# Go back to the initial directory
cd $mydir

