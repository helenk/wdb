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
# Help Info
export SCRIPT_USAGE="Usage: $0 [OPTION]

Description: Script for running the installation tests for the WDB
Call Interface (wci)

(See wdb_call-interface_system-test-specification for details)

Options:
--help             display this help and exit
--version          output version information and exit
--xml,-x		   output tests results in JUnit XML
--ouput=FILE, -o FILE
                   output test log to <FILE>
"

export SCRIPT_VERSION=__WDB_VERSION__
export TEST_PATH=__WDB_BUILDDIR__/test/install/callInterface
RUN_TEST_PROGRAM="__WDB_BUILDDIR__/wciInstallTester --nowarn -oc"

# Parse command line
while test -n "$1"; do
	case $1 in
    --help) 
    	echo "$SCRIPT_USAGE"; exit 0;;
    --version) 
    	echo "$0 $SCRIPT_VERSION"; exit 0;;
    --xml)
		RUN_TEST_PROGRAM="__WDB_BUILDDIR__/wciInstallTester --nowarn -o X" 
		shift
		continue;;
    -x)
		RUN_TEST_PROGRAM="__WDB_BUILDDIR__/wciInstallTester --nowarn -o X"
		shift
		continue;;
	--output=*)
	    LOGFILE=`echo $1 | sed 's/--output=//'`
	    shift
	    continue;;
	-o)
	    shift
	    LOGFILE=`echo $1`
	    shift
	    continue;;
	*)
		echo -n "Did not recognize the option "; echo $1
		echo " "
    	echo "$SCRIPT_USAGE"; exit 0;;
	esac
done
echo -e "#\n# callInterface Installation Tests\n"

source ${TEST_PATH}/tearDown.sh
source ${TEST_PATH}/buildUp.sh

# Create the writer for the wci write tests:
__WDB_BINDIR__/wdb createuser wcitestwriter write


# Run Tests
if test -n "$LOGFILE"; then 
	${RUN_TEST_PROGRAM} &> ${LOGFILE}
else
	${RUN_TEST_PROGRAM}
fi
if test "$?" -ne "0"; then
	#source ${TEST_PATH}/tearDown.sh
   	exit 1
fi

#source ${TEST_PATH}/tearDown.sh

# Print Test Result    
echo -e "#\n# callInterface Installation Tests done\n#"

