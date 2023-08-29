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
                    // Added to build stage
                    def backendImage = docker.build("backend-api:${BUILD_ID}")
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
                    // Start a sidecar MySQL database for Spring tests
                    docker.image('mysql:latest').withRun("-e MYSQL_ALLOW_EMPTY_PASSWORD=True" + 
                                                            " --network temp" + 
                                                            " --name databse" + 
                                                            " -p 3306:3306") { 
                        // Run test to check if MySQL is UP
                        sh 'while ! mysqladmin ping -h localhost; do sleep 5; done'
                    }
                    // Run the app for Spring tests
                    docker.image("backend-api:${BUILD_ID}").inside("--network temp" + 
                                                                    " -e SPRING_DATASOURCE_URL=jdbc:mysql://database:3306/customerdb" + 
                                                                    ' -e SPRING_DATASOURCE_USERNAME=root' + 
                                                                    ' -e SPRING_DATASOURCE_PASSWORD=' + 
                                                                    " -p 8081:8080")
                    // dir (path: "$WORKSPACE/customer-api") {
                    //     def backendImage = docker.build("backend-api:${BUILD_ID}")
                    // }
                    // docker.image('mysql:latest').run("--network temp" + 
                    //                                     ' -e MYSQL_ROOT_PASSWORD=$DB_ROOT' + 
                    //                                     ' -e MYSQL_USER=$DB_USER' + 
                    //                                     ' -e MYSQL_PASSWORD=$DB_PASSWD' + 
                    //                                     ' -e MYSQL_DATABASE=customerdb' + 
                    //                                     " -p 3306:3306" + 
                    //                                     " --name database")
                    // docker.image('mysql:latest').inside("--network temp") {
                    //     sh 'while ! mysqladmin ping -h database; do sleep 5; done'
                    // }
                    // docker.image("backend-api:${BUILD_ID}").inside("--network temp" + 
                    //                                                 " -e SPRING_DATASOURCE_URL=jdbc:mysql://database:3306/customerdb" + 
                    //                                                 ' -e SPRING_DATASOURCE_USERNAME=$DB_USER' + 
                    //                                                 ' -e SPRING_DATASOURCE_PASSWORD=$DB_PASSWD' + 
                    //                                                 " -dp 8081:8080") {
                    //     sh 'java -jar app.jar'
                    // }
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
    post {
        always {
            echo '******************* CLEANING UP *******************'
            sh "docker ps -a | awk '{print \$1}' | xargs -r docker rm -f"
        }
    }
}