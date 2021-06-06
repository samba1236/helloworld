pipeline{
    agent any
    stages{
      stage('Quality Gate Status Check'){
      steps {
        script {
          withSonarQubeEnv('sonarserver') {
            //def scannerHome = tool 'SonarScanner';
            //sh "${scannerHome}/bin/sonar-scanner"
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

    stage('build') {
      steps {
        script {
          def dockerHome = tool 'docker'
          env.PATH = "${dockerHome}/bin:${env.PATH}"
          // Login to the Artifactory Docker registry
          // The Docker resource value is docker.repo1.uhc.com

           String containerId = sh(script: "sudo docker build -f Dockerfile ./ | tail -1", returnStdout: true).split(' ')[2].trim()
            echo "Container Id: ${containerId}"
            String dockerPushResource = "samba1236/sonarqube:kubernetes"

            // Make a tag and push
            sh "sudo docker login -u samba1236 -p Samba@1236 https://index.docker.io"
            withDockerRegistry(credentialsId: 'docker', toolName: 'docker', url: 'https://index.docker.io/v1/') {
                sh "sudo docker tag ${containerId} ${dockerPushResource}"
                sh "sudo docker push ${dockerPushResource}"
            }


          }

        }
      }
  }
}
