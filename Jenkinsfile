pipeline{
    agent any

    environment {
        AWS_DEFAULT_REGION = 'us-east-1'
        AWS_ECR = '533267431526.dkr.ecr.us-east-1.amazonaws.com'
        IMAGE_NAME = 'dotnet'
        VERSION = '1.0'
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
                docker image build -t $AWS_ECR/$IMAGE_NAME:$VERSION .
                '''
            
            withCredentials([usernamePassword(credentialsId: 'AWS', passwordVariable: 'AWS_SECRET_ACCESS_KEY', usernameVariable: 'AWS_ACCESS_KEY_ID')]) {
                    
                    sh '''
                    aws ecr get-login-password | docker login --username AWS --password-stdin $AWS_ECR
                    docker push $AWS_ECR/$IMAGE_NAME:$VERSION

                    '''
            }
        }
        }

        
        stage("ECS_Deploy"){
            agent {
                docker{
                    image 'my-aws-cli'
                    reuseNode true
                }
            }

            steps{
            

            withCredentials([usernamePassword(credentialsId: 'AWS', passwordVariable: 'AWS_SECRET_ACCESS_KEY', usernameVariable: 'AWS_ACCESS_KEY_ID')]) {
                    
                    sh '''
                    sed -i "s/IMAGE_VERSION/$VERSION/g" AWS/task-defination.json
                    aws ecs register-task-definition --cli-input-json file://AWS/task-defination.json > output.json
                   TD_VERSION=$(jq -r '.taskDefinition.taskDefinitionArn' output.json | awk -F ':' '{print $NF}' | awk -F '"' '{print $1}')
                   echo $TD_VERSION
                    aws ecs update-service --cluster dotnet-cluster --service learn-docker --task-definition test-task-defination:$TD_VERSION
                    aws ecs wait services-stable --cluster dotnet-cluster --services learn-docker
                    '''

              
               
            }
            }
        }
    }
}
   
