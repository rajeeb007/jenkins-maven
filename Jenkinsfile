pipeline {
    agent any
    environment{
        DOCKERHUB_CREDENTIALS = credentials('docker_key')
        AWS_ACCOUNT_ID="170771122394"
        build_number = "${env.BUILD_ID}"
        AWS_DEFAULT_REGION="us-east-1"
        IMAGE_REPO_NAME="for-fun"
    }
    stages{
        stage('git checkout'){
            steps{
                git branch: 'main', credentialsId: 'git_key', url: 'https://github.com/rajeeb007/jenkins-maven.git'
            }
        }
        stage('code scanner') {
            steps {
                withSonarQubeEnv(credentialsId: 'sonar_key',installationName:'sonarqube') {
                    sh 'mvn sonar:sonar'
    
               }
            
            }
        }
        stage('docker image building') {

            steps {

                sh 'docker build -t rajeeb007/hello-world1:1.0 .'
               
            }

        }
        stage('Login') {

            steps {

                sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'

            }

        }
        stage('pushing to docker hub') {

            steps {

                sh 'docker push rajeeb007/hello-world1:${env.BUILD_ID}'

            }

        }
        stage('helmChart tag and  push to ECR') {
            steps {

                
                sh "sed -i 's|rajeeb007/hello-world1:1.0|rajeeb007/hello-world1:${env.BUILD_ID}|g' jenkins-maven/values.yaml"

            }
        }
        stage('helm package '){
            
            steps {
                sh "helm package jenkins-maven/"
            }
            
        }
        stage('login to aws and push to ecr'){
            steps {
                script {
                    withCredentials([aws(credentialsId: 'aws_key', accessKeyVariable: 'AWS_ACCESS_KEY_ID', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                        sh "aws ecr get-login-password | helm registry login  --username AWS -p \$(aws ecr get-login-password --region ap-south-1)  170771122394.dkr.ecr.ap-south-1.amazonaws.com"
                        sh "helm push jenkins-maven-0.1.0.tgz oci://170771122394.dkr.ecr.ap-south-1.amazonaws.com"
                    }
                }
            }
        }    

    }
}