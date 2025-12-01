FROM eclipse-temurin:17-jdk AS builder

WORKDIR /app

RUN apt-get update && apt-get install -y maven && rm -rf /var/lib/apt/lists/*

COPY pom.xml .

RUN mvn -B -Denforcer.skip=true dependency:go-offline

COPY src ./src

RUN mvn -B -Denforcer.skip=true clean package -DskipTests


FROM eclipse-temurin:17-jdk

WORKDIR /app

RUN useradd -m appuser

COPY --from=builder /app/target/*.jar app.jar

EXPOSE 8080

USER appuser

ENTRYPOINT ["java","-jar","app.jar"]
