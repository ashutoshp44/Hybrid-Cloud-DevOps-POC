pipeline {
    agent any

    environment {
        APP_NAME = 'hybrid-cloud-devops-poc'
        BUILD_DIR = 'build'
        PACKAGE_NAME = 'application.tar.gz'
    }

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
                    set -e

                    mvn clean compile
                '''
            }
        }

        stage('Maven Test') {
            steps {
                echo 'Running Maven unit tests...'

                sh '''
                    set -e

                    mvn test
                '''
            }
        }

        stage('Docker Build') {
            steps {
                echo 'Building Docker image...'

                sh '''
                    set -e

                    docker build -t hybrid-cloud-devops-poc:latest .
                '''
            }
        }

        stage('Trivy Security Scan') {
            steps {
                echo 'Scanning Docker image for HIGH and CRITICAL vulnerabilities...'

                sh '''
                    set -e

                    trivy image \
                        --severity HIGH,CRITICAL \
                        --exit-code 1 \
                        hybrid-cloud-devops-poc:latest

                    echo "Trivy security scan passed."
                '''
            }
        }

        stage('Docker Push to ECR') {
            steps {
                echo 'Pushing Docker image to Amazon ECR...'

                sh '''
                    set -e

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

        stage('Deployment Information') {
            steps {
                echo 'Collecting deployment traceability information...'

                sh '''
                    set -e

                    echo "=========================================="
                    echo "DEPLOYMENT INFORMATION"
                    echo "=========================================="

                    echo "Jenkins Build Number : ${BUILD_NUMBER}"
                    echo "Jenkins Build URL    : ${BUILD_URL}"

                    GIT_COMMIT_ID=$(git rev-parse HEAD)
                    GIT_BRANCH_NAME=$(git rev-parse --abbrev-ref HEAD)

                    echo "Git Commit ID        : ${GIT_COMMIT_ID}"
                    echo "Git Branch           : ${GIT_BRANCH_NAME}"

                    VERSION="build-${BUILD_NUMBER}"

                    echo "ECR Image Tag        : ${VERSION}"

                    ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

                    ECR_URI="$ACCOUNT_ID.dkr.ecr.ap-south-1.amazonaws.com/hybrid-cloud-devops-poc"

                    echo "ECR Repository       : ${ECR_URI}"

                    IMAGE_DIGEST=$(aws ecr describe-images \
                        --repository-name "hybrid-cloud-devops-poc" \
                        --image-ids imageTag="$VERSION" \
                        --region ap-south-1 \
                        --query 'imageDetails[0].imageDigest' \
                        --output text)

                    echo "ECR Image Digest     : ${IMAGE_DIGEST}"

                    echo "Deployment Time      : $(date -u '+%Y-%m-%d %H:%M:%S UTC')"

                    echo "=========================================="
                    echo "Deployment traceability information collected successfully."
                    echo "=========================================="
                '''
            }
        }

        stage('Build') {
            steps {
                echo 'Building application...'

                sh '''
                    set -e

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
                    set -e

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
                    set -e

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

                    echo "Waiting for Docker container to become healthy..."

                    for i in {1..12}; do
                        HEALTH_STATUS=$(docker inspect --format='{{.State.Health.Status}}' ecr-app 2>/dev/null || echo "unknown")
                        echo "Docker health status: ${HEALTH_STATUS} (attempt ${i}/12)"

                        if [ "${HEALTH_STATUS}" = "healthy" ]; then
                            echo "Docker container is healthy."
                            break
                        fi

                        if [ "${HEALTH_STATUS}" = "unhealthy" ]; then
                            echo "Docker container is unhealthy."
                            docker logs ecr-app || true
                            exit 1
                        fi

                        sleep 5
                    done

                    FINAL_HEALTH_STATUS=$(docker inspect --format='{{.State.Health.Status}}' ecr-app 2>/dev/null || echo "unknown")

                    if [ "${FINAL_HEALTH_STATUS}" != "healthy" ]; then
                        echo "Docker container did not become healthy within the timeout."
                        docker ps -a --filter "name=ecr-app"
                        docker logs ecr-app || true
                        exit 1
                    fi

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
            echo 'Pipeline failed. Starting automatic rollback...'

            sh '''
                set +e

                ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

                ECR_URI="$ACCOUNT_ID.dkr.ecr.ap-south-1.amazonaws.com/hybrid-cloud-devops-poc"

                CURRENT_BUILD="${BUILD_NUMBER}"
                PREVIOUS_BUILD=$((CURRENT_BUILD - 1))

                PREVIOUS_VERSION="build-${PREVIOUS_BUILD}"

                echo "Current failed build: ${CURRENT_BUILD}"
                echo "Rollback target: ${PREVIOUS_VERSION}"

                if [ "${PREVIOUS_BUILD}" -lt 1 ]; then

                    echo "No previous build available for rollback."

                else

                    echo "Logging in to Amazon ECR..."

                    aws ecr get-login-password --region ap-south-1 | \
                    docker login --username AWS --password-stdin \
                    "$ACCOUNT_ID.dkr.ecr.ap-south-1.amazonaws.com"

                    echo "Checking rollback image..."

                    if ! docker image inspect "$ECR_URI:$PREVIOUS_VERSION" >/dev/null 2>&1; then

                        echo "Previous image not available locally."
                        echo "Pulling ${PREVIOUS_VERSION} from ECR..."

                        docker pull "$ECR_URI:$PREVIOUS_VERSION"

                    fi

                    echo "Removing failed application container..."

                    if docker ps -a --format '{{.Names}}' | grep -q '^ecr-app$'; then

                        docker stop ecr-app || true

                        docker rm ecr-app || true

                    fi

                    echo "Starting rollback container..."

                    docker run -d \
                        --name ecr-app \
                        -p 127.0.0.1:8081:80 \
                        "$ECR_URI:$PREVIOUS_VERSION"

                    echo "Waiting for rollback application..."

                    sleep 5

                    echo "Checking rollback container..."

                    if docker ps --format '{{.Names}}' | grep -q '^ecr-app$'; then

                        echo "Rollback container started successfully."

                    else

                        echo "Rollback container failed to start."

                    fi

                    echo "Testing rollback application on port 8081..."

                    curl -f --max-time 10 http://127.0.0.1:8081/ || exit 1

                    echo "Testing rollback production endpoint through Nginx..."

                    curl -f --max-time 10 http://localhost/ || exit 1

                    echo "=========================================="
                    echo "AUTOMATIC ROLLBACK COMPLETED"
                    echo "Rollback version: ${PREVIOUS_VERSION}"
                    echo "=========================================="

                fi
'''
        }

        success {
            echo 'Jenkins CI/CD pipeline completed successfully.'

            sh '''
                set -e

                echo "Sending Jenkins success notification..."

                GIT_COMMIT_ID=$(git rev-parse HEAD 2>/dev/null || echo "Unavailable")

                ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

                ECR_URI="$ACCOUNT_ID.dkr.ecr.ap-south-1.amazonaws.com/hybrid-cloud-devops-poc"

                VERSION="build-${BUILD_NUMBER}"

                IMAGE_DIGEST=$(aws ecr describe-images \
                    --repository-name "hybrid-cloud-devops-poc" \
                    --image-ids imageTag="$VERSION" \
                    --region ap-south-1 \
                    --query 'imageDetails[0].imageDigest' \
                    --output text)
            '''
        }

        always {
            sh '''
                rm -f application.tar.gz || true
                rm -rf /tmp/deployment || true
            '''
        }
    }
}
