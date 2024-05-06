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
                // sh "pip install -r requirements.txt"
                sh 'apt update'
                // sh 'echo $0'
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
        //     environment {
        //         SONAR_URL = "http://4.154.42.1:9000"
        //         SCANNER_HOME = tool 'sonar-scanner'
        //     }
            // steps {
            //     // Download and install SonarQube Scanner
            //     sh """ $SCANNER_HOME/bin/sonar-scanner -Dsonar.url=http://52.148.143.190:9000/ -Dsonar.login='sonar' -Dsonar.projectName=Soccer_Blog \
            //     """


            //     sh 'wget https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-4.6.2.2472-linux.zip'
            //     sh 'unzip sonar-scanner-cli-4.6.2.2472-linux.zip'
            //     sh 'export PATH=$PATH:/path/to/sonar-scanner/bin' // Adjust the path to the SonarQube Scanner bin directory
            // }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('SonarQube_Server') {
                    sh "sonar-scanner -Dsonar.login='sonarqube' -Dsonar.url=http://52.148.143.190:9000/"
                }
            }
        }
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