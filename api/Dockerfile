FROM golang:1.18 AS builder

WORKDIR /app
COPY . .
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -ldflags="-s -w" -a -o ./api .

FROM alpine:latest

RUN apk --no-cache add ca-certificates

RUN apk --no-cache add tzdata
RUN ln -s /usr/share/zoneinfo/CET /etc/localtime
ENV TZ=Europe/Vienna

EXPOSE 7171

# COPY --from=builder /app/.env ./.env
COPY --from=builder /app/. .

RUN chmod +x ./api

ENV WAIT_VERSION 2.7.2
ADD https://github.com/ufoscout/docker-compose-wait/releases/download/$WAIT_VERSION/wait /wait
RUN chmod +x ./wait

CMD ["./api"]