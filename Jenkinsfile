pipeline{
    agent any

    environment {
        AWS_DEFAULT_REGION = 'us-east-1'
        AWS_ECR = '533267431526.dkr.ecr.us-east-1.amazonaws.com'
        IMAGE_NAME = 'dotnet'
    }
    stages{
        stage("Image build"){
            steps{
                sh '''
                docker image build -t 'my-aws-cli' -f AWS/Dockerfile .
                '''
            }
           
            }

        stage("Build"){
            agent{
                docker{
                    image 'my-aws-cli'
                    reuseNode true
                    args "-u root -v /var/run/docker.sock:/var/run/docker.sock"
                }
            }

            steps{
                sh '''
                    docker image build -t dotnet .
                '''
            }
        }
        
        stage("ECS_TD"){
            agent {
                docker{
                    image 'my-aws-cli'
                    reuseNode true
                }
            }

            steps{
            

            withCredentials([usernamePassword(credentialsId: 'AWS', passwordVariable: 'AWS_SECRET_ACCESS_KEY', usernameVariable: 'AWS_ACCESS_KEY_ID')]) {
                    
                    sh '''
                    aws ecs register-task-definition --cli-input-json file://AWS/task-defination.json > task-definition.json

                    '''

              
               
            }
            }
        }
    }
}
   
