### Domains

```
org.apache.maven.archetypes:maven-archetype-quickstart

package 
qt3.music.domains
```

### pom.xml

```
<maven.compiler.source>17</maven.compiler.source>
<maven.compiler.target>17</maven.compiler.target>
    
    <properties>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
        <maven.compiler.source>17</maven.compiler.source>
        <maven.compiler.target>17</maven.compiler.target>
        <revision-bom>1.0.3</revision-bom>
    </properties>

    <dependencyManagement>
        <dependencies>
            <dependency>
                <groupId>qt3.music</groupId>
                <artifactId>bom</artifactId>
                <version>${revision-bom}</version>
                <type>pom</type>
                <scope>import</scope>
            </dependency>
        </dependencies>
    </dependencyManagement>

    <repositories>
        <repository>
            <id>gitlab-qt3-music</id>
            <url>https://gitlab.com/api/v4/groups/58460516/-/packages/maven</url>
        </repository>
    </repositories>
    <distributionManagement>
        <repository>
            <id>gitlab-qt3-music</id>
            <!--suppress UnresolvedMavenProperty -->
            <url>${CI_API_V4_URL}/projects/${CI_PROJECT_ID}/packages/maven</url>
        </repository>
    </distributionManagement>
  
    <dependency>
      <groupId>org.springframework.data</groupId>
      <artifactId>spring-data-mongodb</artifactId>
      <version>3.4.5</version>
    </dependency>
    <dependency>
      <groupId>org.projectlombok</groupId>
      <artifactId>lombok</artifactId>
      <version>1.18.24</version>
    </dependency>
    
```

### ci_settings.xml

```
cat <<EOF > ci_settings.xml
<settings xmlns="http://maven.apache.org/SETTINGS/1.1.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.1.0 http://maven.apache.org/xsd/settings-1.1.0.xsd">
    <servers>
        <server>
            <id>gitlab-qt3-music</id>
            <configuration>
                <httpHeaders>
                    <property>
                        <name>Job-Token</name>
                        <value>"${CI_JOB_TOKEN}"</value>
                    </property>
                </httpHeaders>
            </configuration>
        </server>
    </servers>
</settings>
EOF
```

### .gitlab-ci.yml

```
cat <<EOF > .gitlab-ci.yml
deploy:
  image: maven:3-openjdk-17
  script:
    - 'mvn deploy -s ci_settings.xml'
  only:
    - main
EOF
```

### git
```
git init --initial-branch=main
git remote add origin git@gitlab.com:chainqt3/qt3-music/domains/<...>-domain.git

cat <<EOF > .gitignore
HELP.md
target/
!.mvn/wrapper/maven-wrapper.jar
!**/src/main/**/target/
!**/src/test/**/target/

### STS ###
.apt_generated
.classpath
.factorypath
.project
.settings
.springBeans
.sts4-cache

### IntelliJ IDEA ###
.idea
*.iws
*.iml
*.ipr

### NetBeans ###
/nbproject/private/
/nbbuild/
/dist/
/nbdist/
/.nb-gradle/
build/
!**/src/main/**/build/
!**/src/test/**/build/

### VS Code ###
.vscode/
EOF

git add .
git commit -m "Initial commit"
git push -u origin main
```