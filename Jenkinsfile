def actuelBranch(branch) {
    script {
        echo "La branche actuelle est : ${branch}" 
    }
}

def buildImage(branch) {
            script {
                sh "docker build --build-arg BUILD_NUMBER=${BUILD_NUMBER} -t ${github_username}/${image_name}:build_${BUILD_NUMBER} -t ${github_username}/${image_name} --no-cache ."
            }
        }


pipeline {
    agent any
    environment {
        //All your env required
        DOCKERHUB_CREDENTIALS = 'Token-dockerhub'
        //github
        github_username = "faniry123"
        //Slack_tokens
        slack_tokens = 'token_slacks'
        //Slack_channel
        slackSend_channel = '#slacknotification'
        //teamDomain_Slack
        slack_domain = 'fanirysiege'
        //front or Back or API
        tiers = 'front'
        //Client Name
        client = 'test'
        //project
        project = 'sonar'
        // Language with env
        language = 'node'
        // Image name
        image_name = "${tiers}_${client}_${project}_${language}_${env.BRANCH_NAME}"
        //
        DOCKER_TAG_NAME = "${image_name}:${BUILD_NUMBER}"
    }

    
    stages {
        stage('Commiter') {
            steps {
                script {
                    def COMMITTER_EMAIL
                    if (isUnix()) {
                        COMMITTER_EMAIL = sh(script: "git --no-pager show -s --format='%ae'", returnStdout: true).trim()
                    } else {
                        COMMITTER_EMAIL = bat(script: "git --no-pager show -s --format=%%ae", returnStdout: true).split('\r\n')[2].trim()
                    }
                    slackSend channel: "${slackSend_channel}", failOnError: true, message: "(${JOB_NAME}) ${COMMITTER_EMAIL} a initilisé le build numéro ${BUILD_DISPLAY_NAME}", teamDomain: "${slack_domain}", tokenCredentialId: "${slack_tokens}", color: 'good', iconEmoji: ':thumbsup:'
                }
            }
        }
        stage('Login to Docker Hub') {
            steps {
                script {
                    // Log in to Docker Hub using credentials
                    withCredentials([usernamePassword(credentialsId: "${DOCKERHUB_CREDENTIALS}", usernameVariable: 'DOCKERHUB_CREDENTIALS_USR', passwordVariable: 'DOCKERHUB_CREDENTIALS_PSW')]) {
                        sh "echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin"
                    }
                }
            }
            post('Login to Docker Hub') {
                success {
                    slackSend channel: "${slackSend_channel}", message: "Login to DockerHub  succeeded", teamDomain: "${slack_domain}", tokenCredentialId: "${slack_tokens}", color: 'good', iconEmoji: ':thumbsup:'
                }
                failure {
                    slackSend channel: "${slackSend_channel}", message: "Login to DockerHub  failed", teamDomain: "${slack_domain}", tokenCredentialId: "${slack_tokens}", color: 'danger', iconEmoji: ':thumbsdown:'
                }
            }
        }

        stage('SonarQube Analysis') {
            steps {
                script {
                    def scannerHome = tool 'SonarScanner'
                    withSonarQubeEnv('Sonar-server') {
                        sh "${scannerHome}/bin/sonar-scanner -Dsonar.projectKey=test"
                    }
                }
            }
        }
        
        
    }
    post {
        always {
            // Log out of Docker Hub
            sh 'docker logout'
            sh "docker  rmi -f ${github_username}/${image_name}:build_${BUILD_NUMBER}"
            sh 'docker image prune -f'
            
        }
    }
}
