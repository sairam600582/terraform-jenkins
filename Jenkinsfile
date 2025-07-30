pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/sairam600582/terraform-jenkins.git'
            }
        }
        stage('Init') {
            steps {
                sh 'terraform init'
            }
        }
        stage('Plan') {
            steps {
                sh 'terraform plan'
            }
        }
        stage('Apply') {
            steps {
                input 'Approve to apply?'
                sh 'terraform apply -auto-approve'
            }
        }
    }
}
