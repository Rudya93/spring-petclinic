pipeline {
        agent none 
    stages {
        stage('Get from GIT') {
                agent {
        //указываем, что выполнять задачу хотим внутри 
        // Docker-контейнера на базе указанного образа:
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
        //указываем, что выполнять задачу хотим внутри 
        // Docker-контейнера на базе указанного образа:
        docker {
            image 'maven'
        }
    }
            steps {
               sh 'mvn package'
              // archiveArtifacts 'target/*.jar'
            }
 
        }
           /* stage('Copy Archive') {
         steps {
             script {
                 step ([$class: 'CopyArtifact',
                        projectName: 'petclinic',
                        filter: "target/*.jar",
                   target: '/home/ubuntu/app']);
             }
        
        }
    }
   */
   stage('LS') {
                      agent {
        //указываем, что выполнять задачу хотим внутри 
        // Docker-контейнера на базе указанного образа:
        docker {
            image 'maven'
        }
    }
            steps {
                sh 'cd /var/lib/jenkins/workspace/petclinic/target/ && ls -la'
               
                }
 
        }         
   
          stage('LSWORK') {
                  agent any
            steps { 
                sh 'cd /var/lib/jenkins/workspace/petclinic/target/ && ls -la'
         }
   }
   }
}     
/*
#_ Этап сборки нового Docker-образа и его загрузки с систему Artifactory:
node {
    stage('Собираем образ') {
        docker.withRegistry("https://repo.artifactory.bank", "LoginToArtifactory") {
            def dkrImg = docker.build("repo.artifactory.bank/dev-backend:${env.BUILD_ID}")
            dkrImg.push()
            dkrImg.push('latest')
        }
	}
    stage('Заливаем его в Artifactory') {
        docker.withRegistry("https://repo.artifactory.bank", "LoginToArtifactory") {
            sh "docker service update --image repo.artifactory.bank/dev-backend:${env.BUILD_ID} SMB_dev-backend"
        }
    }
}
*/
