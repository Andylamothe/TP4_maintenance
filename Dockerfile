# Etape de build avec Maven (image standard pour Maven)
FROM maven:3.9.9 AS build
WORKDIR /app
COPY . .

# Installer Java 20 pour le build
RUN apt-get update && apt-get install -y openjdk-20-jdk

# Spécifier la version de Java à utiliser
ENV JAVA_HOME=/usr/lib/jvm/java-20-openjdk-amd64
ENV PATH=$JAVA_HOME/bin:$PATH

# Compiler l'application avec Maven
RUN mvn clean package -DskipTests

# Etape de runtime avec Java 20
FROM eclipse-temurin:20-jre-alpine
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
