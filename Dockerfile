FROM openjdk:8

RUN mkdir -p /app/

COPY ./target/app.jar /app/

RUN chmod -R ag+w /app

RUN cd /app

RUN ls -al

CMD java -jar /app/app.jar
