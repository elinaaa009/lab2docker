FROM golang:1.22-alpine AS builder

RUN apk update && \
    apk add --no-cache git && \
    rm -rf /var/cache/apk/*

WORKDIR /app

COPY go.mod ./
RUN go mod download

COPY main.go ./

RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-s -w" -o /app/server main.go

FROM alpine:latest

RUN addgroup -S appgroup && adduser -S appuser -G appgroup

WORKDIR /app

COPY --from=builder /app/server /app/server

RUN chown -R appuser:appgroup /app

USER appuser

ENV PORT=8080
ENV WELCOME_MESSAGE="Hello from Alpine Multi-stage Container!"

EXPOSE ${PORT}

# Запуск приложения
CMD ["/app/server"]
