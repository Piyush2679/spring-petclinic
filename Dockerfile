FROM eclipse-temurin:25-jdk AS builder

WORKDIR /app

RUN apt-get update && apt-get install -y maven && rm -rf /var/lib/apt/lists/*

COPY pom.xml .

RUN mvn dependency:go-offline -B

COPY src ./src

RUN mvn clean package -DskipTests


FROM eclipse-temurin:25-jdk

WORKDIR /app

RUN useradd -m appuser

COPY --from=builder /app/target/*.jar app.jar

EXPOSE 8080

USER appuser

ENTRYPOINT ["java","-jar","app.jar"]
