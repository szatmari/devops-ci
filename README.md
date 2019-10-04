# DevOps - CI

## Preparation

1. Start the devops-ci VM in the BME VIK Cloud (Smallville)
2. Create new GitHub repository for the demo SpringBoot RESTFul application
```bash
git clone https://github.com/szatmari/devops-ci.git
git remote set-url myorigin YOUR_GIT_URL
git pull myorigin master --allow-unrelated-histories
git push -u myorigin master
```

## Gradle

1. Run the SpringBoot REST App
```bash
./gradlew bootRun
```
2. Test the application:
```bash
curl http://localhost:8088/greeting?name=Zoltan
```
3. Add dependency (src/main/java/hello/Greeting.java)
```java
import org.joda.time.LocalTime;
...
    public String getContent() {
        LocalTime currentTime = new LocalTime();
        return content +" " + currentTime;
    }
```
4. Test the application again
```bash
curl http://localhost:8088/greeting?name=Zoltan
```
5. Map the port 8088 to the public interface in the BME Cloud Manager
6. Test the application on the generated URL using a browser

## Jenkins

1. Map the port 8080 to the public interface in the BME Cloud Manager
2. Visit the generated endpoint 
3. Create a new freestyle job
   - Set your GitHub link to your project
   - Configure SCM: git
   - Add your repository URL
   - Set the "Branches to build" property to "*/master"
   - Add "Invoke gradle script" to the Build section
   - Set the gradle task: "build"
   - Add a Post Build action: Publish Junit test results
   - Set the path of the "Test report XMLs" to "build/test-results/test/*.xml"
4. Set build trigger: Poll SCM "* * * * *"
5. Add a new build task to do deployment: "Execute shell"
```bash
docker-compose up -d --force-recreate
```

## Travis + Heroku

1. Visit and login to https://travis-ci.org/ using your GitHub account
2. Open your profile page and connect your GitHub Rpository (enable) to Travis https://travis-ci.org/account/repositories
3. Add, commit and push the travis.yml file to your repository
```yml
language: java
jdk: openjdk8
```
4. Add Procfile for Heroku deployment
```
web java -Dserver.port=$PORT -jar target/gs-rest-service-0.1.0.jar
```
5. Add deploy steps to the .travis,yml
```yml
language: java
jdk: openjdk8

deploy:
  provider: heroku
  api_key: paceholder
  app: devops-ci
```
6. Generate secure API key for Heroku deployment for this repository
```bash
travis encrypt paste-your-api-key-here --add deploy.api_key --org
```
7. Check the app on your Heroku URL
