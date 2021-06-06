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
          sh "mvn clean install"

        }
      }
    }

    stage('build') {
      steps {
        script {
          String Docker_tag = sh(script: "git log -1 --pretty=%h", returnStdout: true).trim()
          sh 'echo "Docker_tag==" $Docker_tag'

          sh 'docker build . -t samba1236/sonarqube:$Docker_tag'

          withCredentials([string(credentialsId: 'docker_password', variable: 'docker_password')]) {
            sh 'docker login -u samba1236 -p $docker_password'
            sh 'docker push samba1236/sonarqube:$Docker_tag'
          }

        }
      }
    }

  }
}
