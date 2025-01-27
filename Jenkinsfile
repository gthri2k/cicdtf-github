pipeline {
    agent any
    environment {
        TF_VAR_environment = "${params.ENVIRONMENT}" // Environment (dev/staging/prod)
    }
    parameters {
        choice(name: 'ENVIRONMENT', choices: ['dev', 'staging', 'prod'], description: 'Select the environment to deploy')
    }
    stages {
        stage('Clone Repository') {
            steps {
                checkout([
                    $class: 'GitSCM',
                    branches: [[name: '*/main']],
                    userRemoteConfigs: [[
                        url: 'https://github.com/gthri2k/cicdtf-github.git',
                        credentialsId: 'github-token' // Replace with your GitHub credentials ID
                    ]]
                ])
            }
        }
        stage('Terraform Init') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding', 
                    credentialsId: 'aws-access-secret-key' // Replace with your AWS credentials ID
                ]]) {
                    dir("environments/${params.ENVIRONMENT}") {
                        bat 'C:\\Binaries\\terraform.exe init -backend-config="../../backend.tf"'
                    }
                }
            }
        }
        stage('Terraform Validate') {
            steps {
                dir("environments/${params.ENVIRONMENT}") {
                    bat 'C:\\Binaries\\terraform.exe validate'
                }
            }
        }
        stage('Terraform Plan') {
            steps {
                dir("environments/${params.ENVIRONMENT}") {
                    bat """
                    C:\\Binaries\\terraform.exe plan \
                    -var-file=${params.ENVIRONMENT}.tfvars
                    """
                }
            }
        }
        stage('Terraform Apply') {
            when {
                expression { params.ENVIRONMENT == 'dev' || params.ENVIRONMENT == 'staging' }
            }
            steps {
                dir("environments/${params.ENVIRONMENT}") {
                    bat """
                    C:\\Binaries\\terraform.exe apply \
                    -var-file=${params.ENVIRONMENT}.tfvars \
                    -auto-approve
                    """
                }
            }
        }
        stage('Approval for Prod Apply') {
            when {
                expression { params.ENVIRONMENT == 'prod' }
            }
            steps {
                script {
                    timeout(time: 10, unit: 'MINUTES') {
                        input message: "Approve deployment to production?"
                    }
                }
                dir("environments/${params.ENVIRONMENT}") {
                    bat """
                    C:\\Binaries\\terraform.exe apply \
                    -var-file=${params.ENVIRONMENT}.tfvars \
                    -auto-approve
                    """
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
