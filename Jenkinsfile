pipeline{
    agent{
        label "node"
    }
    stages{
        stage("Image build"){
            steps{
                sh '''
                docker image build -t 'my-aws-cli' -f AWS/Dockerfile .
                '''
            }
           
            }
        }
}
   
