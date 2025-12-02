FROM eclipse-temurin:17-jdk AS builder

WORKDIR /build

COPY target/*.jar app.jar


FROM eclipse-temurin:17-jre-jammy

WORKDIR /app

RUN useradd -m appuser

COPY --from=builder /build/app.jar app.jar

EXPOSE 8080

USER appuser

ENTRYPOINT ["java","-jar","app.jar"]
