# helloworld



1) docker run -d --name sonarqube -p 9000:9000 sonarqube:7.5-community

2) docker run --name jenkins -p 8080:8080 -p 50000:50000 \
-v /var/run/docker.sock:/var/run/docker.sock \
-v $(which docker):/usr/local/bin/docker \
-v /usr/local/bin/jenkins:/usr/local/bin/jenkins \
jenkins/jenkins
