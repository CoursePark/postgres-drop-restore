#!/bin/sh

echo "postgres drop restore - getting a dump of source database"
PGOPTIONS="-c statement_timeout=3600000" pg_dump -Fc --no-owner --clean -o $PG_DROP_RESTORE_SOURCE_DATABASE_URL > db.dump
echo "postgres drop restore - drop existing target database"
export dbname=`echo $PG_DROP_RESTORE_TARGET_DATABASE_URL | sed "s|.*/\([^/]*\)\$|\\1|"`
echo "DROP DATABASE $dbname; CREATE DATABASE $dbname;" | psql `echo $PG_DROP_RESTORE_TARGET_DATABASE_URL | sed "s|/[^/]*\$|/template1|"`
echo "postgres drop restore - fill target database with dump"
pg_restore -c -d $PG_DROP_RESTORE_TARGET_DATABASE_URL db.dump
echo "postgres drop restore - complete"
