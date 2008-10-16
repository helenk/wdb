-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- 
-- wdb - weather and water data storage
--
-- Copyright (C) 2007 met.no
--
--  Contact information:
--  Norwegian Meteorological Institute
--  Box 43 Blindern
--  0313 OSLO
--  NORWAY
--  E-mail: wdb@met.no
--
--  This is free software; you can redistribute it and/or modify
--  it under the terms of the GNU General Public License as published by
--  the Free Software Foundation; either version 2 of the License, or
--  (at your option) any later version.
--
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- Get parameterids from the given parameter characteristics.
--
-- If any of the provided function arguments are NULL, all parameterids 
-- mathcing the other function arguments are returned.
--
-- @param statisticsType
-- @param physicalPhenomena
-- @param usageArea
--
-- @return An array of parameterids matching the given parameter 
--         characteristics.
CREATE OR REPLACE FUNCTION
wci.idFromParameter
(
          statisticsType    CHARACTER VARYING(80),
          physicalPhenomena CHARACTER VARYING(80),
          usageArea         CHARACTER VARYING(80)
)
RETURNS integer[] AS
$BODY$
	SELECT ARRAY(
		SELECT 
			parameterid
		FROM 
			__WCI_SCHEMA__.parameter 
		WHERE 
			( $1 IS NULL OR statisticstype = $1 )     AND
			( $2 IS NULL OR physicalPhenomena = $2 ) AND
			( $3 IS NULL OR usageArea = $3 )
	);
$BODY$
LANGUAGE 'sql';



-- Get parameter characteristics from the given parameterids.
--
-- @param parameterid[] An array of parameterids which we are interested in
--                      information about.
--
-- @return A set of parameter characteristics.
CREATE OR REPLACE FUNCTION
wci.parameterFromId
(
          parameterid int[]
)
RETURNS SETOF __WCI_SCHEMA__.parameter AS
$BODY$
	SELECT 
		* 
	FROM 
		__WCI_SCHEMA__.parameter
	WHERE 
		$1 IS NULL OR
		parameterid = ANY ( $1 );
$BODY$
LANGUAGE 'sql';
