pipeline {
        agent {
            label 'builder'
        }
        environment {
            // Secret data for DB setup and connection
            DB_USER = credentials('DB_User')
            DB_PASSWD = credentials('DB_password')
            DB_ROOT = credentials('DB_Root_Password')
        }
    stages {
        stage('Build backend') {
            steps {
                echo "******************* Building FrontEnd *******************"
                script {
                    // Building the image with gradle container
                    docker.image('gradle:8.2-alpine').inside("-e GRADLE_USER_HOME=/gradle/cache" + " -v gradle_dep:/gradle/cache") {
                        dir (path: "$WORKSPACE/customer-api"){
                            sh 'gradle clean bootJar --info'
                        }
                    }
                    // Building the Docker image for later test and deployment
                    dir (path: "$WORKSPACE/customer-api"){
                        def backendImage = docker.build("backend-api:${BUILD_ID}")
                    }
                }
            }
        }
        stage('OWASP') {
            steps {
                // Check dependencies for vulnerabilities 
                echo "******************* Checking dependencies with OWASP *******************"
                dir (path: "$WORKSPACE/customer-api"){
                    dependencyCheck additionalArguments: '', odcInstallation: 'owaspdc', skipOnScmChange: true
                }
                // Catching the file and posting the results
                dependencyCheckPublisher pattern: "**/dependency-check-report.xml"
            }
        }
        stage ('Test backend') {
            steps {
                echo "******************* Spin-UP MySQL database and test backend *******************"
                script {
                    // Start a sidecar MySQL database for Spring tests
                    def dummySQL = docker.image('mysql:latest').run("-e MYSQL_ALLOW_EMPTY_PASSWORD=True" + 
                                                            " --network temp" + 
                                                            " --name database" + 
                                                            " -p 3306:3306")
                        // Run test to check if MySQL is UP
                        // sh 'until curl -sSf http://database:3306; do sleep 5; done'
                    sh 'while ! nc -zv localhost 3306; do sleep 5; done'
                    // Run the app for Spring tests
                    def testApp = docker.image("backend-api:${BUILD_ID}").inside("--network temp" + 
                                                                    " -e SPRING_DATASOURCE_URL=jdbc:mysql://database:3306/customerdb" + 
                                                                    ' -e SPRING_DATASOURCE_USERNAME=root' + 
                                                                    ' -e SPRING_DATASOURCE_PASSWORD=' + 
                                                                    " -p 8081:8080") {
                        sh 'java -jar app.jar'
                    }
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