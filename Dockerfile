# --- first we build the application ---

FROM maven:3-jdk-8 AS builder
WORKDIR /usr/builddir

# Copy all the sources to the container [1]
COPY src ./src
COPY pom.xml ./

# Build the project
RUN mvn package

# --- now we create the runtime image ---

# The base image to use [2]
FROM openjdk:8-jre-alpine
WORKDIR /usr/application
EXPOSE 8080
ENTRYPOINT ["sh", "-c"]

# Copy the fat jar to the container [3]
COPY --from=builder /usr/builddir/target/*.jar ./

# Launch the application [3]
CMD ["exec java -jar `echo *.jar`"]

