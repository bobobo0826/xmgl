echo begin....
title employee
set MAVEN_OPTS=-Dmaven.test.skip=true -Dfile.encoding=UTF-8
call mvn clean 
call mvn spring-boot:run
pause