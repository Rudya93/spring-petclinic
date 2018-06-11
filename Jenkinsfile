pipeline {
        agent none 
    stages { 
          stage ('create inst') { agent any
              steps {
                withCredentials([[
            $class: 'AmazonWebServicesCredentialsBinding',
            credentialsId: 'adc00aa9-73ed-456f-bcd1-1a8cfdaba58b',
            accessKeyVariable: 'AWS_ACCESS_KEY_ID',
            secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
        ]]) 
                      {
            sh ('> hosts ')            
            sh ('AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} AWS_DEFAULT_REGION=us-west-2')
            //sh ('AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} AWS_DEFAULT_REGION=us-west-2 ${AWS_BIN}')
	    //sh('/home/ubuntu/print.sh')
                        withAWS(region:'us-west-2'){
                                sh('python3.5 start.py')} 
                        //echo 'Waiting deployment to complete start inst'
                        //sleep 200 // seconds
			}
               }
           }
            stage('Checkout and build') {agent { docker {image 'maven'}}
            steps {
                checkout scm
                sh 'mvn package'
               }
            }
       
            stage('docker_build') {agent any
            steps { 
                sh 'docker build -t grebec/app:${BUILD_NUMBER} .'
                sh 'docker images'
                sh 'docker tag grebec/app:${BUILD_NUMBER} grebec/app:latest'    
                withDockerRegistry([ credentialsId: "ad5a78f7-c1af-4b37-a58f-ae20d9244457", url: ""]) 
                { sh 'docker push grebec/app:latest'}
            }
            }          
                stage ('Start_APP') { agent any       
             steps {      
                ansiblePlaybook(
                playbook: 'app.yml',
                inventory: 'hosts',
                installation: 'Ans1',
                credentialsId: 'sshu',
                disableHostKeyChecking: true) }
            } 
   }
}     

