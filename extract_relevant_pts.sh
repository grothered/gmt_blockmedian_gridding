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
#filename=blanche_bay_points.xyz
#outfile_wesn=152.0438/152.5/-4.3701/-3.9999
filename=pomeo_points.xyz
outfile_wesn=151.437/151.868/-5.691/-5.504

echo "Easting Northing Elevation File" > $filename

# Move into the data directory and do the extraction Note that we do not accept
# points from the 'gdat_XXXX' or 'bin_250XXXX' files, because some of these
# points seem clearly wrong in places (i.e. on land), and they had an irregular
# coverage anyway
cd $datadir
#file_counter=0 # Could use this to replace the filename and shrink file size
for i in *.xyz;
    #do cat $i | gawk '$1>152.0438 && $1<152.5 && $2>-4.3701 && $2<-3.9999' | gawk -v f=$i '{print $1,$2,$3, f}'| grep -v 'gdat'| grep -v 'bin' >> $mydir/$filename
    do cat $i | gmtselect -R$outfile_wesn | gawk -v f=$i '{print $1,$2,$3, f}'| grep -v 'gdat'| grep -v 'bin' >> $mydir/$filename
    done

# Go back to the initial directory
cd $mydir

# After this, we can call 'blockmedians.sh' to grid the points
