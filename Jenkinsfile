pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "piyushinsys/petclinic"
        DOCKERHUB_CRED = "dockerhub-practice-id"
        GIT_BRANCH = "main"
    }

    stages {

        stage('Checkout Code') {
            steps {
                echo "Checking out code from GitHub..."
                git branch: "${GIT_BRANCH}", url: "https://github.com/Piyush2679/spring-petclinic.git"
            }
        }

        stage('Build Jar with Maven') {
            steps {
                echo "Running mvn clean package..."
                sh './mvnw clean package -DskipTests'
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "Building docker image..."
                sh """
                    docker build -t ${DOCKER_IMAGE}:${BUILD_NUMBER} .
                    docker tag ${DOCKER_IMAGE}:${BUILD_NUMBER} ${DOCKER_IMAGE}:latest
                """
            }
        }

        stage('Login and Push to Docker Hub') {
            steps {
                echo "Login to docker hub and pushing image..."
                withCredentials([usernamePassword(
                    credentialsId: "${DOCKERHUB_CRED}",
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh '''
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                        docker push '"${DOCKER_IMAGE}"':'"${BUILD_NUMBER}"'
                        docker push '"${DOCKER_IMAGE}"':latest
                    '''
                }
            }
        }

        stage('Deploy using Docker Compose') {
            steps {
                echo "Deploying with docker-compose..."
                sh '''
                    docker-compose down || true
                    docker-compose pull
                    docker-compose up -d
                '''
            }
        }
    }

    post {
        always {
            echo "Build finished. Build number: ${BUILD_NUMBER}"
        }
    }
}
