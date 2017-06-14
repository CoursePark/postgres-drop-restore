#!/bin/sh

echo "postgres drop restore - getting a dump of source database"
tempFile=$(mktemp -u)
PGOPTIONS="-c statement_timeout=3600000" pg_dump -Fc --no-owner --clean -o $SOURCE_DATABASE_URL > $tempFile
echo "postgres drop restore - drop existing target database"
targetDbName=`echo $TARGET_DATABASE_URL | sed "s|.*/\([^/]*\)\$|\\1|"`
targetDbRootUrl=$(echo $TARGET_DATABASE_URL | sed "s|/[^/]*\$|/template1|")
dropResult=$(echo "DROP DATABASE $targetDbName;" | psql $targetDbRootUrl 2>&1)
if echo $dropResult | grep "other session using the database" -> /dev/null; then
  echo "RESTORE FAILED - another database session is preventing drop of database $targetDbName"
  exit 1
fi
createResult=$(echo "CREATE DATABASE $targetDbName;" | psql $targetDbRootUrl 2>&1)
echo "postgres drop restore - fill target database with dump"
pg_restore -c -d $TARGET_DATABASE_URL $tempFile
rm $tempFile
echo "postgres drop restore - complete"
