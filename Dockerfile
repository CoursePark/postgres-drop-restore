FROM alpine

# need psql, pg_dump, pg_restore from postgresql package
RUN apk --no-cache add postgresql

COPY action.sh /

RUN chmod +x action.sh

CMD echo "$CRON_MINUTE $CRON_HOUR * * * /action.sh" > /var/spool/cron/crontabs/root && crond -d 8 -f
