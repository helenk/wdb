-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- 
-- wdb - weather and water data storage
--
-- Copyright (C) 2008 met.no
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

-- migratedata
-- This function migrates data from an old database version (using wci.read)
-- to a new database. It relies on the wci.read of the old databases being
-- stable, and being able to retrieve ALL required data through the WCI 
-- interface. It only utilizes the 0 namespace.
CREATE OR REPLACE FUNCTION 
__WCI_SCHEMA__.migratetest( )
RETURNS void AS
$BODY$
DECLARE
	dataProviderId_ 		  bigint;
	placeId_ 				  bigint;
	valueParameterId_ 		  integer;
	levelParameterId_ 		  integer;
	valGid					  wci.returngid;
	valFlt					  wci.returnfloat;
BEGIN
	-- TODO: Check database version. If the database version of the old database
	-- is too ancient, abort with an error message

	-- Transfer the GID Data Values
	-- Read all raw data using wci.read
	FOR valGid IN
		SELECT * FROM wci.read( NULL, NULL, NULL, NULL,
								NULL, NULL, NULL, NULL::wci.returnGid )
	LOOP
		dataProviderId_ 		  := __WCI_SCHEMA__.getDataProviderId( valGid.dataProviderName );
		placeId_ 				  := __WCI_SCHEMA__.getPlaceId( valGid.placename );
		valueParameterId_ 		  := __WCI_SCHEMA__.getvalueparameterid( valGid.valueParameterName );
		levelParameterId_ 		  := __WCI_SCHEMA__.getlevelparameterid( valGid.levelParameterName ); 
	END LOOP;
	-- TODO: Error handling. If a value can not be inserted into the database
	-- (e.g., because of missing metadata), the migrate operation should either
	-- abort (if so, we need to implement the possibility of a dry-run migration),
	-- or we should be able to save the data ported.
	
	-- After reading all raw data, we will need to pick up any "detailed" info
	-- for the data values (e.g., data import information, quality information, etc)
	-- Also, there should be the possibility to run both pre- and post- operations
	-- to the data migration.

	-- Transfer the FLOAT Raw Data Values
	-- Read all raw data using wci.read
	FOR valFlt IN
		SELECT * FROM wci.read( NULL, NULL, NULL, NULL,
								NULL, NULL, NULL, NULL::wci.returnFloat )
	LOOP
		dataProviderId_ 		  := __WCI_SCHEMA__.getDataProviderId( valFlt.dataProviderName );
		placeId_ 				  := __WCI_SCHEMA__.getPlaceId( valFlt.placename );
		valueParameterId_ 		  := __WCI_SCHEMA__.getvalueparameterid( valFlt.valueParameterName );
		levelParameterId_ 		  := __WCI_SCHEMA__.getlevelparameterid( valFlt.levelParameterName ); 
	END LOOP;
	-- TODO: Error handling. If a value can not be inserted into the database
	-- (e.g., because of missing metadata), the migrate operation should either
	-- abort (if so, we need to implement the possibility of a dry-run migration),
	-- or we should be able to save the data ported.

	-- After reading all raw data, we will need to pick up any "detailed" info
	-- for the data values (e.g., data import information, quality information, etc)
	-- Also, there should be the possibility to run both pre- and post- operations
	-- to the data migration.

END 
$BODY$
LANGUAGE 'plpgsql';

SELECT wci.begin ( 'wdb', 0, 0, 0 );
SELECT __WCI_SCHEMA__.migratetest( );

DROP FUNCTION __WCI_SCHEMA__.migratetest( );