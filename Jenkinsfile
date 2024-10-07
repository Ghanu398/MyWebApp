pipeline{
    agent any
    stages{
        stage("Image build"){
            steps{
                sh '''
                docker image build -t 'my-aws-cli' -f AWS/Dockerfile .
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
   
