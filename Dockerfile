# FROM ubuntu

# # Install necessary packages
# #============================
# RUN apt-get update && apt-get install -y 
# RUN apt install openjdk-17-jre-headless -y
# RUN apt install maven -y

# # Set the working directory
# WORKDIR /app

# # Copy source files and pom.xml
# COPY application.properties /app/src/main/resources/application.properties
# COPY ./src /app/src
# COPY ./pom.xml /app

# # Build the application
# RUN mvn -f /app/pom.xml clean package
# RUN ls -la /app/target
# RUN cp /app/target/*.jar /app/app.jar
# # Copy the built JAR file to the container


# EXPOSE 8080

# ENTRYPOINT ["java", "-jar", "app.jar"]




# ==========================
# FROM eclipse-temurin:25
# RUN mkdir /opt/app
# COPY japp.jar /opt/app
# CMD ["java", "-jar", "/opt/app/japp.jar"]


# ---------- Build Stage ----------
FROM maven:3.9.9-eclipse-temurin-17 AS builder

WORKDIR /app

# Copy project files
COPY pom.xml .
COPY src ./src

# Build the Spring Boot application
RUN mvn clean package -DskipTests

# ---------- Runtime Stage ----------
FROM eclipse-temurin:17-jre

WORKDIR /app

# Copy the JAR built in the previous stage
COPY --from=builder /app/target/*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]