pipeline {
        agent {
            label 'builder'
        }
        environment {
            DB_USER = credentials('DB_User')
            DB_PASSWD = credentials('DB_password')
            DB_ROOT = credentials('DB_Root_Password')
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
        stage('OWASP') {
            steps {
                echo "******************* Checking dependencies with OWASP *******************"
                dir (path: "$WORKSPACE/customer-api"){
                    dependencyCheck additionalArguments: '', odcInstallation: 'owaspdc', skipOnScmChange: true
                }
                dependencyCheckPublisher pattern: "**/dependency-check-report.xml"
            }
        }
        stage ('Test backend') {
            steps {
                echo "******************* Spin-UP MySQL database and test backend *******************"
                script {
                    dir (path: "$WORKSPACE/customer-api") {
                        def backendImage = docker.build("backend-api:${BUILD_ID}")
                    }
                    docker.image('mysql:latest').run("--network temp" + 
                                                        ' -e MYSQL_ROOT_PASSWORD=$DB_ROOT' + 
                                                        ' -e MYSQL_USER=$DB_USER' + 
                                                        ' -e MYSQL_PASSWORD=$DB_PASSWD' + 
                                                        ' -e MYSQL_DATABASE=customerdb' + 
                                                        " -p 3306:3306" + 
                                                        " --name database")
                    docker.image("backend-api:${BUILD_ID}").inside("----network temp" + 
                                                                    " -e SPRING_DATASOURCE_URL=jdbc:mysql://database:3306/customerdb" + 
                                                                    ' -e SPRING_DATASOURCE_USERNAME=$DB_USER' + 
                                                                    ' -e SPRING_DATASOURCE_PASSWORD=$DB_PASSWD' + 
                                                                    " -dp 8081:8080") {
                        sh 'java -jar app.jar'
                    }
                }
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