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
                // Python dependencies
                sh "pip install -r requirements.txt"
                sh 'apt-update'
                echo '$0'
                bash 'apt update'
                bash 'apt install python -y'
                bash 'apt install docker.io -y'
                bash 'python3 --version'
                echo "Installation packages complete"
            }
        }
        stage('Checkout') {
            steps{
                // git branch: 'main', credentialsId: 'github', url: 'https://github.com/osinjolujude/web_dev.git'
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
        // stage('Run Docker image') {
        //     steps {
        //         echo "-=- run Docker image -=-"
        //         sh "docker run --name soccer_blog-pipeline --detach --rm --network ci -p 5001:5000 restalion/python-jenkins-pipeline:0.1"
        //     }
        // }
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
        // stage('Run tests') {
        //     steps {
        //         // Run tests (if any)
        //         // Example: sh 'pytest'
        //         sh 'pytest'
        //     }
        // }
        // stage('SonarQube scanner setup') {
        //     steps {
        //         // Download and install SonarQube Scanner
        //         sh 'wget https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-4.6.2.2472-linux.zip'
        //         sh 'unzip sonar-scanner-cli-4.6.2.2472-linux.zip'
        //         sh 'export PATH=$PATH:/path/to/sonar-scanner/bin' // Adjust the path to the SonarQube Scanner bin directory
        //     }
        // }
        // stage('SonarQube analysis1') {
        //     steps {
        //         // Run SonarQube scanner
        //         withSonarQubeEnv('SonarQube_Server') {
        //             sh 'sonar-scanner'
        //         }
        //     }
        // }
        // stage('SonarQube analysis') {
        //     environment {
        //         SONAR_URL = "http://4.154.42.1:9000"
        //     }
        //         steps {
        //             // Run SonarQube scanner
        //             sh 'pwd'
        //             echo 'Mayowa'
        //             sh 'cd sonar-scanner-4.6.2.2472-linux/bin/'
        //             withSonarQubeEnv('SonarQube_Server') {
        //                 echo 'Jude'
        //                 sh 'sonar-scanner'
        //             }
        //         }
        //     }

            // stage('SCM') {
            //     git 'https://github.com/foo/bar.git'
            // }
            // stage('SonarQube analysis') {
            //     def scannerHome = tool '<sonarqubeScannerInstallation>'; // must match the name of an actual scanner installation directory on your Jenkins build agent
            //     withSonarQubeEnv('<sonarqubeInstallation>') { // If you have configured more than one global server connection, you can specify its name as configured in Jenkins
            //     sh "${scannerHome}/bin/sonar-scanner"
            //     }
            // }
            // }
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
        stage('Build and deploy') {
            steps {
                // Build and deploy your Python web app
                // Example: sh 'python manage.py migrate && python manage.py runserver'
                sh 'python main.py migrate && python main.py runserver'
            }
        }
    }
}