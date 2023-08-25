pipeline {
    agent none
    stages {
        stage('Build') {
            steps {
                node {
                    checkout scm 
                    docker.image('gradle:8.2-alpine').withRun('-v gradle_dep:/gradle/cache' + '-v "$PWD/customer-api":/home/gradle/project') {
                        sh 'gradle clean bootJar --info'
                    }
                }
            }
           
            // agent {
            //     docker { 
            //         image 'gradle:8.2-alpine'
            //         args '-e GRADLE_USER_HOME=/gradle/cache'
            //         args '-v gradle_dep:/gradle/cache'
            //         args '-v "$PWD/customer-api":/home/gradle/project'
            //         args '-w /home/gradle/project'   
            //     }
            // }
            // steps {
            //     sh 'cd ./customer-api'
            //     sh 'gradle clean bootJar --info'
            //     echo 'pwd'
            // }

        }
    }
}