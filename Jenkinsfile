pipeline {
    agent none
    stages {
        stage('Build') {
            agent {
                label 'builder'
            }
            steps {
                script {
                    docker.image('gradle:8.2-alpine').inside("-e GRADLE_USER_HOME=/gradle/cache" + " -v gradle_dep:/gradle/cache") {
                        dir (path: "$WORKSPACE/customer-api"){
                            sh 'pwd'
                            sh 'gradle clean bootJar --info'
                        }
                    }
                }
            }
        }
    }
}