pipeline {
    parameters {
        booleanParam(name: 'autoApprove', defaultValue: false, description: 'Automatically run apply after generating plan?')
    }
    environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    }
    agent any
    stages {
        stage('checkout') {
            steps {
                script {
                    dir("terraform") {
                        git "https://github.com/gthri2k/cicdtf-github.git"
                    }
                }
            }
        }
        stage('Plan') {
            steps {
                retry(3) { // Retry up to 3 times in case of a lock issue
                    bat '''
                    cd terraform
                    terraform init
                    terraform plan -out tfplan || exit 1
                    terraform show -no-color tfplan > tfplan.txt
                    '''
                }
            }
        }
        stage('Approval') {
            when {
                not {
                    equals expected: true, actual: params.autoApprove
                }
            }
            steps {
                script {
                    def plan = readFile 'terraform/tfplan.txt'
                    input message: "Do you want to apply the plan?",
                    parameters: [text(name: 'Plan', description: 'Please review the plan', defaultValue: plan)]
                }
            }
        }
        stage('Apply') {
            steps {
                bat '''
                cd terraform
                terraform apply -input=false tfplan
                '''
            }
        }
    }
}

