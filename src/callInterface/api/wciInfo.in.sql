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

-- dataprovider info by name
-- returns wci.infodataprovider
CREATE OR REPLACE FUNCTION 
wci.info( dataprovider 		text[], 
		  returntype 		 wci.infodataprovider )	
RETURNS SETOF wci.infodataprovider AS
$BODY$
DECLARE
	infoQuery 		text;
	entry 			wci.infodataprovider;
BEGIN
	-- Create Query to Run
	infoQuery := 'SELECT dataprovidername, dataprovidertype, spatialdomaindelivery,
						 dataprovidercomment, dataproviderstoretime 
			      FROM   __WCI_SCHEMA__.dataprovider_mv dp 
						 INNER JOIN __WCI_SCHEMA__.getSessionData() s ON (dp.dataprovidernamespaceid = s.dataprovidernamespaceid)';
						 --LEFT OUTER JOIN __WDB_SCHEMA__.dataprovidercomment dc ON (dp.dataproviderid = dc.dataproviderid)';
	IF dataprovider IS NOT NULL THEN
		infoQuery := infoQuery || ' WHERE dataprovidername LIKE ' || dataprovider;
	END IF;
	RAISE DEBUG 'WCI.INFO.Query: %', infoQuery;

	<<main_select>>
	FOR entry IN
		EXECUTE infoQuery
	LOOP
		RETURN NEXT entry;
	END LOOP main_select;
END;
$BODY$
LANGUAGE 'plpgsql' STABLE;



-- place info by name
-- returns wci.infoplace
--   PlaceName
--   min ReferenceTime
--   max ReferenceTime
--   count 
CREATE OR REPLACE FUNCTION 
wci.info( location 			text,
		  returntype 		wci.infoplace
)	
RETURNS SETOF wci.infoplace AS
$BODY$
DECLARE
	infoQuery 		text;
	entry 			wci.infoplace;
BEGIN
	-- Create Query to Run
	infoQuery := 'SELECT placename, astext(placegeometry), 
						 placeindeterminatetype, placegeometrytype,
						 placestoretime 
				  FROM __WCI_SCHEMA__.placespec ps,
					   __WCI_SCHEMA__.getSessionData() s 
				  WHERE  
						s.placenamespaceid = ps.placenamespaceid';-- AND 
--						pd.placeindeterminatecode = pi.placeindeterminatecode';

-- pd.placeid = pn.placeid AND
--						__WCI_SCHEMA__.placedefinition pd, 
--					   __WCI_SCHEMA__.placename pn, 
--					   __WCI_SCHEMA__.placeindeterminatetype pi, 


	IF location IS NOT NULL THEN
		infoQuery := infoQuery || ' AND placename LIKE ' || location;
	END IF;
	RAISE DEBUG 'WCI.INFO.Query: %', infoQuery;

	<<main_select>>
	FOR entry IN
		EXECUTE infoQuery
	LOOP
		RETURN NEXT entry;
	END LOOP main_select;
END;
$BODY$
LANGUAGE 'plpgsql' STABLE;


CREATE OR REPLACE FUNCTION 
wci.info( placename_ 		text,
		  returntype 		wci.inforegulargrid
)	
RETURNS SETOF wci.inforegulargrid AS
$BODY$
DECLARE
	entry 			wci.inforegulargrid;
BEGIN
	IF placeid_ IS NULL THEN
		FOR entry IN 
		SELECT
			placename,
			iNumber,
			jNumber,
			iIncrement,
			jIncrement,
			startLatitude,
			startLongitude,
			projDefinition
		FROM 
			__WCI_SCHEMA__.placespec 
		LOOP
			RETURN NEXT entry;
		END LOOP;
	ELSE
		FOR entry IN 
		SELECT
			placename,
			iNumber,
			jNumber,
			iIncrement,
			jIncrement,
			startLatitude,
			startLongitude,
			projDefinition
		FROM 
			__WCI_SCHEMA__.placespec
		WHERE
			placename_=placename
		LOOP
			RETURN NEXT entry;
		END LOOP;
	END IF;
END;
$BODY$
LANGUAGE 'plpgsql' STABLE;



-- place info by name
-- returns wci.infovalueparameter
--   valueparametername
--   valueunitname
--   count 
CREATE OR REPLACE FUNCTION 
wci.info( parameter 		text,
		  returntype 		wci.infovalueparameter )	
RETURNS SETOF wci.infovalueparameter AS
$BODY$
DECLARE
	infoQuery 		text;
	entry 			wci.infovalueparameter;
BEGIN
	-- Create Query to Run
	infoQuery := 'SELECT valueparametername, valueunitname as valueunitnameorref
				  FROM __WCI_SCHEMA__.valueparameter_mv vp, __WCI_SCHEMA__.getSessionData s
				  WHERE vp.parameternamespaceid = s.parameternamespaceid';
	IF parameter IS NOT NULL THEN
		infoQuery := infoQuery || ' AND valueparametername LIKE ' || parameter;
	END IF;
	RAISE DEBUG 'WCI.INFO.Query: %', infoQuery;

	<<main_select>>
	FOR entry IN
		EXECUTE infoQuery
	LOOP
		RETURN NEXT entry;
	END LOOP main_select;
END;
$BODY$
LANGUAGE 'plpgsql' STABLE;



-- place info by name
-- returns wci.infolevelparameter
--   levelparametername
--   levelunitname
--   levelfrom
--   levelto
--   count 
CREATE OR REPLACE FUNCTION 
wci.info( parameter 		text,
		  returntype 		wci.infolevelparameter )	
RETURNS SETOF wci.infolevelparameter AS
$BODY$
DECLARE
	infoQuery 		text;
	entry 			wci.infolevelparameter;
BEGIN
	-- Create Query to Run
	infoQuery := 'SELECT levelparametername, levelunitname as levelunitnameorref
				  FROM __WCI_SCHEMA__.levelparameter_mv lp, __WCI_SCHEMA__.getSessionData s
				  WHERE lp.parameternamespaceid = s.parameternamespaceid';
	IF parameter IS NOT NULL THEN
		infoQuery := infoQuery || ' AND levelparametername LIKE ' || parameter;
	END IF;
	RAISE DEBUG 'WCI.INFO.Query: %', infoQuery;

	<<main_select>>
	FOR entry IN
		EXECUTE infoQuery
	LOOP
		RETURN NEXT entry;
	END LOOP main_select;
END;
$BODY$
LANGUAGE 'plpgsql' STABLE;
