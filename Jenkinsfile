pipeline {
    agent any

    environment {
        MSSV = '23120282'
        DOCKER_HUB_USERNAME = 'chung05' 
        DOCKER_IMAGE = "${DOCKER_HUB_USERNAME}/23120282"
        CONTAINER_NAME = "${MSSV}/devops"
        DOCKER_CREDENTIALS_ID = 'docker-hub-credentials'
    }

    triggers {
        // Check for SCM changes every minute
        pollSCM '* * * * *'
    }

    stages {
        stage('Checkout') {
            steps {
                echo 'Checking out code...'
                checkout scm
            }
        }

        stage('Build Image') {
            steps {
                script {
                    echo 'Building Docker image...'
                    docker.build("${DOCKER_IMAGE}:latest")
                }
            }
        }

        stage('Push to DockerHub') {
            steps {
                script {
                    echo 'Pushing to Docker Hub...'
                    // Using withCredentials to explicitly handle login (more robust than withRegistry)
                    withCredentials([usernamePassword(credentialsId: DOCKER_CREDENTIALS_ID, usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                        sh "echo \$DOCKER_PASS | docker login -u \$DOCKER_USER --password-stdin"
                        sh "docker push ${DOCKER_IMAGE}:latest"
                    }
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    echo 'Deploying application...'
                    sh "docker rm -f ${CONTAINER_NAME} || true"
                    sh """
                        docker run -d \
                        --name ${CONTAINER_NAME} \
                        -p 8081:80 \
                        ${DOCKER_IMAGE}:latest
                    """
                }
            }
        }
    }
}
