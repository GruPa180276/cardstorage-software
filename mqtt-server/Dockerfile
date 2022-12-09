FROM golang:1.18 AS builder

WORKDIR /app
COPY . .
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -ldflags="-s -w" -a -o ./mqtt-server .

FROM alpine:latest

RUN apk --no-cache add ca-certificates

RUN apk --no-cache add tzdata
RUN ln -s /usr/share/zoneinfo/CET /etc/localtime
ENV TZ=Europe/Vienna

# COPY --from=builder /app/.env ./.env
COPY --from=builder /app/. .

RUN chmod +x ./mqtt-server
CMD ["./mqtt-server"]