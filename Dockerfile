FROM alpine:3 as downloader

WORKDIR /work

COPY latest_version.txt latest_version.txt

RUN apk add --no-cache curl && \
    arch=$(uname -m | sed s/aarch64/arm64/ | sed s/x86_64/amd64/) && \
    version=$(cat latest_version.txt) && \
    curl -L -S -s -o sysdig-cli-scanner "https://download.sysdig.com/scanning/bin/sysdig-cli-scanner/$version/linux/$arch/sysdig-cli-scanner" && \
    sha256sum -c <(curl -sL "https://download.sysdig.com/scanning/bin/sysdig-cli-scanner/$version/linux/$arch/sysdig-cli-scanner.sha256") && \
    chmod +x sysdig-cli-scanner

FROM alpine:3

WORKDIR /scanner

RUN apk add --no-cache tini && \
    mkdir -p /cache && \
    adduser -D -h /scanner scanuser && \
    chown -R scanuser:scanuser /cache /scanner

USER scanuser

COPY entrypoint.sh /entrypoint.sh
COPY --chown=scanuser:scanuser --from=downloader /work/sysdig-cli-scanner /scanner/sysdig-cli-scanner

ENTRYPOINT ["/sbin/tini", "--", "/entrypoint.sh"]

CMD [ "--apiurl", "${SYSDIG_SECURE_ENDPOINT}", "--console-log", "--dbpath=/cache/db/", "--cachepath=/cache/scanner-cache/", "${OPTIONS:- --skipupload --full-vulns-table --detailed-policies-eval}", "${IMAGE_NAME}" ]
