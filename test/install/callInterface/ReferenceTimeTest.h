/*
    wdb - weather and water data storage

    Copyright (C) 2007 met.no

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


#ifndef REFERENCETIMETEST_H_
#define REFERENCETIMETEST_H_

#include <AbstractWciTestFixture.h>

/**
 * @addtogroup Tests
 * @{
 * @addtogroup wci_test
 * @{
 */

/**
 * Test fixture for referenceTime parameter in wciRead.
 *
 * @see WDB Call Interface System Test Specification contains details
 * about the tests.
 */
class ReferenceTimeTest : public AbstractWciTestFixture
{
	CPPUNIT_TEST_SUITE( ReferenceTimeTest );

	CPPUNIT_TEST( testR1_01A_ValidInterval );
	//CPPUNIT_TEST( testR1_01B_ValidInterval );
	CPPUNIT_TEST( testR1_02A_ValidTimePoint );
	//CPPUNIT_TEST( testR1_02B_ValidTimePoint );
	CPPUNIT_TEST( testR1_04A_InvalidTime );
	CPPUNIT_TEST( testR1_04B_InvalidTime );
	CPPUNIT_TEST( testR1_05A_NotATimestamp );
	CPPUNIT_TEST( testR1_05B_NotATimestamp );
	CPPUNIT_TEST( testR1_06A_Null );
	//CPPUNIT_TEST( testR1_06B_Null );

	CPPUNIT_TEST( testR2_01A_Now );
	CPPUNIT_TEST( testR2_01B_Now );
	CPPUNIT_TEST( testR2_02A_Past );
	//CPPUNIT_TEST( testR2_02B_Past );
	CPPUNIT_TEST( testR2_03A_Future );
	CPPUNIT_TEST( testR2_03B_Future );

	CPPUNIT_TEST_SUITE_END();
public:
	ReferenceTimeTest();
	virtual ~ReferenceTimeTest();

	// Type
	void testR1_01A_ValidInterval();
	void testR1_01B_ValidInterval();
	void testR1_02A_ValidTimePoint();
	void testR1_02B_ValidTimePoint();
	void testR1_04A_InvalidTime();
	void testR1_04B_InvalidTime();
	void testR1_05A_NotATimestamp();
	void testR1_05B_NotATimestamp();
	void testR1_06A_Null();
	void testR1_06B_Null();

	// Time
	void testR2_01A_Now();
	void testR2_01B_Now();
	void testR2_02A_Past();
	void testR2_02B_Past();
	void testR2_03A_Future();
	void testR2_03B_Future();

private:
	std::string statementOid_( const std::string & timeSpec ) const;
	std::string statementFloat_( const std::string & timeSpec ) const;
};

/**
 * @}
 * @}
 */

#endif /*REFERENCETIMETEST_H_*/
