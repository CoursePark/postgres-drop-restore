FROM alpine

# need psql, pg_dump, pg_restore from postgresql package
RUN apk --no-cache add postgresql

COPY action.sh /

RUN chmod +x action.sh

CMD echo "$PG_DROP_RESTORE_MINUTE $PG_DROP_RESTORE_HOUR * * * /action.sh" > /var/spool/cron/crontabs/root && crond -l 2 -f
