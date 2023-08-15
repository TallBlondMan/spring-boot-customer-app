# Notes

1. .jar was build with gradle:8.2-alpine
2. Used command 'gradle clean bootJar' - 'docker run --rm -u gradle -v "$PWD":/home/gradle/project -w /home/gradle/project gradle:8.2-alpine gradle clean bootJar --info'
3. 