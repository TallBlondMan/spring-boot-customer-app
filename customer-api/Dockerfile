FROM openjdk:8

WORKDIR /customer-api

COPY ./build/libs/*.jar app.jar
# COPY script.sh script.sh

# RUN chmod 775 script.sh

ENV SPRING_DATASOURCE_URL=
ENV SPRING_DATASOURCE_USERNAME=
ENV SPRING_DATASOURCE_PASSWORD=

EXPOSE 8080

CMD [ "java", "-jar", "app.jar" ]
# CMD [ "./script.sh" ]