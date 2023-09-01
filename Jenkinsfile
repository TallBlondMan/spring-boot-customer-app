pipeline {
        agent {
            // My remote heavy lifting server/agent
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
                echo "******************* Building BackEnd *******************"
                script {
                    // Start a sidecar MySQL database for Spring tests
                    def dummySQL = docker.image('mysql:latest').run('-e MYSQL_ROOT_PASSWORD=$DB_ROOT' + 
                                                            " -e MYSQL_DATABASE=customerdb" + 
                                                            ' -e MYSQL_USER=$DB_USER' +
                                                            ' -e MYSQL_PASSWORD=$DB_PASSWD' +
                                                            " --network temp" + 
                                                            " --name database" + 
                                                            " -p 3306:3306")
                    // Run test to check if MySQL is UP
                    sh 'until docker exec database mysql -hlocalhost -u$DB_USER -p$DB_PASSWD; do sleep 5; done'
                    echo 'The DB is UP'
                    // Building the image with gradle container
                    docker.image('gradle:8.2-alpine').inside("-e GRADLE_USER_HOME=/gradle/cache" + 
                                                                " -v gradle_dep:/gradle/cache" + 
                                                                " --network temp" + 
                                                                " -e SPRING_DATASOURCE_URL=jdbc:mysql://database:3306/customerdb" + 
                                                                " -e SPRING_DATASOURCE_USERNAME=root" + 
                                                                ' -e SPRING_DATASOURCE_USERNAME=$DB_USER' +
                                                                ' -e SPRING_DATASOURCE_PASSWORD=$DB_PASSWD') {
                        dir (path: "$WORKSPACE/customer-api"){
                            sh 'gradle clean build --info'
                        }
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
        stage ('Build and push Backend') {
            steps {
                echo "******************* Build and Push backend image *******************"
                script {
                    // Building the Docker image for later test and deployment
                    dir (path: "$WORKSPACE/customer-api"){
                        def backendImage = docker.build("backend-api:${BUILD_ID}")
                        // This will push the image to internal registry - for now it saves the image on host
                        docker.withRegistry('https://10.6.0.243:5000'){
                            backendImage.push('latest')
                        }
                        echo 'Image is stored!'
                    }
                }
            }
        }
        stage('Build Frontend') {
            steps {
                echo '******************* Compile and build frontend *******************'
                // Dockerfile is present in the directory to build the frontend
                dir (path: "$WORKSPACE/customer-frontend") {
                    def frontendImage = docker.build("frontend-api:${BUILD_ID}")
                    // Might want to rest it later but for now just a simple script
                    def frontendCont = docker.image("frontend-api:${BUILD_ID}").withRun('-p 8081:8081' + ' --network temp' + ' --name frontend') {
                        sh 'docker logs frontend'
                    } 
                }
            }
        }
        stage('SonarQube') {
            steps {
                echo '******************* SonarQube analize *******************'
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
            sh "docker rm -f database"
        }
    }
}