pipeline{
    agent any
    stages{
      stage('Quality Gate Status Check'){
      steps {
        script {
          withSonarQubeEnv('sonarserver') {
            def scannerHome = tool 'SonarScanner';
            sh "${scannerHome}/bin/sonar-scanner"
          }
          timeout(time: 1, unit: 'HOURS') {
            def qg = waitForQualityGate()
            if (qg.status != 'OK') {
              error "Pipeline aborted due to quality gate failure: ${qg.status}"
            }
          }
        }
      }
    }

    stage('build') {
      steps {
        script {
          def dockerHome = tool 'docker'
          env.PATH = "${dockerHome}/bin:${env.PATH}"
           String containerId = sh(script: "docker build -f Dockerfile ./ | tail -1", returnStdout: true).split(' ')[2].trim()
            echo "Container Id: ${containerId}"
            String dockerPushResource = "samba1236/sonarqube:kubernetes"

            // Make a tag and push
            sh "docker tag ${containerId} ${dockerPushResource}"
            sh "docker push ${dockerPushResource}"
          }

        }
      }
  }
}
