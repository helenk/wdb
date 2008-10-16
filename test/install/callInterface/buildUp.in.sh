## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
## 
## wdb - weather and water data storage
##
## Copyright (C) 2007 met.no
##
##  Contact information:
##  Norwegian Meteorological Institute
##  Box 43 Blindern
##  0313 OSLO
##  NORWAY
##  E-mail: wdb@met.no
##
##  This is free software; you can redistribute it and/or modify
##  it under the terms of the GNU General Public License as published by
##  the Free Software Foundation; either version 2 of the License, or
##  (at your option) any later version.
##
## - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#!/bin/sh
WDB_TMP_DIR=__WDB_BUILDDIR__/var/tmp
#GRIB_FILE=$WDB_TMP_DIR/wciInstallTest.grib
#CHECK_FILE=$WDB_TMP_DIR/wciInstallTest.check
XML_FILE1=$WDB_TMP_DIR/wciInstallTest1.xml
XML_FILE2=$WDB_TMP_DIR/wciInstallTest2.xml
XML_FILE3=$WDB_TMP_DIR/wciInstallTest3.xml
mkdir -p $WDB_TMP_DIR
TEST_WRITE=./testWrite
#CREATE_GRIB_FIELD=./gribWrite
#LOAD_GRIB_FILE=./gribLoad
LOAD_XML_FILE=./xmlLoad

#
# Copy across test data
# (clean up first)
#rm -f $GRIB_FILE
rm -f $XML_FILE1
rm -f $XML_FILE2
rm -f $XML_FILE3
#rm -f $CHECK_FILE
#cp __WDB_SRCDIR__/test/install/callInterface/wciInstallTest.grib $GRIB_FILE
#cp __WDB_SRCDIR__/test/install/callInterface/wciInstallTest.grib $CHECK_FILE
cp __WDB_SRCDIR__/test/install/callInterface/wciInstallTest1.xml $XML_FILE1
cp __WDB_SRCDIR__/test/install/callInterface/wciInstallTest2.xml $XML_FILE2
cp __WDB_SRCDIR__/test/install/callInterface/wciInstallTest3.xml $XML_FILE3
chmod 666 $WDB_TMP_DIR/*

# Check if we have write permission on destination directory/file:
#if ! touch $GRIB_FILE; then
#    echo Unable to create file: $GRIB_FILE
#    exit 1
#fi

#
# Generate Test Data
#
# DataProvider
$TEST_WRITE --dataprovider 'test wci 0' --placename 'test grid, rotated' --reftime '2004-12-24 06:00:00+00'
$TEST_WRITE --dataprovider 'test wci 1' --placename 'test grid, rotated' --reftime '2004-12-24 06:00:00+00'
$TEST_WRITE --dataprovider 'test wci 2' --placename 'test grid, rotated' --reftime '2004-12-24 06:00:00+00'

# PlaceName
$TEST_WRITE --dataprovider 'test wci 0' --placename 'test grid, rotated' --reftime '2004-12-25 06:00:00+00'
$TEST_WRITE --dataprovider 'test wci 0' --placename 'hirlam 10' --reftime '2004-12-25 06:00:00+00'
$TEST_WRITE --dataprovider 'test wci 0' --placename 'hirlam 20' --reftime '2004-12-25 06:00:00+00'

# PlaceGeos
# G1-G4, G7, G8, G17, G31 Test
$TEST_WRITE --dataprovider 'test wci 0' --placename 'hirlam 10' --reftime '2004-12-26 06:00:00+00' --valueparameter 'instant pressure of air'
# G5 Test
$TEST_WRITE --dataprovider 'test wci 0' --placename 'hirlam 10' --reftime '2004-12-26 06:00:00+00' --valueparameter 'instant pressure change of air' -P 168,156=2
# G6 Test
$TEST_WRITE --dataprovider 'test wci 0' --placename 'hirlam 20' --reftime '2004-12-26 06:00:00+00' --valueparameter 'instant proportion of ozone' -P280,135=2 -P90,42=3 -P233,17=4 -P233,377=5 -P232,374=6
# G9 Test
$TEST_WRITE --dataprovider 'test wci 0' --placename 'hirlam 10' --reftime '2004-12-26 06:00:00+00' --valueparameter 'instant temperature of air' -P164,161=2 -P165,160=2 -P165,161=2 -P165,162=2 -P166,159=2 -P166,160=2 -P166,161=2 -P166,162=2 -P166,163=2 -P167,158=2 -P167,159=2 -P167,160=2 -P167,161=2 -P167,162=2 -P167,163=2 -P167,164=2 -P168,159=2 -P168,160=2 -P168,161=2 -P168,162=2 -P168,163=2 -P169,160=2 -P169,161=2 -P169,162=2 -P170,161=2
# G11 Test
$TEST_WRITE --dataprovider 'test wci 0' --placename 'hirlam 10' --reftime '2004-12-26 06:00:00+00' --valueparameter 'max temperature of air' -P164,161=2 -P165,160=2 -P165,161=2 -P165,162=2 -P166,159=2 -P166,160=2 -P166,161=2 -P166,162=2 -P166,163=2 -P167,158=2 -P167,159=2 -P167,160=2 -P167,161=2 -P167,162=2 -P167,163=2 -P167,164=2 -P168,159=2 -P168,160=2 -P168,161=2 -P168,162=2 -P168,163=2 -P169,160=2 -P169,161=2 -P169,162=2 -P170,161=2 -P161,164=3 -P161,165=3 -P162,163=3 -P162,164=3 -P162,165=3 -P162,166=3 -P163,162=3 -P163,163=3 -P163,164=3 -P163,165=3 -P163,166=3 -P163,167=3 -P164,162=3 -P164,163=3 -P164,164=3 -P164,165=3 -P164,166=3 -P164,167=3 -P165,163=3 -P165,164=3 -P165,165=3 -P165,166=3 -P166,164=3 -P166,165=3
# G20 Test
$TEST_WRITE --dataprovider 'test wci 0' --placename 'hirlam 10' --reftime '2004-12-26 06:00:00+00' --valueparameter 'min temperature of air'  -P150,0=2
# G21 Test
$TEST_WRITE --dataprovider 'test wci 0' --placename 'hirlam 10' --reftime '2004-12-26 06:00:00+00' --valueparameter 'instant velocity of air'  -P150,0=2
# G22 Test
$TEST_WRITE --dataprovider 'test wci 0' --placename 'hirlam 10' --reftime '2004-12-26 06:00:00+00' --valueparameter 'instant velocity of air (u-component)' -P 150,0=2 -P 150,1=2 -P 151,0=2 -P 151,1=2
# G23, G24 Test
$TEST_WRITE --dataprovider 'test wci 0' --placename 'hirlam 10' --reftime '2004-12-26 06:00:00+00' --valueparameter 'instant velocity of air (v-component)' -P 175,0=2 -P 175,1=2 -P 176,0=3 -P 176,1=3
# G30 Test
$TEST_WRITE --dataprovider 'test wci 0' --placename 'hirlam 10' --reftime '2004-12-26 06:00:00+00' --valueparameter 'instant distance of snow' --initCoord

# ReferenceTime
$TEST_WRITE --dataprovider 'test wci 0' --placename 'test grid, rotated' --reftime '2007-01-11 06:00:00+00' --validtimefrom '2007-01-11 06:00:00+00' --validtimeto '2007-01-12 06:00:00+00'
$TEST_WRITE --dataprovider 'test wci 0' --placename 'test grid, rotated' --reftime '2007-01-12 06:00:00+00' --validtimefrom '2007-01-12 06:00:00+00' --validtimeto '2007-01-13 06:00:00+00'
$TEST_WRITE --dataprovider 'test wci 0' --placename 'test grid, rotated' --reftime '2007-01-13 06:00:00+00' --validtimefrom '2007-01-13 06:00:00+00' --validtimeto '2007-01-14 06:00:00+00'

# ValidTime
$TEST_WRITE --dataprovider 'test wci 0' --placename 'test grid, rotated' --reftime '2007-02-11 06:00:00+00' --validtimefrom '2007-02-11 06:00:00+00' --validtimeto '2007-02-11 18:00:00+00'
$TEST_WRITE --dataprovider 'test wci 0' --placename 'test grid, rotated' --reftime '2007-02-12 06:00:00+00' --validtimefrom '2007-02-12 06:00:00+00' --validtimeto '2007-02-12 06:00:00+00'
$TEST_WRITE --dataprovider 'test wci 0' --placename 'test grid, rotated' --reftime '2007-02-13 06:00:00+00' --validtimefrom '2007-02-13 06:00:00+00' --validtimeto '2007-02-13 18:00:00+00'
$TEST_WRITE --dataprovider 'test wci 0' --placename 'test grid, rotated' --reftime '2007-12-24 06:00:00+00' --validtimefrom '2007-12-24 06:00:00+00' --validtimeto '2007-12-24 12:00:00+00'

# Parameter
$TEST_WRITE --dataprovider 'test wci 0' --placename 'test grid, rotated' --reftime '2004-12-27 06:00:00+00' --valueparameter 'instant pressure of air'
$TEST_WRITE --dataprovider 'test wci 0' --placename 'test grid, rotated' --reftime '2004-12-27 06:00:00+00' --valueparameter 'instant pressure change of air'
$TEST_WRITE --dataprovider 'test wci 0' --placename 'test grid, rotated' --reftime '2004-12-27 06:00:00+00' --valueparameter 'instant temperature of air'
$TEST_WRITE --dataprovider 'test wci 0' --placename 'test grid, rotated' --reftime '2004-12-27 06:00:00+00' --valueparameter 'max temperature of air'
$TEST_WRITE --dataprovider 'test wci 0' --placename 'test grid, rotated' --reftime '2004-12-27 06:00:00+00' --valueparameter 'min temperature of air'
$TEST_WRITE --dataprovider 'test wci 0' --placename 'test grid, rotated' --reftime '2004-12-27 06:00:00+00' --valueparameter 'instant velocity of air'
$TEST_WRITE --dataprovider 'test wci 0' --placename 'test grid, rotated' --reftime '2004-12-27 06:00:00+00' --valueparameter 'instant velocity of air (u-component)'
$TEST_WRITE --dataprovider 'test wci 0' --placename 'test grid, rotated' --reftime '2004-12-27 06:00:00+00' --valueparameter 'instant velocity of air (v-component)'

# Level
$TEST_WRITE --dataprovider 'test wci 0' --placename 'test grid, rotated' --reftime '2004-12-28 06:00:00+00' --levelparameter 'distance above ground' --levelfrom 0 --levelto 0
$TEST_WRITE --dataprovider 'test wci 0' --placename 'test grid, rotated' --reftime '2004-12-28 06:00:00+00' --levelparameter 'distance above ground' --levelfrom 10 --levelto 10
$TEST_WRITE --dataprovider 'test wci 0' --placename 'test grid, rotated' --reftime '2004-12-28 06:00:00+00' --levelparameter 'distance above mean sea level' --levelfrom 10 --levelto 10

# DataVersion
# V1-V5 Test
$TEST_WRITE --dataprovider 'test wci 0' --placename 'test grid, rotated' --reftime '2004-12-29 06:00:00+00' --valueparameter 'instant pressure of air' --validtimefrom '2005-01-11 06:00:00+00' --validtimeto '2005-01-12 06:00:00+00' 
$TEST_WRITE --dataprovider 'test wci 0' --placename 'test grid, rotated' --reftime '2004-12-29 06:00:00+00' --valueparameter 'instant pressure of air' --validtimefrom '2005-01-11 06:00:00+00' --validtimeto '2005-01-12 06:00:00+00'
$TEST_WRITE --dataprovider 'test wci 0' --placename 'test grid, rotated' --reftime '2004-12-29 06:00:00+00' --valueparameter 'instant pressure of air' --validtimefrom '2005-01-11 06:00:00+00' --validtimeto '2005-01-12 06:00:00+00'
$TEST_WRITE --dataprovider 'test wci 0' --placename 'test grid, rotated' --reftime '2004-12-29 06:00:00+00' --valueparameter 'instant pressure of air' --validtimefrom '2005-01-11 06:00:00+00' --validtimeto '2005-01-12 06:00:00+00'
$TEST_WRITE --dataprovider 'test wci 0' --placename 'test grid, rotated' --reftime '2004-12-29 06:00:00+00' --valueparameter 'instant pressure of air' --validtimefrom '2005-01-11 06:00:00+00' --validtimeto '2005-01-12 06:00:00+00'
$TEST_WRITE --dataprovider 'test wci 0' --placename 'hirlam 10' --reftime '2004-12-29 06:00:00+00' --valueparameter 'instant pressure of air' --validtimefrom '2005-01-11 06:00:00+00' --validtimeto '2005-01-12 06:00:00+00' 
$TEST_WRITE --dataprovider 'test wci 0' --placename 'hirlam 10' --reftime '2004-12-29 06:00:00+00' --valueparameter 'instant pressure of air' --validtimefrom '2005-01-11 06:00:00+00' --validtimeto '2005-01-12 06:00:00+00' 
$TEST_WRITE --dataprovider 'test wci 4' --placename 'oslo' --reftime '2004-12-29 06:00:00+00' --valueparameter 'instant pressure of air' --validtimefrom '2005-01-11 06:00:00+00' --validtimeto '2005-01-12 06:00:00+00' 
$TEST_WRITE --dataprovider 'test wci 4' --placename 'oslo' --reftime '2004-12-29 06:00:00+00' --valueparameter 'instant pressure of air' --validtimefrom '2005-01-11 06:00:00+00' --validtimeto '2005-01-12 06:00:00+00' 
$TEST_WRITE --dataprovider 'test wci 4' --placename 'oslo' --reftime '2004-12-29 06:00:00+00' --valueparameter 'instant pressure of air' --validtimefrom '2005-01-11 06:00:00+00' --validtimeto '2005-01-12 06:00:00+00' 
$TEST_WRITE --dataprovider 'test wci 4' --placename 'oslo' --reftime '2004-12-29 06:00:00+00' --valueparameter 'instant pressure of air' --validtimefrom '2005-01-11 06:00:00+00' --validtimeto '2005-01-12 06:00:00+00' 
$TEST_WRITE --dataprovider 'test wci 4' --placename 'oslo' --reftime '2004-12-29 06:00:00+00' --valueparameter 'instant pressure of air' --validtimefrom '2005-01-11 06:00:00+00' --validtimeto '2005-01-12 06:00:00+00' 
# V6
$TEST_WRITE --dataprovider 'test wci 0' --placename 'test grid, rotated' --reftime '2004-12-29 06:00:00+00' --valueparameter 'instant proportion of ozone' --validtimefrom '2005-01-11 06:00:00+00' --validtimeto '2005-01-12 06:00:00+00' 
$TEST_WRITE --dataprovider 'test wci 0' --placename 'test grid, rotated' --reftime '2004-12-29 06:00:00+00' --valueparameter 'instant temperature of air' --validtimefrom '2005-01-11 06:00:00+00' --validtimeto '2005-01-12 06:00:00+00' 
$TEST_WRITE --dataprovider 'test wci 0' --placename 'test grid, rotated' --reftime '2004-12-29 06:00:00+00' --valueparameter 'instant temperature of air' --validtimefrom '2005-01-11 06:00:00+00' --validtimeto '2005-01-12 06:00:00+00'
$TEST_WRITE --dataprovider 'test wci 0' --placename 'test grid, rotated' --reftime '2004-12-29 06:00:00+00' --valueparameter 'instant temperature of air' --validtimefrom '2005-01-11 06:00:00+00' --validtimeto '2005-01-12 06:00:00+00' 
$TEST_WRITE --dataprovider 'test wci 4' --placename 'oslo' --reftime '2004-12-29 06:00:00+00' --valueparameter 'instant proportion of ozone' --validtimefrom '2005-01-11 06:00:00+00' --validtimeto '2005-01-12 06:00:00+00' 
$TEST_WRITE --dataprovider 'test wci 4' --placename 'oslo' --reftime '2004-12-29 06:00:00+00' --valueparameter 'instant temperature of air' --validtimefrom '2005-01-11 06:00:00+00' --validtimeto '2005-01-12 06:00:00+00' 
$TEST_WRITE --dataprovider 'test wci 4' --placename 'oslo' --reftime '2004-12-29 06:00:00+00' --valueparameter 'instant temperature of air' --validtimefrom '2005-01-11 06:00:00+00' --validtimeto '2005-01-12 06:00:00+00' 
$TEST_WRITE --dataprovider 'test wci 4' --placename 'oslo' --reftime '2004-12-29 06:00:00+00' --valueparameter 'instant temperature of air' --validtimefrom '2005-01-11 06:00:00+00' --validtimeto '2005-01-12 06:00:00+00' 
# V7
$TEST_WRITE --dataprovider 'test wci 0' --placename 'test grid, rotated' --reftime '2004-12-29 06:00:00+00' --valueparameter 'max temperature of air' --validtimefrom '2005-01-11 06:00:00+00' --validtimeto '2005-01-12 06:00:00+00' 
$TEST_WRITE --dataprovider 'test wci 0' --placename 'test grid, rotated' --reftime '2004-12-29 06:00:00+00' --valueparameter 'max temperature of air' --validtimefrom '2005-01-11 06:00:00+00' --validtimeto '2005-01-12 06:00:00+00' 
$TEST_WRITE --dataprovider 'test wci 4' --placename 'oslo' --reftime '2004-12-29 06:00:00+00' --valueparameter 'max temperature of air' --validtimefrom '2005-01-11 06:00:00+00' --validtimeto '2005-01-12 06:00:00+00' 
$TEST_WRITE --dataprovider 'test wci 4' --placename 'oslo' --reftime '2004-12-29 06:00:00+00' --valueparameter 'max temperature of air' --validtimefrom '2005-01-11 06:00:00+00' --validtimeto '2005-01-12 06:00:00+00' 
# V8
$TEST_WRITE --dataprovider 'test wci 0' --placename 'test grid, rotated' --reftime '2004-12-29 06:00:00+00' --valueparameter 'min temperature of air' --validtimefrom '2005-01-11 06:00:00+00' --validtimeto '2005-01-12 06:00:00+00' 
$TEST_WRITE --dataprovider 'test wci 0' --placename 'test grid, rotated' --reftime '2004-12-29 06:00:00+00' --valueparameter 'min temperature of air' --validtimefrom '2005-01-11 06:00:00+00' --validtimeto '2005-01-12 06:00:00+00' 
$TEST_WRITE --dataprovider 'test wci 0' --placename 'test grid, rotated' --reftime '2004-12-29 06:00:00+00' --valueparameter 'min temperature of air' --validtimefrom '2005-01-11 06:00:00+00' --validtimeto '2005-01-12 06:00:00+00' 
$TEST_WRITE --dataprovider 'test wci 4' --placename 'oslo' --reftime '2004-12-29 06:00:00+00' --valueparameter 'min temperature of air' --validtimefrom '2005-01-11 06:00:00+00' --validtimeto '2005-01-12 06:00:00+00' 
$TEST_WRITE --dataprovider 'test wci 4' --placename 'oslo' --reftime '2004-12-29 06:00:00+00' --valueparameter 'min temperature of air' --validtimefrom '2005-01-11 06:00:00+00' --validtimeto '2005-01-12 06:00:00+00' 
$TEST_WRITE --dataprovider 'test wci 4' --placename 'oslo' --reftime '2004-12-29 06:00:00+00' --valueparameter 'min temperature of air' --validtimefrom '2005-01-11 06:00:00+00' --validtimeto '2005-01-12 06:00:00+00' 

# Load Test Data
#$LOAD_GRIB_FILE --loadPlaceDefinition $GRIB_FILE
$LOAD_XML_FILE --dataprovider "test xml"   $XML_FILE1
$LOAD_XML_FILE --dataprovider "test wci 4" $XML_FILE2
$LOAD_XML_FILE --dataprovider "test xml"   $XML_FILE3

# Clean up Test File
#rm -f $GRIB_FILE
rm -f $XML_FILE1
rm -f $XML_FILE2
rm -f $XML_FILE3

# Exit
echo -e "# Generated test data..."
