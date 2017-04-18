# postgres-drop-restore

Daily drop and restore a target database with data from a source database.

## Usage

Typically this image is instatiated as a container among many others and would have the responsibility of setting a target database to match that of a source database.

For instance to have a QC environment get a nightly refresh of data from production.

With a `docker-compose` set up, this might look like the following:

`docker-compose.qc.yml` defines a service:

```
  postgres-drop-restore:
    image: bluedrop360/postgres-drop-restore
    environment:
        PG_DROP_RESTORE_HOUR: 6
        PG_DROP_RESTORE_MINUTE: 0
        PG_DROP_RESTORE_SOURCE_DATABASE_URL: postgres://...
        PG_DROP_RESTORE_TARGET_DATABASE_URL: postgres://...
    restart: always
```

At 06:00 UTC the source database is pg_dumped and pg_restored to the target database. **This will have some outage time**, as long as it takes for `DROP DATABASE`, `CREATE DATABASE`, and `pg_restore` take to process.
