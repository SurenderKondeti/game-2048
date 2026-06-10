pipeline {
  agent any

  environment {
    AWS_REGION   = 'us-east-1'
    ECR_REGISTRY = '782453132567.dkr.ecr.us-east-1.amazonaws.com'
    ECR_REPO     = 'game-2048'
    IMAGE_TAG    = "${BUILD_NUMBER}"
    CLUSTER_NAME = 'game-2048-cluster'
  }

  stages {
    stage('Checkout') {
      steps {
        git branch: 'main',
            url: 'https://github.com/SurenderKondeti/game-2048.git'
      }
    }

    stage('Docker Build') {
      steps {
        sh "docker build -t ${ECR_REGISTRY}/${ECR_REPO}:${IMAGE_TAG} ."
      }
    }

    stage('Push to ECR') {
      steps {
        sh """
          aws ecr get-login-password --region ${AWS_REGION} | \
            docker login --username AWS --password-stdin ${ECR_REGISTRY}
          docker push ${ECR_REGISTRY}/${ECR_REPO}:${IMAGE_TAG}
        """
      }
    }

    stage('Deploy to EKS') {
      steps {
        sh """
          sed -i 's|IMAGE_PLACEHOLDER|${ECR_REGISTRY}/${ECR_REPO}:${IMAGE_TAG}|g' k8s/deployment.yaml
          kubectl apply -f k8s/deployment.yaml
          kubectl apply -f k8s/service.yaml
          kubectl rollout status deployment/game-2048
        """
      }
    }
  }

  post {
    success { echo "Deployed successfully - build #${BUILD_NUMBER}" }
    failure { echo "Pipeline failed - check logs above" }
  }
}
