-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- 
-- wdb - weather and water data storage
--
-- Copyright (C) 2007-2009 met.no
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
SET SESSION client_min_messages TO 'warning';

-- Surface
CREATE TABLE __WDB_SCHEMA__.cfsurface (
    cfsurface					character varying(255) NOT NULL,
	cfsurfacecomment			character varying(255)
);

-- Component
CREATE TABLE __WDB_SCHEMA__.cfcomponent (
    cfcomponent					character varying(255) NOT NULL,
	cfcomponentcomment			character varying(255)
);

-- Medium
CREATE TABLE __WDB_SCHEMA__.cfmedium (
    cfmedium					character varying(255) NOT NULL,
	cfmediumcomment				character varying(255)
);

-- Process
CREATE TABLE __WDB_SCHEMA__.cfprocess (
    cfprocess					character varying(255) NOT NULL,
	cfprocesscomment			character varying(255)
);

-- Condition
CREATE TABLE __WDB_SCHEMA__.cfcondition (
    cfcondition					character varying(255) NOT NULL,
	cfconditioncomment			character varying(255)
);	

-- Surface
CREATE TABLE __WDB_SCHEMA__.cfmethods (
    cfmethods				character varying(255) NOT NULL,
	cfmethodscomment		character varying(255),
    cfmethodsname			character varying(255) NOT NULL
);

CREATE TABLE __WDB_SCHEMA__.unit (
    unitname					character varying(80) NOT NULL,
    unittype					character varying(80) NOT NULL,
	description					character varying(255) NOT NULL
    CONSTRAINT unit_unittype_check
	CHECK (	((unittype)::text = 'derived unit'::text) OR
			((unittype)::text = 'base unit'::text))
);

ALTER TABLE ONLY __WDB_SCHEMA__.unit
    ADD CONSTRAINT unit_pkey PRIMARY KEY (unitname);

REVOKE ALL ON __WDB_SCHEMA__.unit FROM public;
GRANT ALL ON __WDB_SCHEMA__.unit TO wdb_admin;


-- Conversion tables
CREATE TABLE __WDB_SCHEMA__.baseunitconversion (
    unitname						character varying(80) NOT NULL,
    baseunitname					character varying(80) NOT NULL,
    baseunitconversioncoefficient	float NOT NULL,
    baseunitconversionterm			float NOT NULL
);

ALTER TABLE ONLY __WDB_SCHEMA__.baseunitconversion
    ADD CONSTRAINT baseunitconversion_pkey PRIMARY KEY (unitname);

ALTER TABLE __WDB_SCHEMA__.baseunitconversion
	ADD FOREIGN KEY (unitname)
					REFERENCES __WDB_SCHEMA__.unit
					ON DELETE CASCADE
					ON UPDATE CASCADE;

REVOKE ALL ON __WDB_SCHEMA__.baseunitconversion FROM public;
GRANT ALL ON __WDB_SCHEMA__.baseunitconversion TO wdb_admin;


-- Parameter
CREATE TABLE __WDB_SCHEMA__.parameter (
	parameterid 					serial NOT NULL,
  	cfstandardname					character varying(255) NOT NULL,
 	cfsurface						character varying(255),
    cfcomponent						character varying(255),
    cfmedium						character varying(255),
    cfprocess						character varying(255),
    cfcondition						character varying(255),
    cfmethods						character varying(255),
    unitname						character varying(80)
);

ALTER TABLE ONLY __WDB_SCHEMA__.parameter
    ADD CONSTRAINT parameter_pkey PRIMARY KEY (parameterid);

REVOKE ALL ON __WDB_SCHEMA__.parameter FROM public;
GRANT ALL ON __WDB_SCHEMA__.parameter TO wdb_admin;


CREATE TABLE __WDB_SCHEMA__.parametername (
	parameterid 				integer NOT NULL,
	parameternamespaceid 		integer NOT NULL,
	parametername 				character varying(255) NOT NULL
);

ALTER TABLE ONLY __WDB_SCHEMA__.parametername
    ADD CONSTRAINT parametername_pkey PRIMARY KEY (parameterid, parameternamespaceid);

REVOKE ALL ON __WDB_SCHEMA__.parametername FROM public;
GRANT ALL ON __WDB_SCHEMA__.parametername TO wdb_admin;










CREATE TABLE __WDB_SCHEMA__.valueparameter (
	valueparameterid 			serial NOT NULL,
	valueparametertype 			character varying(80) NOT NULL
    CONSTRAINT value_valueparametertype_check
	CHECK (	((valueparametertype)::text = 'Measure Parameter'::text) OR
			((valueparametertype)::text = 'Function Parameter'::text) OR
			((valueparametertype)::text = 'Code Parameter'::text) OR
			((valueparametertype)::text = 'Dimensionless Parameter'::text))
);

CREATE TABLE __WDB_SCHEMA__.levelindeterminatetype (
    levelindeterminatecode		integer NOT NULL,
    levelindeterminatetype		character varying(80) NOT NULL,
    levelindeterminatetypedescription	character varying(255) NOT NULL
);

ALTER TABLE ONLY __WDB_SCHEMA__.levelindeterminatetype
    ADD CONSTRAINT levelindeterminatetype_pkey PRIMARY KEY (levelindeterminatecode);

REVOKE ALL ON __WDB_SCHEMA__.levelindeterminatetype FROM public;
GRANT ALL ON __WDB_SCHEMA__.levelindeterminatetype TO wdb_admin;

INSERT INTO __WDB_SCHEMA__.levelindeterminatetype VALUES( 0, 'any', 'Values are valid for any level' );
INSERT INTO __WDB_SCHEMA__.levelindeterminatetype VALUES( 1, 'exact', 'The level is exactly identical with the given interval' );
INSERT INTO __WDB_SCHEMA__.levelindeterminatetype VALUES( 2, 'inside', 'The level is inside the given interval' );
INSERT INTO __WDB_SCHEMA__.levelindeterminatetype VALUES( 3, 'outside', 'The level is outside the given interval' );
INSERT INTO __WDB_SCHEMA__.levelindeterminatetype VALUES( 4, 'above', 'The level is above the given interval' );
INSERT INTO __WDB_SCHEMA__.levelindeterminatetype VALUES( 5, 'below', 'The level is below the given interval' );
INSERT INTO __WDB_SCHEMA__.levelindeterminatetype VALUES( 6, 'withheld', 'The level is known but not exposed' );
INSERT INTO __WDB_SCHEMA__.levelindeterminatetype VALUES( 7, 'withdrawn', 'The level is changed to unknown' );
INSERT INTO __WDB_SCHEMA__.levelindeterminatetype VALUES( 8, 'unknown', 'The level definition is unknown' );
INSERT INTO __WDB_SCHEMA__.levelindeterminatetype VALUES( 9, 'delayed', 'The level definition will be set later' );
