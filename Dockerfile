FROM redpandadata/redpanda:v26.2.2

ARG REDPANDA_VERSION=v26.2.2

ENV REDPANDA_VERSION=${REDPANDA_VERSION}
ENV REDPANDA_DEV_MODE=true

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 9092 8082 8081 33145 9644

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["redpanda", "start", "--mode=dev-container"]
