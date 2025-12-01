FROM maven:3.9-eclipse-temurin-17 AS build
WORKDIR /app

COPY . .

RUN mvn clean package -DskipTests

FROM eclipse-temurin:17-jre-jammy

WORKDIR /app

RUN useradd -m appuser

COPY --from=build /app/target/*.jar app.jar

EXPOSE 8080

USER appuser
ENTRYPOINT ["java", "-jar", "app.jar"]
