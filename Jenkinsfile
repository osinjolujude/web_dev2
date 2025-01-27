pipeline{
    agent{
        docker {
            image 'python:3.9'
            args '-u root -v /var/run/docker.sock:/var/run/docker.sock'
        }
    }
    stages {
        stage('Environment preparation') {
            steps {
                echo "-=- preparing project environment -=-"
                sh 'apt update'
                sh 'apt install python3 -y'
                sh 'apt install docker.io -y'
                sh 'python3 --version'
                sh 'docker -v'
                echo "Installation packages complete"
            }
        }
        stage('Checkout') {
            steps{
                // git branch: 'main', credentialsId: 'github', url: 'https://github.com/osinjolujude/web_dev.git'
                git branch: 'main', credentialsId: 'github', url: 'https://github.com/osinjolujude/web_dev.git'
                checkout scm
            }
        }
        stage('Install dependencies') {
                steps {
                    // Install dependencies using pip
                    sh 'pip install -r requirements.txt'
                    // sh 'pip install --upgrade pip'
                }
            }
        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('my-scanner') {
                    sh "/var/lib/jenkins/workspace/soccer_demo@tmp/sonar-scanner-5.0.1.3006-linux/bin/sonar-scanner -Dsonar.projectKey=Soccer_Blog -Dsonar.sources=."
                }
            }
        }
        stage('Build and Push Docker Image') {
        environment {
            DOCKER_IMAGE = "mayowa88/soccer_blog:${BUILD_NUMBER}"
            // DOCKERFILE_LOCATION = "java-maven-sonar-argocd-helm-k8s/spring-boot-app/Dockerfile"
            REGISTRY_CREDENTIALS = credentials('docker-cred')
        }
        steps {
            script {
                sh 'docker build -t ${DOCKER_IMAGE} .'
                def dockerImage = docker.image("${DOCKER_IMAGE}")
                docker.withRegistry('https://index.docker.io/v1/', "docker-cred") {
                    dockerImage.push()
                }
            }
        }
        }
        // stage('Build and deploy') {
        //     steps {
        //         // Build and deploy your Python web app
        //         // Example: sh 'python manage.py migrate && python manage.py runserver'
        //         sh 'python main.py migrate && python main.py runserver'
        //     }
        // }
        stage('Update Deployment File') {
        environment {
            GIT_REPO_NAME = "web_dev"
            GIT_USER_NAME = "osinjolujude"
        }
        steps {
            withCredentials([string(credentialsId: 'github', variable: 'GITHUB_TOKEN')]) {
                sh '''
                    pwd
                    git config --global --add safe.directory /var/lib/jenkins/workspace/soccer_demo
                    git status
                    git config user.email "osinjolumayowa@gmail.com"
                    git config user.name "mayowa osinjolu"
                    BUILD_NUMBER=${BUILD_NUMBER}
                    sed -i "s/replaceImageTag/${BUILD_NUMBER}/g" kubernetes/deployment.yaml
                    git add kubernetes/deployment.yaml
                    git commit -a -m "Update deployment image to version ${BUILD_NUMBER}"
                    git push https://${GITHUB_TOKEN}@github.com/${GIT_USER_NAME}/${GIT_REPO_NAME} HEAD:main
                '''
            }
        }
    }
  }
}