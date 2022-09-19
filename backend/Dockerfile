FROM maven:3.8.4-jdk-8
VOLUME /tmp

WORKDIR /usr/src/backend

COPY pom.xml .
COPY ./src ./src

RUN mvn clean install

ENV PORT 8081
EXPOSE 8081

CMD java -jar ./target/catalogue-backend.jar --DB_HOST=${DB_HOST} --DB_PORT=${DB_PORT} --DB_USER=${DB_USER} --DB_PASS=${DB_PASS} --DB_SCHEMA=${DB_SCHEMA}