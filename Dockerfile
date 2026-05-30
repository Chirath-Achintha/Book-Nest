# Stage 1: Build the WAR file using Maven
FROM maven:3.9.6-eclipse-temurin-21 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

# Stage 2: Run the bootable WAR using Eclipse Temurin JRE 21
FROM eclipse-temurin:21-jre-jammy
WORKDIR /app
COPY --from=build /app/target/booknest-1.0.0.war app.war
EXPOSE 7860
ENTRYPOINT ["java", "-jar", "-Dserver.port=7860", "app.war"]
