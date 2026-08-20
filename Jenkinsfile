pipeline {
    agent any

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Maven Build') {
            steps {
                echo 'Running Maven build...'

                sh '''
                    mvn clean compile
                '''
            }
        }

        stage('Maven Test') {
            steps {
                echo 'Running Maven unit tests...'

                sh '''
                    mvn test
                '''
            }
        }

        stage('Docker Build') {
            steps {
                echo 'Building Docker image...'

                sh '''
                    docker build -t hybrid-cloud-devops-poc:latest .
                '''
            }
        }

        stage('Docker Push to ECR') {
            steps {
                echo 'Pushing Docker image to Amazon ECR...'

                sh '''
                    ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
                    ECR_URI="$ACCOUNT_ID.dkr.ecr.ap-south-1.amazonaws.com/hybrid-cloud-devops-poc"
                    VERSION="build-${BUILD_NUMBER}"

                    echo "Logging in to Amazon ECR..."

                    aws ecr get-login-password --region ap-south-1 | \
                    docker login --username AWS --password-stdin \
                    "$ACCOUNT_ID.dkr.ecr.ap-south-1.amazonaws.com"

                    echo "Tagging image with version: $VERSION"

                    docker tag hybrid-cloud-devops-poc:latest "$ECR_URI:$VERSION"
                    docker tag hybrid-cloud-devops-poc:latest "$ECR_URI:latest"

                    echo "Pushing versioned image: $VERSION"

                    docker push "$ECR_URI:$VERSION"

                    echo "Updating latest tag..."

                    docker push "$ECR_URI:latest"

                    echo "ECR image push completed successfully."
                '''
            }
        }

        stage('Build') {
            steps {
                echo 'Building application...'

                sh '''
                    rm -rf build
                    mkdir -p build

                    cp app/index.html build/index.html

                    echo "Build completed."

                    ls -la build
                '''
            }
        }

        stage('Test') {
            steps {
                echo 'Testing application...'

                sh '''
                    test -f build/index.html

                    grep -q "Hybrid Cloud DevOps" build/index.html

                    echo "Application tests passed."
                '''
            }
        }

        stage('Package') {
            steps {
                echo 'Creating deployment package...'

                sh '''
                    tar -czf application.tar.gz -C build index.html

                    echo "Package created successfully."

                    ls -lh application.tar.gz
                '''
            }
        }

        stage('Deploy') {
            steps {
                echo 'Deploying versioned Docker image from Amazon ECR...'

                sh '''
                    set -e

                    ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

                    ECR_URI="$ACCOUNT_ID.dkr.ecr.ap-south-1.amazonaws.com/hybrid-cloud-devops-poc"

                    VERSION="build-${BUILD_NUMBER}"

                    echo "Deployment version: $VERSION"

                    echo "Logging in to Amazon ECR..."

                    aws ecr get-login-password --region ap-south-1 | \
                    docker login --username AWS --password-stdin \
                    "$ACCOUNT_ID.dkr.ecr.ap-south-1.amazonaws.com"

                    echo "Pulling ECR image: $VERSION"

                    docker pull "$ECR_URI:$VERSION"

                    echo "Checking existing application container..."

                    if docker ps -a --format '{{.Names}}' | grep -q '^ecr-app$'; then

                        echo "Stopping existing ecr-app container..."

                        docker stop ecr-app || true

                        echo "Removing existing ecr-app container..."

                        docker rm ecr-app || true

                    fi

                    echo "Starting new application container..."

                    docker run -d \
                        --name ecr-app \
                        -p 127.0.0.1:8081:80 \
                        "$ECR_URI:$VERSION"

                    echo "Waiting for application to start..."

                    sleep 5

                    echo "Checking Docker container status..."

                    docker ps --filter "name=ecr-app"

                    echo "Deployment completed successfully."
                '''
            }
        }

        stage('Verify') {
            steps {
                echo 'Verifying Docker application and production endpoint...'

                sh '''
                    set -e

                    echo "Checking Docker application on port 8081..."

                    curl -f http://127.0.0.1:8081/

                    echo "Docker application health check passed."

                    echo "Checking production endpoint through Nginx..."

                    curl -f http://localhost/

                    echo "Production application verification successful."
                '''
            }
        }
    }

    post {

        failure {
            echo 'Pipeline failed. Starting rollback...'

            sh '''
                echo "Checking for running ecr-app container..."

                if docker ps -a --format '{{.Names}}' | grep -q '^ecr-app$'; then

                    echo "Removing failed ecr-app container..."

                    docker stop ecr-app || true

                    docker rm ecr-app || true

                fi

                echo "Rollback cleanup completed."

                echo "Previous ECR image remains available for manual rollback."
            '''
        }

        success {
            echo 'Jenkins CI/CD pipeline completed successfully.'
        }

        always {
            sh '''
                rm -f application.tar.gz || true
                rm -rf /tmp/deployment || true
            '''
        }
    }
}
