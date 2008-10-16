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


#ifndef GRIDPOINT_H_
#define GRIDPOINT_H_

#include <string>
#include <iostream>
#include <stdexcept>
#include <vector>

/**
 * @addtogroup common
 * @{
 * @addtogroup configuration
 * @{
 */


/**
 * A specification of the desired value for a single grid point in a field
 * specification
 */
class GridPoint
{
public:

	/**
	 * Construct a GridPoint where fields are all 0.
	 */
	GridPoint();

	/**
	 * Construct a GridPoint based on the input string.
	 *
	 * The input string is of the format "x,y[=val]". If val is left out, it
	 * defaults to 1.
	 *
	 * Example: "43,2"     - point 43,2 gets value 1.
	 *          "12,4=7.1" - point 12,4 gets value 7.1.
	 *
	 * @throws std::logic_error if the provided input string cannot be
	 * interpreted as a GridPoint.
	 */
	explicit GridPoint( const std::string & point );

	virtual ~GridPoint();

	std::string str() const;

	/// Get the x dimension of the point.
	int x() const { return x_; }

	/// Get the y dimension of the point.
	int y() const { return y_; }

	/// Get the desired value for the given point.
	double val() const { return val_; }

private:

	int x_;
	int y_;
	double val_;
};

/**
 * A set of Grid points.
 */
typedef std::vector<GridPoint> GridPointList;


inline std::ostream & operator << ( std::ostream & s, const GridPoint & p )
{
	s << p.x() << ',' << p.y();
	if ( p.val() != 1 )
		s << '=' << p.val();
	return s;
}

inline std::istream & operator >> ( std::istream & s, GridPoint & p )
{
	std::string data;
	s >> data;

	if ( s )
	{
		try
		{
			p = GridPoint( data );
		}
		catch ( std::logic_error & )
		{
			s.setstate( std::ios_base::failbit );
		}
	}
	return s;
}

/// @}
/// @}

#endif /*GRIDPOINT_H_*/
