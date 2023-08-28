pipeline {
    agent none
    stages {
        stage('Build backend') {
            agent {
                label 'builder'
            }
            steps {
                echo "************* Building FrontEnd *************"
                script {
                    docker.image('gradle:8.2-alpine').inside("-e GRADLE_USER_HOME=/gradle/cache" + " -v gradle_dep:/gradle/cache") {
                        dir (path: "$WORKSPACE/customer-api"){
                            sh 'gradle clean bootJar --info'
                        }
                    }
                }
            }
        }
        stage ('Test backend') {
            steps {
                echo "************* Spin-UP MySQL database and test backend *************"
            }
        }
        stage('QWASP') {
            steps {
                dir (path: "$WORKSPACE/customer-api"){
                    sh "dependencyCheck additionalArguments: '', odcInstallation: 'owaspdc', skipOnScmChange: true"
                }
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