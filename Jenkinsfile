pipeline {
  agent any
  stages {
    stage('Sonar helloworld  analysis') {
      steps {
          withSonarQubeEnv('SonarCloud') {
            script {
              def scannerHome = tool 'SonarScanner';
              sh "${scannerHome}/bin/sonar-scanner"
            }
          }
      }
    }
    stage("SonarQube scanner") {
      steps {
          timeout(time: 5, unit: 'MINUTES') {
            script {
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
