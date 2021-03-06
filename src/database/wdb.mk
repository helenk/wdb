
#-----------------------------------------------------------------------------
# Database Source
#-----------------------------------------------------------------------------

wdb_la_SOURCES +=	src/database/databaseProjection.cpp


DATABASE_SOURCES =		src/database/wdbSchemaDefinitions.in.sql \
						src/database/wdbBaseTables.in.sql \
						src/database/wdbDataProviderTables.in.sql \
						src/database/wdbPlaceDefinitionTables.in.sql \
						src/database/wdbParameterTables.in.sql \
						src/database/wdbValueTables.in.sql \
						src/database/wdbIndexDefinitions.in.sql \
						src/database/wdbMaterializedView.in.sql \
						src/database/wdbConstraintDefinitions.in.sql \
						src/database/wdbTriggerDefinitions.in.sql \
						src/database/wdbUserDefinitions.in.sql \
						src/database/wciSchemaDefinitions.in.sql \
						src/database/wciViewDefinitions.in.sql \
						src/database/wdbAdminDefinitions.in.sql \
						src/database/wdbTestDefinitions.in.sql

UPGRADE_SOURCES =		src/database/wdbUpgrade0001.in.sh \
						src/database/wdbUpgrade0002.in.sh

nodist_pkglib_SCRIPTS += $(UPGRADE_SOURCES:.in.sh=.sh)

sql_DATA += 			$(DATABASE_SOURCES:.in.sql=.sql)

CLEANFILES +=			$(DATABASE_SOURCES:.in.sql=.sql) \
						$(UPGRADE_SOURCES:.in.sh=.sh)

EXTRA_DIST += 			$(DATABASE_SOURCES) \
						$(UPGRADE_SOURCES) \
						src/database/wdb.mk \
						src/database/Makefile.am \
						src/database/Makefile.in

DISTCLEANFILES +=		src/database/Makefile


# Local Makefile Targets
#-----------------------------------------------------------------------------

src/database/all: $(DATABASE_SOURCES:.in.sql=.sql)

src/database/clean: clean
