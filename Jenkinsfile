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
                    mkdir -p "$WORKSPACE/.ssh"

                    chmod 600 "$JENKINS_SSH_KEY"

                    ssh-keyscan -H "$EC2_HOST" > "$WORKSPACE/.ssh/known_hosts"

                    ssh \
                      -i "$JENKINS_SSH_KEY" \
                      -o UserKnownHostsFile="$WORKSPACE/.ssh/known_hosts" \
                      -o StrictHostKeyChecking=yes \
                      "$EC2_USERNAME@$EC2_HOST" \
                      "sudo cp /usr/share/nginx/html/index.html /usr/share/nginx/html/index.html.backup"

                    scp \
                      -i "$JENKINS_SSH_KEY" \
                      -o UserKnownHostsFile="$WORKSPACE/.ssh/known_hosts" \
                      -o StrictHostKeyChecking=yes \
                      application.tar.gz \
                      "$EC2_USERNAME@$EC2_HOST:/tmp/application.tar.gz"

                    ssh \
                      -i "$JENKINS_SSH_KEY" \
                      -o UserKnownHostsFile="$WORKSPACE/.ssh/known_hosts" \
                      -o StrictHostKeyChecking=yes \
                      "$EC2_USERNAME@$EC2_HOST" \
                      "rm -rf /tmp/deployment && \
                       mkdir -p /tmp/deployment && \
                       tar -xzf /tmp/application.tar.gz -C /tmp/deployment && \
                       sudo cp /tmp/deployment/index.html /usr/share/nginx/html/index.html && \
                       sudo systemctl restart nginx"
                '''
            }
        }

        stage('Verify') {
            steps {
                echo 'Verifying application...'

                sh '''
                    ssh \
                      -i "$JENKINS_SSH_KEY" \
                      -o UserKnownHostsFile="$WORKSPACE/.ssh/known_hosts" \
                      -o StrictHostKeyChecking=yes \
                      "$EC2_USERNAME@$EC2_HOST" \
                      "curl -f http://localhost/"

                    echo "Application verification successful."
                '''
            }
        }
    }

    post {
        failure {
            echo 'Pipeline failed. Starting automatic rollback.'

            sh '''
                if [ -f "$JENKINS_SSH_KEY" ]; then

                    ssh \
                      -i "$JENKINS_SSH_KEY" \
                      -o UserKnownHostsFile="$WORKSPACE/.ssh/known_hosts" \
                      -o StrictHostKeyChecking=yes \
                      "$EC2_USERNAME@$EC2_HOST" \
                      "if [ -f /usr/share/nginx/html/index.html.backup ]; then \
                       sudo cp /usr/share/nginx/html/index.html.backup /usr/share/nginx/html/index.html && \
                       sudo systemctl restart nginx; \
                       else \
                       echo 'Backup file not found'; \
                       exit 1; \
                       fi"

                    echo "Rollback completed."
                fi
            '''
        }

        success {
            echo 'Jenkins CI/CD pipeline completed successfully.'
        }

        always {
            sh '''
                rm -f application.tar.gz || true
                rm -rf "$WORKSPACE/.ssh" || true
            '''
        }
    }
}