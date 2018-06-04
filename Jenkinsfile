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
        ]]) {
            sh ('AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} AWS_DEFAULT_REGION=us-west-2')
            //sh ('AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} AWS_DEFAULT_REGION=us-west-2 ${AWS_BIN}')
	    //sh('/home/ubuntu/print.sh')
                        withAWS(region:'us-west-2'){
                                sh('python3 start.py')} 
                        echo 'Waiting deployment to complete start inst'
                        //sleep 200 // seconds
			}
                   
        }
    }
            stage('Get from GIT') {
                agent {
      
        docker {
            image 'maven'
        }
    }
            steps {
                checkout scm
            }
        }
        stage('Build') {
                 agent {
   
        docker {
            image 'maven'
        }
    }
            steps {
               sh 'mvn package'
              // archiveArtifacts 'target/*.jar'
            }
 
        }
     
        
            stage('docker_build') {
                  agent any
            steps { 
                sh 'docker build -t grebec/app:${BUILD_NUMBER} .'
                sh 'docker images'
                withDockerRegistry([ credentialsId: "ad5a78f7-c1af-4b37-a58f-ae20d9244457", url: ""]) {
                 sh 'docker push grebec/app:${BUILD_NUMBER}'
                    }
            }
            }           
   
   }
}     

