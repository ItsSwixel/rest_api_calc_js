pipeline {

  environment {
    PROJECT_DIR = "/app"
    REGISTRY = "swixel/rest_api_calc" + ":" + "$BUILD_NUMBER"
    DOCKER_CREDENTIALS = "docker_auth"
    DOCKER_IMAGE = ""
  }

  agent any

  options {
    skipStagesAfterUnstable()
  }

  stages {

    stage("Cloning the code from git") {
      steps {
        git branch: 'main',
        url: 'https://github.com/ItsSwixel/rest_api_calc.git'
      }
    }

    stage('Build-Image') {
      steps {
        script {
          DOCKER_IMAGE = docker.build REGISTRY
        }
      }
    }

    stage('Test the docker container') {
      steps {
        script {
          sh '''
            docker run -v $PWD/test-results:/reports --workdir $PROJECT_DIR $REGISTRY pytest -v --junitxml=/reports/results.xml
            ls -la $PWD/test-results
          '''
        }
      }
      post {
        always {
          junit testResults: '**/test-results/*.xml'
        }
      }
    }

    stage('Deploy to Docker Hub') {
      steps {
        script {
          docker.withRegistry('', DOCKER_CREDENTIALS) {
            DOCKER_IMAGE.push()
          }
        }
      }
    }

    stage('Removing the Docker Image') {
      steps {
        sh "docker rmi $REGISTRY"
      }
    }
  }
}
