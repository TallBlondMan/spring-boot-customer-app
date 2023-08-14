FROM openjdk:8

WORKDIR /customer-api

COPY ./build/libs/*.jar app.jar

ENV SPRING_DATASOURCE_URL=jdbc:mysql://localhost:3306/customerdb
ENV SPRING_DATASOURCE_USERNAME=msmet
ENV SPRING_DATASOURCE_PASSWORD=Polska123

EXPOSE 8080

ENTRYPOINT [ "java", "-jar", "app.jar" ]
