FROM alpine

# need psql, pg_dump, pg_restore from postgresql package
RUN apk --no-cache add postgresql

COPY action.sh /

RUN chmod +x action.sh

CMD echo "$PG_DROP_RESTORE_CRON_MINUTE $PG_DROP_RESTORE_CRON_HOUR * * * /action.sh" > /var/spool/cron/crontabs/root && crond -d 8 -f
