FROM nginx:1.27-alpine

# Package installation: curl is used by the image health check.
RUN apk add --no-cache curl

COPY index.html /usr/share/nginx/html/index.html

EXPOSE 80

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -fsS http://127.0.0.1/ || exit 1
