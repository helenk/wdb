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
-- add New Place Definition
-- 
CREATE OR REPLACE FUNCTION
wci.addPlacePoint(
	placeName_ 		text,
	placeGeometry_ 	geometry
)
RETURNS bigint AS
$BODY$
DECLARE
	placeId_ 	bigint;
	namespace_	int;
	newname_	text;
	indCode_ 	int;
BEGIN
	-- Get namespace
	SELECT placenamespaceid INTO namespace_
	FROM __WCI_SCHEMA__.getSessionData();
	-- Indeterminate Code 1 = Exact
	indCode_ := 1;	
	-- Check that geometry is POINT
	IF GeometryType( placeGeometry_ ) <> 'POINT' THEN
		RAISE EXCEPTION 'Place geometry passed to function is not a WKB point';
	END IF;	
	-- Get placedef
	SELECT placeid INTO placeId_ 
	FROM  __WCI_SCHEMA__.placedefinition
	WHERE st_equals( placegeometry, placeGeometry_) AND
		  placenamespaceid = 0;
	-- Add dataprovider
	IF NOT FOUND THEN
		placeId_ := nextval('__WDB_SCHEMA__.placedefinition_placeid_seq');
		INSERT INTO __WDB_SCHEMA__.placedefinition VALUES
		( placeId_, indCode_, 'point', 'now', placeGeometry_ );
		IF namespace_ <> 0 THEN
			INSERT INTO __WDB_SCHEMA__.placename VALUES
			( placeId_, namespace_, lower(placeName_), 'today', 'infinity' );
		END IF;
	ELSE
		IF namespace_ <> 0 THEN
			PERFORM * 
			FROM  __WDB_SCHEMA__.placename
			WHERE placenamespaceid = namespace_;
			IF NOT FOUND THEN
				INSERT INTO __WDB_SCHEMA__.placename VALUES
				( placeId_, namespace_, lower(placeName_), 'today', 'infinity' );
			ELSE
				UPDATE __WDB_SCHEMA__.placename 
				SET placename = lower(placeName_)
				WHERE placeid = placeId_;
			END IF;
		END IF;
	END IF;
	RETURN placeId_;
END;
$BODY$
SECURITY DEFINER
LANGUAGE plpgsql VOLATILE;



--
-- add New Place Definition
-- 
CREATE OR REPLACE FUNCTION
wci.addPlacePolygon(
	placeName_ 		text,
	placeGeometry_ 	geometry
)
RETURNS bigint AS
$BODY$
DECLARE
	placeId_ 	bigint;
	namespace_	int;
	newname_	text;
	indCode_ 	int;
BEGIN
	-- Get namespace
	SELECT placenamespaceid INTO namespace_
	FROM __WCI_SCHEMA__.getSessionData();
	-- Indeterminate Code 1 = Exact
	indCode_ := 1;	
	-- Check that geometry is POINT
	IF GeometryType( placeGeometry_ ) <> 'POLYGON' THEN
		RAISE EXCEPTION 'Place geometry passed to function is not a WKB polygon';
	END IF;	
	-- Get placedef
	SELECT placeid INTO placeId_ 
	FROM  __WCI_SCHEMA__.placedefinition
	WHERE st_equals( placegeometry, placeGeometry_) AND
		  placenamespaceid = 0;
	-- Add dataprovider
	IF NOT FOUND THEN
		placeId_ := nextval('__WDB_SCHEMA__.placedefinition_placeid_seq');
		INSERT INTO __WDB_SCHEMA__.placedefinition VALUES
		( placeId_, indCode_, 'polygon', 'now', placeGeometry_ );
		IF namespace_ <> 0 THEN
			INSERT INTO __WDB_SCHEMA__.placename VALUES
			( placeId_, namespace_, lower(placeName_), 'today', 'infinity' );
		END IF;
	ELSE
		IF namespace_ <> 0 THEN
			PERFORM * 
			FROM  __WDB_SCHEMA__.placename
			WHERE placenamespaceid = namespace_;
			IF NOT FOUND THEN
				INSERT INTO __WDB_SCHEMA__.placename VALUES
				( placeId_, namespace_, lower(placeName_), 'today', 'infinity' );
			ELSE
				UPDATE __WDB_SCHEMA__.placename 
				SET placename = lower(placeName_)
				WHERE placeid = placeId_;
			END IF;
		END IF;
	END IF;
	RETURN placeId_;
END;
$BODY$
SECURITY DEFINER
LANGUAGE plpgsql VOLATILE;


--
-- add New Place Definition (Regular Grid)
-- 
CREATE OR REPLACE FUNCTION
wci.addPlaceRegularGrid(
	placeName_ 	text,
	numX_ 		int,
	numY_ 		int,
	incX_ 		float,
	incY_ 		float,
	startX_ 	float,
	startY_ 	float,
	projection_ text
)
RETURNS bigint AS
$BODY$
DECLARE
	placeId_ 	bigint;
	namespace_ 	int;
	newname_ 	text;
	srid_ 		int;
BEGIN
	-- Get Namespace
	SELECT placenamespaceid INTO namespace_
	FROM __WCI_SCHEMA__.getSessionData();
	-- Get SRID
	SELECT srid INTO srid_
	FROM spatial_ref_sys
	WHERE btrim(proj4text) = btrim(projection_);
	-- If SRID not found...
	IF srid_ IS NULL THEN
		RAISE EXCEPTION 'Could not identify the PROJ.4 projection in the database. Check that the projection is valid and, if needed, insert it into the database using wci.addSrid( ... )';		
	END IF;
	-- Get placedef
	SELECT placeid INTO placeId_ 
	FROM  __WCI_SCHEMA__.placeregulargrid_mv
	WHERE numberx = numX_ AND
		  numbery = numY_ AND
		  round(incrementx::numeric, 3) = round(incX_::numeric, 3) AND
		  round(incrementy::numeric, 3) = round(incY_::numeric, 3) AND
		  round(startx::numeric, 3) = round(startX_::numeric, 3) AND
		  round(starty::numeric, 3) = round(startY_::numeric, 3) AND
		  projdefinition = btrim(projection_) AND
		  placenamespaceid = 0;
	-- Add dataprovider
	IF NOT FOUND THEN
		-- Get PlaceId
		placeId_ := nextval('__WDB_SCHEMA__.placedefinition_placeid_seq');
		-- Insert Data
		INSERT INTO __WDB_SCHEMA__.placeregulargrid
		VALUES ( placeId_,
				 numX_,
				 numY_,
				 incX_,
				 incY_,
				 startX_,
				 startY_,
				 srid_ );
		IF namespace_ <> 0 THEN
			INSERT INTO __WDB_SCHEMA__.placename
			VALUES ( placeId_,
					 nameSpace_,
					 lower(placeName_),
					 'today'::TIMESTAMP WITH TIME ZONE,
					 'infinity'::TIMESTAMP WITH TIME ZONE );
		END IF;
	ELSE
		IF namespace_ <> 0 THEN
			PERFORM * 
			FROM  __WDB_SCHEMA__.placename
			WHERE placeid = placeId_ AND 
				  placenamespaceid = namespace_;
			IF NOT FOUND THEN
				INSERT INTO __WDB_SCHEMA__.placename VALUES
				( placeId_, namespace_, lower(placeName_), 'today', 'infinity' );
			ELSE
				UPDATE __WDB_SCHEMA__.placename 
				SET placename = lower(placeName_)
				WHERE placeid = placeId_ AND
					  placenamespaceid = namespace_;
			END IF;
		END IF;
	END IF;
	-- Insert new placename
	RETURN placeId_;
END;
$BODY$
SECURITY DEFINER
LANGUAGE plpgsql VOLATILE;


-- Place Definition Info
CREATE OR REPLACE FUNCTION 
wci.getPlaceDefinition( location 			text )	
RETURNS SETOF __WCI_SCHEMA__.placedefinition AS
$BODY$
	SELECT 	p.placeid,
			p.placegeometrytype,
			p.placegeometry,
			p.placeindeterminatecode,
			p.placenamespaceid,
			p.placename,
			p.originalsrid,
			p.placestoretime
	FROM	__WCI_SCHEMA__.placeDefinition_mv p,
			__WCI_SCHEMA__.getSessionData() s
	WHERE	p.placenamespaceid = s.placenamespaceid
	  AND	( $1 IS NULL OR placename LIKE lower($1) );
$BODY$
SECURITY DEFINER
LANGUAGE sql STABLE;


-- Place Point Info
CREATE OR REPLACE FUNCTION 
wci.getPlacePoint( location 			text )	
RETURNS SETOF __WCI_SCHEMA__.placedefinition AS
$BODY$
	SELECT 	p.placeid,
			p.placegeometrytype,
			p.placegeometry,
			p.placeindeterminatecode,
			p.placenamespaceid,
			p.placename,
			p.originalsrid,
			p.placestoretime
	FROM	__WCI_SCHEMA__.placeDefinition_mv p,
			__WCI_SCHEMA__.getSessionData() s
	WHERE	p.placenamespaceid = s.placenamespaceid
	  AND	( $1 IS NULL OR placename LIKE lower($1) )
	  AND	p.placegeometrytype = 'point';
$BODY$
SECURITY DEFINER
LANGUAGE sql STABLE;


CREATE OR REPLACE FUNCTION 
wci.getPlaceRegularGrid( grid_ 		text )
RETURNS SETOF __WCI_SCHEMA__.placeregulargrid AS
$BODY$
	SELECT 	p.placeid,
			p.placegeometrytype,
			p.placegeometry,
			p.placeindeterminatetype,
			p.placenamespaceid,
			p.placename,
			p.numberx,
			p.numbery,
			p.incrementx,
			p.incrementy,
			p.startx,
			p.starty,
			p.originalsrid,
			p.projdefinition,
			p.placestoretime
	FROM	__WCI_SCHEMA__.placeregulargrid_mv p,
			__WCI_SCHEMA__.getSessionData() s
	WHERE	p.placenamespaceid = s.placenamespaceid
	  AND	( $1 IS NULL OR placename LIKE lower($1) );
$BODY$
SECURITY DEFINER
LANGUAGE sql STABLE;



-- Add SRID
CREATE OR REPLACE FUNCTION
wci.addSrid(
	authname_		text,
	projection_		text
)
RETURNS int AS
$BODY$
DECLARE
	srid_ int;
BEGIN
	-- WCI User Check
	PERFORM __WCI_SCHEMA__.getSessionData();
	-- Get SRID
	SELECT srid INTO srid_
	FROM spatial_ref_sys
	WHERE btrim(proj4text) = btrim(projection_);
	-- If SRID not found...
	IF srid_ IS NOT NULL THEN
		RETURN srid_;
	END IF;
	-- Get SRID
	SELECT max(srid) + 1 INTO srid_
	FROM spatial_ref_sys;
	-- Minimum new SRID = 50000
	IF srid_ < 50000 THEN
		srid_ := 50000;
	END IF;		
	-- Insert Data
	INSERT INTO spatial_ref_sys
	VALUES ( srid_,
			 authname_,
			 NULL,
			 NULL,
			 btrim(projection_) );			 
	-- The two nulls represent the EPSG codes, which we do not attempt to 
	-- derive at this point.
	-- Return	 
	RETURN srid_;
END;
$BODY$
SECURITY DEFINER
LANGUAGE plpgsql VOLATILE;


-- Get SRID
CREATE OR REPLACE FUNCTION 
wci.getSrid(
	projstr_	text
)
RETURNS SETOF public.spatial_ref_sys AS
$BODY$
	SELECT	srid,
			auth_name,
			auth_srid,
			srtext,
			btrim(proj4text)        
	FROM 	public.spatial_ref_sys
	WHERE 	( $1 IS NULL OR btrim(proj4text) ILIKE btrim($1) )
$BODY$
SECURITY DEFINER
LANGUAGE sql;



--
-- add new data provider name in namespace
-- 
CREATE OR REPLACE FUNCTION
wci.setPlaceName
(
	canonicalName_	text,
	placeName_ 		text
)
RETURNS void AS
$BODY$
DECLARE	
	namespace_ 		int;
	placeId_ 		int;
BEGIN
	-- Get namespace
	SELECT placenamespaceid INTO namespace_
	FROM __WCI_SCHEMA__.getSessionData();
	IF ( namespace_ = 0 ) THEN
		RAISE EXCEPTION 'Cannot set the WDB Canonical PlaceName';
	END IF;	
	-- Get placeid
	SELECT placeid INTO placeId_
	FROM __WCI_SCHEMA__.placedefinition_mv
	WHERE placename = lower(canonicalName_) AND
		  placenamespaceid = 0;
	IF NOT FOUND THEN
		RAISE EXCEPTION 'Could not identify any place definition with the specified canonical PlaceName';		
	END IF;
	-- Delete old name if any exist
	DELETE FROM __WDB_SCHEMA__.placename
	WHERE placenamespaceid = namespace_ AND
		  placeid = placeId_;
	-- Insert new name
	INSERT INTO __WDB_SCHEMA__.placename
	VALUES ( placeId_,
			 namespace_,
			 lower(placeName_),
			  'today'::TIMESTAMP WITH TIME ZONE, 
			  'infinity'::TIMESTAMP WITH TIME ZONE );
END;
$BODY$
SECURITY DEFINER
LANGUAGE plpgsql VOLATILE;


--
-- Get DataProviderName
--
CREATE OR REPLACE FUNCTION 
wci.getPlaceName(
	name_	text
)
RETURNS SETOF __WCI_SCHEMA__.placename_V AS
$BODY$
	SELECT
		*
	FROM
		__WCI_SCHEMA__.placename_v
	WHERE placeid = SOME
		  ( SELECT placeid 
		    FROM   __WCI_SCHEMA__.placename p
		    WHERE  ( p.placename LIKE $1 OR $1 IS NULL ) );
$BODY$
SECURITY DEFINER
LANGUAGE sql VOLATILE;


--
-- Get PlaceName using regular grid info
--  
CREATE OR REPLACE FUNCTION
wci.getPlaceName(
	numberX_ 		int,
	numberY_ 		int,
	incrementX_ 	float,
	incrementY_ 	float,
	startX_ 		float,
	startY_ 		float,
	projdefinition_ text
)
RETURNS __WCI_SCHEMA__.placename_v AS
$BODY$
	SELECT placeid, grd.placenamespaceid, placename
	FROM __WCI_SCHEMA__.placeregulargrid_mv grd, __WCI_SCHEMA__.getSessionData() s
	WHERE numberX = $1
	AND   numberY = $2
	AND   round(incrementX::numeric, 3) = round($3::numeric, 3)
	AND   round(incrementY::numeric, 3) = round($4::numeric, 3)
	AND	  round(startX::numeric, 3) = round($5::numeric, 3)
	AND   round(startY::numeric, 3) = round($6::numeric, 3)
	AND   projdefinition = btrim($7)
	AND   grd.placenamespaceid = s.placenamespaceid;
$BODY$
SECURITY DEFINER
LANGUAGE sql VOLATILE;
