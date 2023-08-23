# Notes

1. .jar was build with gradle:8.2-alpine
2. Used command 'gradle clean bootJar' need to run as root for clean, ```GRADLE_USER_HOME``` is there for faster builds retaining downloaded dependencies
 ```docker run --rm -u root -e GRADLE_USER_HOME=/gradle/cache -v gradle_dep:/gradle/cache -v "$PWD":/home/gradle/project -w /home/gradle/project gradle:8.2-alpine gradle clean bootJar --info```
3. Run the Docker with ```docker run -dp 8081:8080 -e SPRING_DATASOURCE_URL=jdbc:mysql://<host>:<port> -e SPRING_DATASOURCE_USERNAME=username -e SPRING_DATASOURCE_PASSWORD=password customer-api:1```
4. Containers have to be on custom network to use NAMES