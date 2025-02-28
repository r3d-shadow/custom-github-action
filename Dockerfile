FROM alpine:3.18.3

# Default Environment Variables
ENV GITHUB_REPOSITORY=${GITHUB_REPOSITORY}
ENV GITHUB_SHA=${GITHUB_SHA}

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh  

ENTRYPOINT ["/entrypoint.sh"]