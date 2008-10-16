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

-- feltload is a schema that contains views, functions and tables  
-- that are specific to the FeltLoad component 
CREATE SCHEMA feltload;
REVOKE ALL ON SCHEMA feltload FROM PUBLIC;
GRANT ALL ON SCHEMA feltload TO wdb_admin;
GRANT USAGE ON SCHEMA feltload TO wdb_felt;


CREATE TABLE feltload.valueparameterxref (
    feltparameter		integer NOT NULL,
	feltlevelparameter	integer NOT NULL,
    feltniveau1 		integer NOT NULL,
    feltniveau2			integer NOT NULL,
    valueparameterid	integer NOT NULL,
    loadvalueflag 		boolean NOT NULL
);

REVOKE ALL ON feltload.valueparameterxref FROM public;
GRANT ALL ON feltload.valueparameterxref TO wdb_admin;
GRANT SELECT ON feltload.valueparameterxref TO wdb_felt;


CREATE TABLE feltload.levelparameterxref (
    feltlevelparameter 	integer NOT NULL,
	feltniveau1lower	integer NOT NULL,
	feltniveau1upper	integer NOT NULL,
    levelparameterid	integer NOT NULL,
    loadlevelflag 		boolean NOT NULL
);

REVOKE ALL ON feltload.levelparameterxref FROM public;
GRANT ALL ON feltload.levelparameterxref TO wdb_admin;
GRANT SELECT ON feltload.levelparameterxref TO wdb_felt;


CREATE TABLE feltload.parametertolevelxref (
    feltparameter			integer NOT NULL,
	feltlevelparameter		integer NOT NULL,
	feltniveau1 			integer NOT NULL,
    feltniveau2				integer NOT NULL,
    levelparameterid 		integer NOT NULL,
    levelFrom 				real NOT NULL,
    levelTo 				real NOT NULL,
    levelIndeterminateCode 	integer NOT NULL,
    loadlevelflag 			boolean NOT NULL
);

REVOKE ALL ON feltload.parametertolevelxref FROM public;
GRANT ALL ON feltload.parametertolevelxref TO wdb_admin;
GRANT SELECT ON feltload.parametertolevelxref TO wdb_felt;

CREATE TABLE feltload.feltparametertovaliddurationxref (
	feltparameter integer NOT NULL,
	duration interval NOT NULL DEFAULT '0',
	durationIsFromReferenceTime bool NOT NULL DEFAULT 'f',
	infiniteDuration bool NOT NULL DEFAULT 'f'
);

REVOKE ALL ON feltload.feltparametertovaliddurationxref FROM public;
GRANT ALL ON feltload.feltparametertovaliddurationxref TO wdb_admin;
GRANT SELECT ON feltload.feltparametertovaliddurationxref TO wdb_felt;


--
-- DataProvider XREF
--
CREATE VIEW feltload.feltgeneratingprocess AS
SELECT
    dataproviderid,
    producerid,
    gridareanumber,
    feltprocessvalidfrom,
    feltprocessvalidto	
FROM
	__WDB_SCHEMA__.feltgeneratingprocess;

REVOKE ALL ON feltload.feltgeneratingprocess FROM public;
GRANT ALL ON feltload.feltgeneratingprocess TO wdb_admin;
GRANT SELECT ON feltload.feltgeneratingprocess TO wdb_felt;


CREATE OR REPLACE FUNCTION 
feltload.getdataprovider(
	producerid 		integer,
	gridareanumber 	integer,
	refTime 		timestamp with time zone
)
RETURNS SETOF bigint AS
$BODY$
	SELECT 	dataproviderid
	FROM 	feltload.feltgeneratingprocess
	WHERE
		producerid = $1 AND
		gridareanumber = $2 AND
		feltprocessvalidfrom <= $3 AND
		feltprocessvalidto >= $3;
$BODY$
LANGUAGE 'sql';


--
-- Add new placeId
--
CREATE OR REPLACE FUNCTION 
feltload.setplaceid(
	placegeo_ 	text,
	placesrid_ 	integer,
	inumber_ 	integer,
	jnumber_ 	integer,
	iincrement_ real,
	jincrement_ real,
	startLon_ 	real,
	startLat_ 	real,
	origsrid_ 	integer
)
RETURNS bigint AS
$BODY$
DECLARE
	ret bigint;
BEGIN
	--INSERT INTO __WDB_SCHEMA__.placedefinition ( placeindeterminatecode, placegeometrytype, placestoretime, placegeometry)
	--VALUES ( 0, 'Grid', CURRENT_TIMESTAMP, geomfromtext(placegeo_, 4030) );

	SELECT nextval( '__WDB_SCHEMA__.placedefinition_placeid_seq' ) INTO ret;
	
	INSERT INTO __WDB_SCHEMA__.placeregulargrid ( placeid, inumber, jnumber, iincrement, jincrement, startlongitude, startlatitude, originalsrid)
	VALUES ( ret, inumber_, jnumber_, iincrement_, jincrement_, startLon_, startLat_, origsrid_ );

	INSERT INTO __WDB_SCHEMA__.placename ( placeid, placenamespaceid, placename, placenamevalidfrom, placenamevalidto )
	VALUES ( ret, 0, 'Automatic insertion by feltLoad '::text || CURRENT_TIMESTAMP::text, CURRENT_DATE, '12-31-2999' );

	RETURN ret;
END;
$BODY$
SECURITY DEFINER
LANGUAGE 'plpgsql' STRICT VOLATILE;


--
-- ValueParameter XREF
--
CREATE OR REPLACE FUNCTION 
feltload.getvalueparameter(
	feltparam		integer,
	feltlevelparam	integer,
	feltnv1			integer,
	feltnv2			integer
)
RETURNS SETOF integer AS
$BODY$
DECLARE
	ret integer;
	load boolean;
BEGIN
	SELECT valueparameterid, loadvalueflag INTO ret, load
	FROM feltload.valueparameterxref
	WHERE
        feltparameter = feltparam AND
		feltlevelparameter = feltlevelparam AND
		feltniveau1 = feltnv1 AND
		feltniveau2 = feltnv2;
	-- Check load
	IF load = false THEN
		RETURN NEXT -1;
	END IF;
	IF load = true THEN
		RETURN NEXT ret;
	END IF;
	RETURN;
END;
$BODY$
LANGUAGE 'plpgsql' STRICT STABLE;


--
-- Get additional level information
-- Dependent on the parameter!
--
CREATE OR REPLACE FUNCTION 
feltload.getlevelfromparameter(
	feltparam		integer,
	feltlevelparam	integer,
	feltnv1			integer,
	feltnv2			integer
)
RETURNS SETOF feltload.parametertolevelxref AS
$BODY$
	SELECT *
	FROM feltload.parametertolevelxref
	WHERE
        feltparameter = $1 AND
		feltlevelparameter = $2 AND
		feltniveau1 = $3 AND
		feltniveau2 = $4;
$BODY$
LANGUAGE 'sql';


--
-- LevelParameter XREF
--
CREATE OR REPLACE FUNCTION 
feltload.getlevelparameter( 
	levelParam integer, 
	levelnv1 integer 
)
RETURNS SETOF integer AS
$BODY$
DECLARE
	ret integer;
	load boolean;
BEGIN
	SELECT levelparameterid, loadlevelflag INTO ret, load
	FROM feltload.levelparameterxref
	WHERE
		feltlevelparameter = levelParam AND
		feltniveau1lower <= levelnv1 AND
		feltniveau1upper >= levelnv1;
	-- Check load
	IF load = false THEN
		RETURN NEXT -1;
	END IF;
	IF load = true THEN
		RETURN NEXT ret;
	END IF;
	RETURN;
END;
$BODY$
LANGUAGE 'plpgsql';
