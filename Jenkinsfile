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
        stage('QWASP') {
            steps {
                echo 'QWASP'
            }
        }
        stage('SonarQube') {
            steps {
                echo 'SonarQube'
            }
        }
        stage('Test') {
            steps {
                echo 'App Test'
            }
        }
        stage ('Push') {
            steps {
                echo 'Push to docker'
            }
        }
        stage ('Deploy') {
            steps {
                echo 'deploy to docker container'
            }
        }
    }
}