pipeline{

        agent any

        stages{

              stage('Quality Gate Status Check'){
              agent {
                       docker {
                       label 'master'
                       image 'maven'
                       args '-v $HOME/.m2:/root/.m2'
                      }
                    }
                  steps{
                      script{
			      withSonarQubeEnv('sonarserver') {
			      sh "mvn sonar:sonar"
                       	     	}
			      timeout(time: 1, unit: 'HOURS') {
			      def qg = waitForQualityGate()
				      if (qg.status != 'OK') {
					   error "Pipeline aborted due to quality gate failure: ${qg.status}"
				      }
                    		}
		    	    sh "mvn clean install"

                 	}
               	 }
              }
              stage('build'){
              		      steps {
              			      script{
              			    String Docker_tag = sh(script: "git log -1 --pretty=%h", returnStdout: true).trim()
              			    sh 'echo "Docker_tag==" $Docker_tag'

                            sh 'docker build . -t samba1236/sonarqube:$Docker_tag'

                            withCredentials([string(credentialsId: 'docker pasw', variable: 'docker-paswrd')]) {

                            sh 'docker login -u samba1236 -p $docker-paswrd'
                            sh 'docker push samba1236/sonarqube:$Docker_tag'

                           }

              	         }
              	       }
                     }

                   }
              }
