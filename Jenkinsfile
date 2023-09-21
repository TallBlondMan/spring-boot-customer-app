pipeline {
        agent {
            // My remote heavy lifting server/agent
            label 'builder'
        }
        parameters {
            string(name: 'PRIV_REPO', defaultValue: 'https://10.6.0.243:5000', description: 'Private repo with images')
            string(name: 'SERVER_IP', defaultValue: '10.6.0.232', description: 'IP of the deployment server')
        }
        environment {
            // Secret data for DB setup and connection
            DB_USER = credentials('DB_User')
            DB_PASSWD = credentials('DB_password')
            DB_ROOT = credentials('DB_Root_Password')
            // Idealy this would be a FQDN name :)
            PRIV_REPO = ${params.PRIV_REPO}
            // And this could be added as variable for build
            SERVER_IP = ${params.SERVER_IP}
        }
    stages {
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
        stage('SonarQube analysis') {
            steps {
                echo "******************* SonarQube scaner analisys *******************"
                script{
                    // Run in docker container to not bother with gradle installs
                    docker.image('gradle:8.2-alpine').inside('-u root') {
                        // Specify the server
                        withSonarQubeEnv('sonar_server') {
                            dir (path: "$WORKSPACE/customer-api"){
                                // And the command to run for SonarScaner
                                // This is defined in detail in build.gradle
                                sh 'gradle sonar'
                            }
                        }
                    }
                }
            }
        }
        stage('Build backend') {
            steps {
                echo "******************* Building BackEnd *******************"
                script {
                    // Environment setup
                    sh 'docker network create temp'
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
                    // It's supplied with gradle_dep volume for the dependencies to be stored
                    docker.image('gradle:8.2-alpine').inside("-e GRADLE_USER_HOME=/gradle/cache" + 
                                                                " -v gradle_dep:/gradle/cache" + 
                                                                " --network temp" + 
                                                                " -e SPRING_DATASOURCE_URL=jdbc:mysql://database:3306/customerdb" +  
                                                                ' -e SPRING_DATASOURCE_USERNAME=$DB_USER' +
                                                                ' -e SPRING_DATASOURCE_PASSWORD=$DB_PASSWD' +
                                                                ' -u root') {
                        dir (path: "$WORKSPACE/customer-api"){
                            sh 'gradle clean build --info'
                        }
                    }
                    // This could be done in post for this stage but it's done at the end if it fails
                    // And I wanted to have a post.global stage
                    dummySQL.stop()
                }
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
                        docker.withRegistry("${PRIV_REPO}"){
                            backendImage.push('latest')
                        }
                        echo 'Image is stored!'
                    }
                }
            }
        }
        stage('Build and push Frontend') {
            steps {
                echo '******************* Compile and build frontend *******************'
                // Dockerfile is present in the directory to build the frontend
                script {
                    dir (path: "$WORKSPACE/customer-frontend") {
                        // Setting the IP of the server
                        sh 'sed -i "s/<serverIP>/${SERVER_IP}/" .env'
                        def frontendImage = docker.build("frontend-api:${BUILD_ID}")
                        // Simple test of made app
                        // Might want to test it later but for now just a simple script
                        def frontendCont = docker.image("frontend-api:${BUILD_ID}").withRun('-p 8081:8081' + ' --name frontend') {
                            // The TEST
                            sh 'sleep 3'
                            sh 'docker logs frontend'
                        } 
                        // And send it on it's marry way
                        docker.withRegistry("${PRIV_REPO}") {
                            frontendImage.push('latest')
                        }
                        echo 'Image is stored!'
                    }
                }
            }
        }
        stage('Database setup') {
            steps {
                echo '******************* Database setup *******************'
                    // Pass the database creation details into Dockerfile
                script {
                    dir (path: "$WORKSPACE/db") {
                        // This will ensure our database has a table inside
                        def databaseImage = docker.build("app-database:${BUILD_ID}")
                        docker.withRegistry("${PRIV_REPO}") {
                            databaseImage.push('latest')
                        }
                    }
                }
            }
        }
        stage ('Deploy') {
            steps {
                echo '******************* Docker Compose / Docker Swarm *******************'
                // Set the DB details in docker compose
                // And set the host parameters  
                sh 'sed -i "s/<root_pass>/${DB_ROOT}/" docker-compose.yaml'
                sh 'sed -i "s/<db_user>/${DB_USER}/" docker-compose.yaml'
                sh 'sed -i "s/<db_pass>/${DB_PASSWD}/" docker-compose.yaml'
                sh 'sed -i "s/<serverIP>/${SERVER_IP}/" docker-compose.yaml'

                // Start the application stack
                sh 'docker compose up -d --wait'
            }
        }
    }
    post {
        always {
            echo '******************* CLEANING UP *******************'
            sh 'docker rm -f database'
            sh 'docker network rm temp'

            echo '******************* GATHERING ARTIFACTS *******************'
            archiveArtifacts artifacts: 'customer-api/build/libs/*.jar', fingerprint: true
        }
    }
}