pipeline {
    agent none
    stages {
        stage('Build') {
            agent {
                docker { 
                    image 'gradle:8.2-alpine'
                    args '-e GRADLE_USER_HOME=/gradle/cache'
                    args '-v gradle_dep:/gradle/cache'
                    args '-v "./customer-api":/home/gradle/project'
                    args '-w /home/gradle/project'
                }
            }
            steps {
                sh 'gradle clean bootJar --info'
                echo 'pwd'
            }
        }
    }
}