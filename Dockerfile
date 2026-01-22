FROM golang:1.21-alpine AS build

WORKDIR /build
COPY go.mod ./
COPY go.sum ./
RUN go mod download

COPY . ./
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -tags netgo -o app

FROM gcr.io/distroless/static-debian12:nonroot
COPY --from=build /build/app /app
EXPOSE 9580
USER nonroot:nonroot
ENTRYPOINT [ "/app" ]