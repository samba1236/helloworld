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
          // The Docker resource value is docker.repo1.uhc.com
           String containerId = sh(script: "sudo docker build -f Dockerfile ./ | tail -1", returnStdout: true).split(' ')[2].trim()
            echo "Container Id: ${containerId}"
            String dockerPushResource = "samba1236/sonarqube:kubernetes"

            // Make a tag and push
            sh "sudo docker tag ${containerId} ${dockerPushResource}"
            // Login to the Artifactory Docker registry
             sh "sudo docker login -u samba1236 -p Samba@1236 docker.io"
             sh "sudo docker push ${dockerPushResource}"
            }
        }
      }
      stage('deploy') {
            steps {
              script {
                  // Login to the azure aks cluster
                  sh "az login --service-principal --username ff6f62b4-d57b-42de-b0d0-1a0d6e34ac94 --password LlaeZNoEJ65st1_lIT.-YKTJzo8oyW8456 --tenant 6184a51f-7158-48ba-adee-51e5f34edd5c"
                  //sh "az login -u samba.akepati91@gmail.com -p Samba@1236 --allow-no-subscriptions"
                  sh "az aks get-credentials --resource-group AKSRG --name AKScluster01"
                  //sh "kubectl delete -f helloworld.yaml --namespace=production"
                  // deploying latest image
                   sh "kubectl apply -f helloworld.yaml --namespace=production"
                  }
              }
            }

  }
}
