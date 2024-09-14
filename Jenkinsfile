pipeline {
    agent any

    parameters {
        booleanParam(name: 'autoApprove', defaultValue: false, description: 'Automatically run apply after generating plan')
        choice(name: 'action', choices: ['apply', 'destroy'], description: 'Select the action to perform')
    }

    environment {
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    }

    
    stages {
        stage('checkout') {
            steps {
                git branch: 'main', url:'https://github.com/trueanbarasan/aws_terraform.git'
            }
        }

        stage('plan') {
            steps {
                sh 'cd terraform; terraform init'
                sh 'cd terraform; terraform plan -out tfplan'
                sh 'cd terraform; terraform show -no-color tfplan > tfplan.txt'
            }
        }

        stage('Approval') {
            steps {
                script {
                    if (params.action == 'apply') {
                        if (!params.autoApprove) {
                            def plan = readFile 'terraform/tfplan.txt'
                            input message: "Do you want to proceed to apply?",
                            parameters: [text(name: 'Plan', description: 'Please review the plan', defaultValue: plan)]
                        }

                        sh 'cd terraform; terraform ${action} -input=false tfplan'
                    } else if (params.action == 'destroy') {
                        sh 'cd terraform; terraform ${action} --auto-approve'
                    } else {
                        error "Invalid action selected"
                    }
                }
            }
        }
    }
}


