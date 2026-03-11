pipeline {
    agent any
    tools{
        maven 'Maven3'

    }

    environment {
        PATH = "/opt/homebrew/bin:${env.PATH}"
        DOCKER_CMD = "/opt/homebrew/bin/docker"
        DOCKERHUB_CREDENTIALS_ID = 'docker-pat'
        DOCKER_IMAGE = 'leevivl/travelcalculator'
        DOCKER_TAG = 'latest'
    }

    stages {
        stage('Setup Maven') {
            steps {
                script {
                    def mvnHome = tool name: 'Maven3', type: 'maven'
                    env.PATH = "${mvnHome}/bin:${env.PATH}"
                }
            }
        }

        stage('Build') {
            steps {
                script {
                    if (isUnix()) {
                        sh 'mvn clean package -DskipTests'
                    } else {
                        bat 'mvn clean package -DskipTests'
                    }
                }
            }
        }

        stage('Test') {
            steps {
                script {
                    if (isUnix()) {
                        sh 'mvn test'
                    } else {
                        bat 'mvn test'
                    }
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    if (isUnix()) {
                        sh "docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} ."
                    } else {
                        bat "docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} ."
                    }
                }
            }
        }

        stage('Push Docker Image to Docker Hub') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', env.DOCKERHUB_CREDENTIALS_ID) {
                        docker.image("${DOCKER_IMAGE}:${DOCKER_TAG}").push()
                    }
                }
            }
        }
    }

    post {
        always {
            junit '**/target/surefire-reports/*.xml'
            jacoco execPattern: '**/target/jacoco.exec'
        }
    }
}

