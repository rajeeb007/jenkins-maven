FROM openjdk
WORKDIR /app
COPY target/jenkins-maven-1.0-SNAPSHOT.jar /app/
RUN echo 'hello'
CMD ["java", "-jar","jenkins-maven-1.0-SNAPSHOT.jar"]