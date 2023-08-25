pipeline {
    agent none
    stages {
        stage('Build') {
            agent {
                docker { 
                    image 'gradle:8.2-alpine'
                    args '-e GRADLE_USER_HOME=/gradle/cache'
                    args '-v gradle_dep:/gradle/cache'
                    args '-v "$PWD/customer-api":/home/gradle/project'
                    args '-w /home/gradle/project'   
                }
            }
            steps {
                dir (path: '/home/gradle/project'){
                    echo '$PWD'
                    sh 'gradle clean bootJar --info'
                }
            }
        }
    }
}