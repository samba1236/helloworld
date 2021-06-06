pipeline {
  agent any
  stages {
    stage('Sonar helloworld  analysis') {
      steps {
       script {
          withSonarQubeEnv('sonarserver') {
              def scannerHome = tool 'SonarScanner';
              sh "${scannerHome}/bin/sonar-scanner"
               }
              timeout(time: 5, unit: 'MINUTES') {
              def qg = waitForQualityGate() // Reuse taskId previously collected by withSonarQubeEnv
              if (qg.status != 'OK') {
                echo "Quality gate failed: ${qg.status}, proceeding anyway"
              }
            }
          }
      }
    }
  }
}

