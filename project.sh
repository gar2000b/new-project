#!/usr/bin/env bash

project_name=$1
project_description=$2

if [ -z "$project_name" ]; then
	echo Please enter project name:
	read project_name
fi
echo project name is: $project_name

if [ -z "$project_description" ]; then
	echo "Please enter project description"
	read project_description
fi
echo project description is: $project_description

curl -u "gar2000b:{password-here}" -XPOST https://api.github.com/user/repos -d "{\"name\":\"$project_name\",\"description\":\"$project_description\"}"

mkdir $project_name
cd $project_name
printf "# $project_name\n$project_description" > README.md
printf "# Compiled class file\n*.class\n\n# Log file\n*.log\n\n# BlueJ files\n*.ctxt\n\n# Mobile Tools for Java (J2ME)\n.mtj.tmp/\n\n# Package Files #\n*.jar\n*.war\n*.ear\n*.zip\n*.tar.gz\n*.rar\n\n# virtual machine crash logs, see http://www.java.com/en/download/help/error_hotspot.xml\nhs_err_pid*\n/target/\n\n.classpath\n.project\n.settings/\n" > .gitignore

mkdir -p src/main/java/com/onlineinteract
mkdir -p src/test/java/com/onlineinteract
touch src/main/java/com/onlineinteract/Main.java
touch src/test/java/com/onlineinteract/MainTest.java

printf "<project xmlns=\"http://maven.apache.org/POM/4.0.0\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"\n	xsi:schemaLocation=\"http://maven.apache.org/POM/4.0.0 http://maven.apache.org/maven-v4_0_0.xsd\">\n	<modelVersion>4.0.0</modelVersion>\n	<groupId>com.onlineinteract</groupId>\n	<artifactId>$project_name</artifactId>\n	<packaging>jar</packaging>\n	<version>1.0-SNAPSHOT</version>\n	<name>$project_name</name>\n	<url>http://maven.apache.org</url>\n\n	<build>\n		<plugins>\n			<plugin>\n				<groupId>org.apache.maven.plugins</groupId>\n				<artifactId>maven-jar-plugin</artifactId>\n				<version>2.4</version>\n				<configuration>\n					<archive>\n						<manifest>\n							<addDefaultImplementationEntries>true</addDefaultImplementationEntries>\n						</manifest>\n					</archive>\n				</configuration>\n			</plugin>\n			<plugin>\n				<groupId>org.apache.maven.plugins</groupId>\n				<artifactId>maven-compiler-plugin</artifactId>\n				<version>3.1</version>\n				<!-- compile for Java 1.7 -->\n				<configuration>\n					<source>1.8</source>\n					<target>1.8</target>\n					<encoding>UTF-8</encoding>\n				</configuration>\n			</plugin>\n			<plugin>\n				<groupId>org.apache.maven.plugins</groupId>\n				<artifactId>maven-shade-plugin</artifactId>\n				<version>1.6</version>\n				<configuration>\n					<createDependencyReducedPom>true</createDependencyReducedPom>\n					<filters>\n						<filter>\n							<artifact>*:*</artifact>\n							<excludes>\n								<exclude>META-INF/*.SF</exclude>\n								<exclude>META-INF/*.DSA</exclude>\n								<exclude>META-INF/*.RSA</exclude>\n							</excludes>\n						</filter>\n					</filters>\n				</configuration>\n			</plugin>\n			<!-- Maven Assembly Plugin -->\n			<plugin>\n				<groupId>org.apache.maven.plugins</groupId>\n				<artifactId>maven-assembly-plugin</artifactId>\n				<version>2.4.1</version>\n				<configuration>\n					<!-- get all project dependencies -->\n					<descriptorRefs>\n						<descriptorRef>jar-with-dependencies</descriptorRef>\n					</descriptorRefs>\n					<!-- MainClass in mainfest make a executable jar -->\n					<archive>\n						<manifest>\n							<mainClass>com.onlineinteract.Main</mainClass>\n						</manifest>\n					</archive>\n\n				</configuration>\n				<executions>\n					<execution>\n						<id>make-assembly</id>\n						<!-- bind to the packaging phase -->\n						<phase>package</phase>\n						<goals>\n							<goal>single</goal>\n						</goals>\n					</execution>\n				</executions>\n			</plugin>\n		</plugins>\n	</build>\n\n\n	<dependencies>\n		<dependency>\n			<groupId>junit</groupId>\n			<artifactId>junit</artifactId>\n			<version>4.10</version>\n			<scope>test</scope>\n		</dependency>\n		<dependency>\n			<groupId>org.mockito</groupId>\n			<artifactId>mockito-core</artifactId>\n			<version>2.8.47</version>\n		</dependency>\n	</dependencies>\n</project>\n" > pom.xml

git init
git add .
git commit -m "first commit"
git remote add origin https://github.com/gar2000b/$project_name.git
git push -u origin master
