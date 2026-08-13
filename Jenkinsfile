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
                    ls -lh application.tar.gz
                '''
            }
        }

        stage('Deploy') {
            steps {
                echo 'Deploying application to Linux EC2...'

                sh '''
                    echo "Creating application backup..."

                    sudo cp /usr/share/nginx/html/index.html \
                        /usr/share/nginx/html/index.html.backup

                    echo "Preparing deployment..."

                    rm -rf /tmp/deployment
                    mkdir -p /tmp/deployment

                    tar -xzf application.tar.gz -C /tmp/deployment

                    echo "Deploying application..."

                    sudo cp /tmp/deployment/index.html \
                        /usr/share/nginx/html/index.html

                    echo "Restarting Nginx..."

                    sudo systemctl restart nginx

                    echo "Deployment completed successfully."
                '''
            }
        }

        stage('Verify') {
            steps {
                echo 'Verifying application...'

                sh '''
                    curl -f http://localhost/

                    echo "Application verification successful."
                '''
            }
        }
    }

    post {

        failure {
            echo 'Pipeline failed. Starting automatic rollback.'

            sh '''
                if [ -f /usr/share/nginx/html/index.html.backup ]; then

                    sudo cp /usr/share/nginx/html/index.html.backup \
                        /usr/share/nginx/html/index.html

                    sudo systemctl restart nginx

                    echo "Rollback completed."

                else

                    echo "Backup file not found. Rollback cannot be performed."

                fi
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