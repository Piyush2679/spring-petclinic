pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = "dockerhub-practice-id"
        IMAGE_NAME = "piyushinsys/petclinic"
        BRANCH = "main"
    }

    stages {
        stage('Clone Repo') {
            steps {
                git branch: "${BRANCH}", url: 'https://github.com/spring-projects/spring-petclinic.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                    docker build -t ${IMAGE_NAME}:${BUILD_NUMBER} .
                    docker tag ${IMAGE_NAME}:${BUILD_NUMBER} ${IMAGE_NAME}:latest
                '''
            }
        }

        stage('Push to Docker Hub') {
            steps {
                sh '''
                    echo ${DOCKERHUB_CREDENTIALS_PSW} | docker login -u ${DOCKERHUB_CREDENTIALS_USR} --password-stdin
                    docker push ${IMAGE_NAME}:latest
                '''
            }
        }

        stage('Deploy with Docker Compose') {
            steps {
                sh '''
                    docker-compose down
                    docker-compose pull
                    docker-compose up -d
                '''
            }
        }
    }
}

