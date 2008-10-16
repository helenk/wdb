/*
    wdb - weather and water data storage

    Copyright (C) 2008 met.no

    Contact information:
    Norwegian Meteorological Institute
    Box 43 Blindern
    0313 OSLO
    NORWAY
    E-mail: wdb@met.no

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
    MA  02110-1301, USA
*/


#ifdef HAVE_CONFIG_H
#include <config.h>
#endif
//#include <WdbProjection.h>
#include "TestWriteConfiguration.h"
#include "GridWriter.h"
#include <wdbLogHandler.h>
#include <iostream>
#include <fstream>
#include <exception>
#include <cassert>

using namespace std;
using namespace wdb;


// Support Functions
namespace
{

/**
 * Write the program version to stream
 * @param	out		Stream to write to
 */
void version( ostream & out )
{
	out << "testWrite (" << PACKAGE << ") " << VERSION << endl;
}

/**
 * Write help information to stram
 * @param	options		Description of the program options
 * @param	out			Stream to write to
 */
void help( const boost::program_options::options_description & options, ostream & out )
{
	version( out );
	out << '\n';
    out << "Usage: testWrite [OPTIONS]\n\n";
    out << "This application is used to insert test data into the database using\n"
		<< "the WCI write interface. You may load synthor grids) or specify the data\n"
		<< "value (for points and grids). When specifying individual points, x and y\n"
		<< "are the coordinates of the point you wish to assign a value. The '=n' \n"
		<< "part is optional. If ommitted, the default value 1 will be assigned.\n\n" << endl;

    out << "Options:\n";
    out << options << endl;
}

} // namespace

int main( int argc, char** argv )
{
	wdb::TestWriteConfiguration conf;
    try
    {
    	conf.parse( argc, argv );
    	if ( conf.general().help ) {
    		help( conf.shownOptions(), cout );
    		return 0;
    	}
    	if ( conf.general().version ) {
    		version( cout );
    		return 0;
    	}
    }
    catch( exception & e ) {
        cerr << e.what() << endl;
        help( conf.shownOptions(), clog );
        return 1;
    }

	WdbLogHandler logHandler( conf.logging().loglevel, conf.logging().logfile );
    WDB_LOG & log = WDB_LOG::getInstance( "wdb.testWrite.main" );

    log.debug( "Starting testWrite" );
    try
    {
    	wdb::database::GridWriter data( conf.database().pqDatabaseConnection() );
    	data.write( conf );
        // Options for GRIB writing
        //GribWriter::Options opt( GribWriter::Options::Today,
         //                        GribWriter::Options::GeoNone );

        // Parse command line
    	//TestWriteConfiguration cmdOpt( );
        /*
         CommandLineParser cmdOpt( opt );
        CommandLineParser::ParseResult res = cmdOpt.parse( argc, argv );
        if ( CommandLineParser::ExitOk == res )
            return 0;
        if ( CommandLineParser::Error == res )
            return 1;
        */
        /*
        // Create the writer
        GribWriter w( cmdOpt.get().output_file, cmdOpt.get().overwrite );

        // Initialize and set section 4 data (possibly from file):
        GribWriter::Sec4 grid( opt.sec4Size() );
        grid[0] = 1;
        const string & inputFile = cmdOpt.get().input_file;
        if ( ! inputFile.empty() )
        {
            if ( inputFile == "-" )
            	if ( ! fillVector( grid, cin ) )
            		throw std::runtime_error( "<stdin> - Error when reading GRIB section 4" );
            else
            {
                ifstream f( inputFile.c_str() );
                if ( ! f )
                    throw std::runtime_error( inputFile + " - Cannot open file" );
                if ( ! fillVector( grid, f ) )
                	throw std::runtime_error( inputFile + " - Error when reading GRIB section 4" );
            }
        }

        const PointSpec & ps = cmdOpt.get().pointsToSet;
        for ( PointSpec::const_iterator it = ps.begin(); it != ps.end(); ++ it )
        {
            const PointSpec::size_type index = index_from_xy( it->x(), it->y(), opt.geo.iNum, opt.geo.jNum );
            if ( grid.size() < index )
            {
            	const std::string point = it->str();
                throw std::runtime_error( "GRIB section4 index out of range: " +
                                          point.substr( 0, point.find_first_of( '=' ) ) );
            }
        	const std::string point = it->str();
        	cout << point;
            grid[ index ] = it->val();
        }*/

        // Write GRIB to file
        //w.write( opt, grid );
    }
    catch ( std::exception & e )
    {
        clog << e.what() << endl;
        return 1;
    }
    catch ( ... )
    {
        clog << "Unknown error" << endl;
        return 1;
    }
    return 0;
}
