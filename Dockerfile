FROM openjdk
WORKDIR /app
COPY target/jenkins-maven-*.jar /app/
RUN echo "heloo world"
CMD ["java", "-jar","jenkins-maven-1.0-SNAPSHOT.jar"]