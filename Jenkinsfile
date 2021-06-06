pipeline {
    agent any
       stages {
        stage('Install') {
            steps {
                echo 'Installation...'
            }
        }
        stage('Test') {
            steps {
                echo 'Testing...'

            }
        }
        stage('Sonarqube') {
            environment {

                 scannerHome = tool 'sonar_scanner'
            }

            steps {
                echo 'Scanning....'
                withSonarQubeEnv('Sonarqube') {
                sh "${scannerHome}/bin/sonar-scanner"
             }
                timeout(time: 10, unit: 'MINUTES') {
                //waitForQualityGate abortPipeline: true
                    def qg = waitForQualityGate()
				      if (qg.status != 'OK') {
					   error "Pipeline aborted due to quality gate failure: ${qg.status}"
            }
        }
    }
    stage('Build') {
            steps {
                echo 'Production build...'
            }
        }
    }
}
