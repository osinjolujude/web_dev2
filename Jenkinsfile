pipeline{
    agent{
        docker {
            image 'python:3.9'
            args '-u root'
        }
    }
    stages {
        stage('Environment preparation') {
            steps {
                echo "-=- preparing project environment -=-"
                // Python dependencies
                sh "pip install -r requirements.txt"
            }
        }
    stages{
        stage('Checkout') {
            steps{
                // git branch: 'main', credentialsId: 'github', url: 'https://github.com/osinjolujude/web_dev.git'
                checkout scm
            }
        }
    }
    stage('Install dependencies') {
            steps {
                // Install dependencies using pip
                sh 'pip install -r requirements.txt'
            }
        }
    stage('Run tests') {
            steps {
                // Run tests (if any)
                // Example: sh 'pytest'
                sh 'pytest'
            }
        }
    // stage('Unit tests') {
    //     steps {
    //         echo "-=- execute unit tests -=-"
    //         sh "nosetests -v test"
    // }
    // }
    // stage('Build and Test') {
    //     steps {
    //         sh 'ls -ltr'
    //     }
    // }
    stage('Run Docker image') {
        steps {
            echo "-=- run Docker image -=-"
            sh "docker run --name python-jenkins-pipeline --detach --rm --network ci -p 5001:5000 restalion/python-jenkins-pipeline:0.1"
        }
    }
    // stage('Static Code Analysis') {
    //   environment {
    //     SONAR_URL = "http://52.148.143.190:9000"
    //   }
    //   steps {
    //     withCredentials([string(credentialsId: 'sonarqube', variable: 'SONAR_AUTH_TOKEN')]) {
    //       sh 'cd java-maven-sonar-argocd-helm-k8s/spring-boot-app && mvn sonar:sonar -Dsonar.login=$SONAR_AUTH_TOKEN -Dsonar.host.url=${SONAR_URL}'
    //     }
    //   }
    // }
    stage('SonarQube analysis') {
        environment {
            SONAR_URL = "http://4.154.42.1:9000"
        }
            steps {
                // Run SonarQube scanner
                withCredentials([string(credentialsId: 'sonarqube', variable: 'SONAR_AUTH_TOKEN')]) {
                    sh 'sonar-scanner'
                }
            }
        }
    stage('Build and Push Docker Image') {
      environment {
        DOCKER_IMAGE = "mayowa88/soccer_blog:${BUILD_NUMBER}"
        // DOCKERFILE_LOCATION = "java-maven-sonar-argocd-helm-k8s/spring-boot-app/Dockerfile"
        REGISTRY_CREDENTIALS = credentials('docker-cred')
      }
    stage('Build and deploy') {
        steps {
            // Build and deploy your Python web app
            // Example: sh 'python manage.py migrate && python manage.py runserver'
            sh 'python main.py migrate && python main.py runserver'
        }
    }
}
    // stage('Update Deployment File') {
    //     environment {
    //         GIT_REPO_NAME = "web_dev"
    //         GIT_USER_NAME = "osinjolujude"
    //     }
    //     steps {
    //         withCredentials([string(credentialsId: 'github', variable: 'GITHUB_TOKEN')]) {
    //             sh '''
    //                 git config user.email "tokunbo.dina@gmail.com"
    //                 git config user.name "Tokunbo Dina"
    //                 BUILD_NUMBER=${BUILD_NUMBER}
    //                 sed -i "s/replaceImageTag/${BUILD_NUMBER}/g" java-maven-sonar-argocd-helm-k8s/spring-boot-app-manifests/deployment.yml
    //                 git add java-maven-sonar-argocd-helm-k8s/spring-boot-app-manifests/deployment.yml
    //                 git commit -a -m "Update deployment image to version ${BUILD_NUMBER}"
    //                 git push https://${GITHUB_TOKEN}@github.com/${GIT_USER_NAME}/${GIT_REPO_NAME} HEAD:main
    //             '''
    //         }
    //     }
    // }