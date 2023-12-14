ARG VERSION=0.7.0
ARG GO_VERSION=1.16.5
ARG GO_APP=github.com/hashicorp/vault-k8s@v${VERSION}

FROM --platform=$BUILDPLATFORM golang:${GO_VERSION}-alpine as build-env

LABEL maintainer="rparmer02@gmail.com"

# xx wraps go to automatically configure $GOOS, $GOARCH, and $GOARM
COPY --from=tonistiigi/xx:golang / /

# Compile independent executable using go wrapper from xx:golang
ARG TARGETPLATFORM
ARG GO_APP

RUN apk add --no-cache git \
    \
    # Download as a package
    && export GO111MODULE=on && export CGO_ENABLED=0 \
    && go get -d ${GO_APP} \
    \
    # Build Vault k8s from source
    && cd /go/pkg/mod/${GO_APP} \
    && go build -o /go/bin/main .

FROM scratch

COPY --from=build-env /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=build-env /go/bin/main /

ENTRYPOINT ["/main"]
