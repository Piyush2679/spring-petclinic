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
        git branch: "${BRANCH}", url: 'https://github.com/Piyush2679/spring-petclinic.git'
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

    // Optional debug stage — uncomment to test credentials injection (safe: password length only)
    // stage('Debug: Check Credentials Binding') {
    //   steps {
    //     withCredentials([usernamePassword(credentialsId: "${DOCKERHUB_CREDENTIALS}", usernameVariable: 'DOCKERHUB_USER', passwordVariable: 'DOCKERHUB_PASS')]) {
    //       sh 'echo "Docker Hub user: $DOCKERHUB_USER"; echo "Password length: $(echo -n $DOCKERHUB_PASS | wc -c)"'
    //     }
    //   }
    // }

    stage('Push to Docker Hub') {
      steps {
        // securely bind username/password for the duration of the block
        withCredentials([usernamePassword(credentialsId: "${DOCKERHUB_CREDENTIALS}", usernameVariable: 'DOCKERHUB_USER', passwordVariable: 'DOCKERHUB_PASS')]) {
          sh '''
            echo "Logging in to Docker Hub as $DOCKERHUB_USER"
            echo "$DOCKERHUB_PASS" | docker login -u "$DOCKERHUB_USER" --password-stdin
            docker push ${IMAGE_NAME}:latest
          '''
        }
      }
    }

    stage('Deploy with Docker Compose') {
      steps {
        sh '''
          # avoid failing deploy stage if containers aren't running yet
          docker-compose down || true
          docker-compose pull || true
          docker-compose up -d
        '''
      }
    }
  }
}
