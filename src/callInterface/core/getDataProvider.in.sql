-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- 
-- wdb - weather and water data storage
--
-- Copyright (C) 2009 met.no
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

-- 
-- Get dataproviderid from the given name
--
-- @param providerName The name of the data provider
--
-- @return the matching dataproviderid
CREATE OR REPLACE FUNCTION
__WCI_SCHEMA__.getDataProviderId
(
	providerName    character varying(80)
)
RETURNS bigint AS
$BODY$
	SELECT 
		DISTINCT dataproviderid
	FROM 
		__WCI_SCHEMA__.dataprovider
	WHERE 
		( dataprovidername = $1 );
$BODY$
LANGUAGE 'sql' STABLE;


--
-- Get all dataproviderids and sub-dataproviderids from the given name
--
CREATE OR REPLACE FUNCTION
wci_0_9_6.getdataprovideridlist(dataprovidername_ text)
RETURNS SETOF bigint AS
$BODY$
DECLARE
	requestedDataProvder wci_0_9_6.dataprovider_mv;
BEGIN
	SELECT * INTO requestedDataProvder FROM wci_0_9_6.dataprovider_mv WHERE dataprovidername=dataprovidername_;

	RETURN QUERY
	SELECT 
		dataproviderid 
	FROM 
		wci_0_9_6.dataprovider_mv d
	WHERE 
		requestedDataProvder.dataprovidernameleftset <= d.dataprovidernameleftset AND
		requestedDataProvder.dataprovidernamerightset >= d.dataprovidernamerightset;
END;
$BODY$
LANGUAGE plpgsql STRICT STABLE;
