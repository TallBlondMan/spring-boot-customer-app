pipeline {
    agent none
    stages {
        stage('Build') {
            agent {
                docker { 
                    image 'gradle:8.2-alpine'
                    args [ '-e GRADLE_USER_HOME=/gradle/cache', '-v gradle_dep:/gradle/cache' ]
                }
            }
            steps {
                dir (path: '/home/jenkins_2/workspace/devopserka/customer-api'){
                    sh 'pwd'
                    sh 'gradle clean bootJar --info'
                }
            }
        }
    }
}