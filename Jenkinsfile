pipeline {
        agent {
            label 'builder'
        }
    stages {
        stage('Build backend') {
            steps {
                echo "******************* Building FrontEnd *******************"
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
                echo "******************* Spin-UP MySQL database and test backend *******************"
                script {
                    dir (path: "$WORKSPACE/customer-api") {
                        def backendImage = docker.build("backend-api:${BUILD_ID}")
                    }
                    
                }
            }
        }
        stage('OWASP') {
            steps {
                echo "******************* Checking dependencies with OWASP *******************"
                dir (path: "$WORKSPACE/customer-api"){
                    dependencyCheck additionalArguments: '', odcInstallation: 'owaspdc', skipOnScmChange: true
                }
                dependencyCheckPublisher pattern: "**/dependency-check-report.xml"
            }
        }
        stage('SonarQube') {
            steps {
                echo '******************* SonarQube analize *******************'
            }
        }
        stage('Test') {
            steps {
                echo '******************* SpringBoot Test *******************'
            }
        }
        stage ('Push') {
            steps {
                echo '******************* Push to docker *******************'
            }
        }
        stage ('Deploy') {
            steps {
                echo '******************* Deploy the Docker container *******************'
            }
        }
    }
}