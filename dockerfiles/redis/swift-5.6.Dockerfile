FROM swift:5.6.1-focal

RUN mkdir /app
COPY Package.swift /app/Package.swift
COPY Package.resolved /app/Package.resolved

RUN mkdir /app/Sources
RUN mkdir /app/Sources/swift-redis-challenge
RUN echo "@main struct Main { static func main() { print(\"Hello, world!\") } }" > /app/Sources/swift-redis-challenge/Main.swift

WORKDIR /app

RUN swift build

RUN rm /app/Sources/swift-redis-challenge/Main.swift

COPY /Sources/swift-redis-challenge/Main.swift /app/Sources/swift-redis-challenge/Main.swift