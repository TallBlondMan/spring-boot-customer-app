FROM openjdk:8

WORKDIR /customer-api

COPY ./build/libs/*.jar app.jar

ENV SPRING_DATASOURCE_URL=
ENV SPRING_DATASOURCE_USERNAME=
ENV SPRING_DATASOURCE_PASSWORD=

EXPOSE 8080

ENTRYPOINT [ "java", "-jar", "app.jar" ]