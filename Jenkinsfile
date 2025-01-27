pipeline {
    agent any
    environment {
        TF_VAR_environment = "${params.ENVIRONMENT}" // Environment (dev/staging/prod)
        AWS_ACCESS_KEY_ID = credentials('aws-access-secret-key') // AWS credentials
        AWS_SECRET_ACCESS_KEY = credentials('aws-access-secret-key')
    }
    parameters {
        choice(name: 'ENVIRONMENT', choices: ['dev', 'staging', 'prod'], description: 'Select the environment to deploy')
    }
    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', url: 'https://github.com/gthri2k/cicdtf-github.git'
            }
        }
        stage('Terraform Init') {
            steps {
                dir("environments/${params.ENVIRONMENT}") {
                    sh 'terraform init -backend-config="../../backend.tf"'
                }
            }
        }
        stage('Terraform Validate') {
            steps {
                dir("environments/${params.ENVIRONMENT}") {
                    sh 'terraform validate'
                }
            }
        }
        stage('Terraform Plan') {
            steps {
                dir("environments/${params.ENVIRONMENT}") {
                    sh 'terraform plan -var-file=variables.tf'
                }
            }
        }
        stage('Terraform Apply') {
            when {
                expression { return params.ENVIRONMENT == 'dev' || params.ENVIRONMENT == 'staging' }
            }
            steps {
                dir("environments/${params.ENVIRONMENT}") {
                    sh 'terraform apply -var-file=variables.tf -auto-approve'
                }
            }
        }
        stage('Approval for Prod Apply') {
            when {
                expression { return params.ENVIRONMENT == 'prod' }
            }
            steps {
                script {
                    input message: "Approve production deployment?"
                }
                dir("environments/${params.ENVIRONMENT}") {
                    sh 'terraform apply -var-file=variables.tf -auto-approve'
                }
            }
        }
    }
    post {
        success {
            echo "Terraform deployment succeeded!"
        }
        failure {
            echo "Terraform deployment failed!"
        }
    }
}

options {
    abortOnError true
}

