# Etape de build avec Maven (image standard pour Maven)
FROM maven:3.9.9 AS build
WORKDIR /app
COPY . .

# Installer Java 20 depuis le dépôt d'AdoptOpenJDK
RUN apt-get update && \
    apt-get install -y wget && \
    wget https://github.com/adoptium/temurin20-binaries/releases/download/jdk-20.0.2+9/OpenJDK20U-jdk_x64_linux_hotspot_20.0.2_9.tar.gz && \
    tar -xvzf OpenJDK20U-jdk_x64_linux_hotspot_20.0.2_9.tar.gz -C /opt && \
    rm OpenJDK20U-jdk_x64_linux_hotspot_20.0.2_9.tar.gz

# Spécifier la version de Java à utiliser
ENV JAVA_HOME=/opt/jdk-20.0.2+9
ENV PATH=$JAVA_HOME/bin:$PATH

# Compiler l'application avec Maven
RUN mvn clean package -DskipTests

# Etape de runtime avec Java 20
FROM eclipse-temurin:20-jre-alpine
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
