FROM golang:1.18 AS builder

WORKDIR /app
COPY . .
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -ldflags="-s -w" -a -o ./envprinter .

FROM alpine:latest

COPY --from=builder /app/. .

RUN chmod +x ./envprinter

CMD ["./envprinter"]