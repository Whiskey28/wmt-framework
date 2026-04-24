"C:\Program Files\Java\jdk-17.0.12\bin\java.exe" -Dmaven.multiModuleProjectDirectory=E:\projects\github\1.Whiskey28\wmt-framework -Djansi.passthrough=true "-Dmaven.home=E:\kfsoftware\IntelliJ IDEA 2024.2\plugins\maven\lib\maven3" "-Dclassworlds.conf=E:\kfsoftware\IntelliJ IDEA 2024.2\plugins\maven\lib\maven3\bin\m2.conf" "-Dmaven.ext.class.path=E:\kfsoftware\IntelliJ IDEA 2024.2\plugins\maven\lib\maven-event-listener.jar" "-javaagent:E:\kfsoftware\IntelliJ IDEA 2024.2\lib\idea_rt.jar=61021:E:\kfsoftware\IntelliJ IDEA 2024.2\bin" -Dfile.encoding=UTF-8 -classpath "E:\kfsoftware\IntelliJ IDEA 2024.2\plugins\maven\lib\maven3\boot\plexus-classworlds-2.8.0.jar;E:\kfsoftware\IntelliJ IDEA 2024.2\plugins\maven\lib\maven3\boot\plexus-classworlds.license" org.codehaus.classworlds.Launcher -Didea.version=2024.2 -s E:\kfsoftware\apache-maven-3.8.3\conf\settings-17.xml -DskipTests=true -pl wmt-framework-jdk17/wmt-spring-boot-starter-web,wmt-framework-jdk17/wmt-spring-boot-starter-websocket,wmt-framework-jdk17/wmt-spring-boot-starter-mybatis -am dependency:tree "\"-Dincludes=org.springframework.boot:spring-boot-starter-tomcat,org.apache.tomcat.embed:*\""
[INFO] Scanning for projects...
[INFO] ------------------------------------------------------------------------
[INFO] Reactor Build Order:
[INFO] 
[INFO] wmt-jdk17                                                          [pom]
[INFO] wmt-framework-jdk17                                                [pom]
[INFO] wmt-common                                                         [jar]
[INFO] wmt-spring-boot-starter-web                                        [jar]
[INFO] wmt-spring-boot-starter-security                                   [jar]
[INFO] wmt-spring-boot-starter-mybatis                                    [jar]
[INFO] wmt-spring-boot-starter-redis                                      [jar]
[INFO] wmt-spring-boot-starter-mq                                         [jar]
[INFO] wmt-spring-boot-starter-job                                        [jar]
[INFO] wmt-spring-boot-starter-test                                       [jar]
[INFO] wmt-spring-boot-starter-biz-tenant                                 [jar]
[INFO] wmt-spring-boot-starter-websocket                                  [jar]
[INFO] 
[INFO] -------------------------< com.wmt:wmt-jdk17 >--------------------------
[INFO] Building wmt-jdk17 2025.12-jdk17-SNAPSHOT                         [1/12]
[INFO]   from pom.xml
[INFO] --------------------------------[ pom ]---------------------------------
[INFO] 
[INFO] --- dependency:3.7.0:tree (default-cli) @ wmt-jdk17 ---
[INFO] 
[INFO] --------------------< com.wmt:wmt-framework-jdk17 >---------------------
[INFO] Building wmt-framework-jdk17 2025.12-jdk17-SNAPSHOT               [2/12]
[INFO]   from wmt-framework-jdk17\pom.xml
[INFO] --------------------------------[ pom ]---------------------------------
[INFO] 
[INFO] --- dependency:3.7.0:tree (default-cli) @ wmt-framework-jdk17 ---
[INFO] 
[INFO] -------------------------< com.wmt:wmt-common >-------------------------
[INFO] Building wmt-common 2025.12-jdk17-SNAPSHOT                        [3/12]
[INFO]   from wmt-framework-jdk17\wmt-common\pom.xml
[INFO] --------------------------------[ jar ]---------------------------------
[INFO] 
[INFO] --- dependency:3.7.0:tree (default-cli) @ wmt-common ---
[INFO] com.wmt:wmt-common:jar:2025.12-jdk17-SNAPSHOT
[INFO] \- org.springdoc:springdoc-openapi-starter-webmvc-ui:jar:2.8.14:provided
[INFO]    \- org.springdoc:springdoc-openapi-starter-webmvc-api:jar:2.8.14:provided
[INFO]       \- org.springdoc:springdoc-openapi-starter-common:jar:2.8.14:provided
[INFO]          \- org.springframework.boot:spring-boot-starter-validation:jar:3.5.9:provided
[INFO]             \- org.apache.tomcat.embed:tomcat-embed-el:jar:10.1.50:provided
[INFO] 
[INFO] ----------------< com.wmt:wmt-spring-boot-starter-web >-----------------
[INFO] Building wmt-spring-boot-starter-web 2025.12-jdk17-SNAPSHOT       [4/12]
[INFO]   from wmt-framework-jdk17\wmt-spring-boot-starter-web\pom.xml
[INFO] --------------------------------[ jar ]---------------------------------
[INFO] 
[INFO] --- dependency:3.7.0:tree (default-cli) @ wmt-spring-boot-starter-web ---
[INFO] com.wmt:wmt-spring-boot-starter-web:jar:2025.12-jdk17-SNAPSHOT
[INFO] \- org.springdoc:springdoc-openapi-starter-webmvc-ui:jar:2.8.14:compile
[INFO]    \- org.springdoc:springdoc-openapi-starter-webmvc-api:jar:2.8.14:compile
[INFO]       \- org.springdoc:springdoc-openapi-starter-common:jar:2.8.14:compile
[INFO]          \- org.springframework.boot:spring-boot-starter-validation:jar:3.5.9:compile
[INFO]             \- org.apache.tomcat.embed:tomcat-embed-el:jar:10.1.50:compile
[INFO] 
[INFO] --------------< com.wmt:wmt-spring-boot-starter-security >--------------
[INFO] Building wmt-spring-boot-starter-security 2025.12-jdk17-SNAPSHOT  [5/12]
[INFO]   from wmt-framework-jdk17\wmt-spring-boot-starter-security\pom.xml
[INFO] --------------------------------[ jar ]---------------------------------
[INFO] 
[INFO] --- dependency:3.7.0:tree (default-cli) @ wmt-spring-boot-starter-security ---
[INFO] com.wmt:wmt-spring-boot-starter-security:jar:2025.12-jdk17-SNAPSHOT
[INFO] \- com.wmt:wmt-spring-boot-starter-web:jar:2025.12-jdk17-SNAPSHOT:compile
[INFO]    \- org.springdoc:springdoc-openapi-starter-webmvc-ui:jar:2.8.14:compile
[INFO]       \- org.springdoc:springdoc-openapi-starter-webmvc-api:jar:2.8.14:compile
[INFO]          \- org.springdoc:springdoc-openapi-starter-common:jar:2.8.14:compile
[INFO]             \- org.springframework.boot:spring-boot-starter-validation:jar:3.5.9:compile
[INFO]                \- org.apache.tomcat.embed:tomcat-embed-el:jar:10.1.50:compile
[INFO] 
[INFO] --------------< com.wmt:wmt-spring-boot-starter-mybatis >---------------
[INFO] Building wmt-spring-boot-starter-mybatis 2025.12-jdk17-SNAPSHOT   [6/12]
[INFO]   from wmt-framework-jdk17\wmt-spring-boot-starter-mybatis\pom.xml
[INFO] --------------------------------[ jar ]---------------------------------
[INFO] 
[INFO] --- dependency:3.7.0:tree (default-cli) @ wmt-spring-boot-starter-mybatis ---
[INFO] com.wmt:wmt-spring-boot-starter-mybatis:jar:2025.12-jdk17-SNAPSHOT
[INFO] \- com.wmt:wmt-spring-boot-starter-security:jar:2025.12-jdk17-SNAPSHOT:provided
[INFO]    \- com.wmt:wmt-spring-boot-starter-web:jar:2025.12-jdk17-SNAPSHOT:provided
[INFO]       \- org.springdoc:springdoc-openapi-starter-webmvc-ui:jar:2.8.14:provided
[INFO]          \- org.springdoc:springdoc-openapi-starter-webmvc-api:jar:2.8.14:provided
[INFO]             \- org.springdoc:springdoc-openapi-starter-common:jar:2.8.14:provided
[INFO]                \- org.springframework.boot:spring-boot-starter-validation:jar:3.5.9:provided
[INFO]                   \- org.apache.tomcat.embed:tomcat-embed-el:jar:10.1.50:provided
[INFO] 
[INFO] ---------------< com.wmt:wmt-spring-boot-starter-redis >----------------
[INFO] Building wmt-spring-boot-starter-redis 2025.12-jdk17-SNAPSHOT     [7/12]
[INFO]   from wmt-framework-jdk17\wmt-spring-boot-starter-redis\pom.xml
[INFO] --------------------------------[ jar ]---------------------------------
[INFO] 
[INFO] --- dependency:3.7.0:tree (default-cli) @ wmt-spring-boot-starter-redis ---
[INFO] 
[INFO] -----------------< com.wmt:wmt-spring-boot-starter-mq >-----------------
[INFO] Building wmt-spring-boot-starter-mq 2025.12-jdk17-SNAPSHOT        [8/12]
[INFO]   from wmt-framework-jdk17\wmt-spring-boot-starter-mq\pom.xml
[INFO] --------------------------------[ jar ]---------------------------------
[WARNING] 1 problem was encountered while building the effective model for org.javassist:javassist:jar:3.21.0-GA
[INFO] 
[INFO] --- dependency:3.7.0:tree (default-cli) @ wmt-spring-boot-starter-mq ---
[INFO] com.wmt:wmt-spring-boot-starter-mq:jar:2025.12-jdk17-SNAPSHOT
[INFO] \- org.apache.rocketmq:rocketmq-spring-boot-starter:jar:2.3.5:compile (optional)
[INFO]    \- org.springframework.boot:spring-boot-starter-validation:jar:3.5.9:compile (optional)
[INFO]       \- org.apache.tomcat.embed:tomcat-embed-el:jar:10.1.50:compile (optional)
[INFO] 
[INFO] ----------------< com.wmt:wmt-spring-boot-starter-job >-----------------
[INFO] Building wmt-spring-boot-starter-job 2025.12-jdk17-SNAPSHOT       [9/12]
[INFO]   from wmt-framework-jdk17\wmt-spring-boot-starter-job\pom.xml
[INFO] --------------------------------[ jar ]---------------------------------
[INFO] 
[INFO] --- dependency:3.7.0:tree (default-cli) @ wmt-spring-boot-starter-job ---
[INFO] 
[INFO] ----------------< com.wmt:wmt-spring-boot-starter-test >----------------
[INFO] Building wmt-spring-boot-starter-test 2025.12-jdk17-SNAPSHOT     [10/12]
[INFO]   from wmt-framework-jdk17\wmt-spring-boot-starter-test\pom.xml
[INFO] --------------------------------[ jar ]---------------------------------
[INFO] 
[INFO] --- dependency:3.7.0:tree (default-cli) @ wmt-spring-boot-starter-test ---
[INFO] 
[INFO] -------------< com.wmt:wmt-spring-boot-starter-biz-tenant >-------------
[INFO] Building wmt-spring-boot-starter-biz-tenant 2025.12-jdk17-SNAPSHOT [11/12]
[INFO]   from wmt-framework-jdk17\wmt-spring-boot-starter-biz-tenant\pom.xml
[INFO] --------------------------------[ jar ]---------------------------------
[INFO] 
[INFO] --- dependency:3.7.0:tree (default-cli) @ wmt-spring-boot-starter-biz-tenant ---
[INFO] com.wmt:wmt-spring-boot-starter-biz-tenant:jar:2025.12-jdk17-SNAPSHOT
[INFO] \- org.apache.rocketmq:rocketmq-spring-boot-starter:jar:2.3.5:compile (optional)
[INFO]    \- org.springframework.boot:spring-boot-starter-validation:jar:3.5.9:compile
[INFO]       \- org.apache.tomcat.embed:tomcat-embed-el:jar:10.1.50:compile
[INFO] 
[INFO] -------------< com.wmt:wmt-spring-boot-starter-websocket >--------------
[INFO] Building wmt-spring-boot-starter-websocket 2025.12-jdk17-SNAPSHOT [12/12]
[INFO]   from wmt-framework-jdk17\wmt-spring-boot-starter-websocket\pom.xml
[INFO] --------------------------------[ jar ]---------------------------------
[INFO] 
[INFO] --- dependency:3.7.0:tree (default-cli) @ wmt-spring-boot-starter-websocket ---
[INFO] com.wmt:wmt-spring-boot-starter-websocket:jar:2025.12-jdk17-SNAPSHOT
[INFO] \- org.apache.rocketmq:rocketmq-spring-boot-starter:jar:2.3.5:compile (optional)
[INFO]    \- org.springframework.boot:spring-boot-starter-validation:jar:3.5.9:compile
[INFO]       \- org.apache.tomcat.embed:tomcat-embed-el:jar:10.1.50:compile
[INFO] ------------------------------------------------------------------------
[INFO] Reactor Summary for wmt-jdk17 2025.12-jdk17-SNAPSHOT:
[INFO] 
[INFO] wmt-jdk17 .......................................... SUCCESS [  1.031 s]
[INFO] wmt-framework-jdk17 ................................ SUCCESS [  0.008 s]
[INFO] wmt-common ......................................... SUCCESS [  0.424 s]
[INFO] wmt-spring-boot-starter-web ........................ SUCCESS [  0.069 s]
[INFO] wmt-spring-boot-starter-security ................... SUCCESS [  0.077 s]
[INFO] wmt-spring-boot-starter-mybatis .................... SUCCESS [  0.606 s]
[INFO] wmt-spring-boot-starter-redis ...................... SUCCESS [  0.089 s]
[INFO] wmt-spring-boot-starter-mq ......................... SUCCESS [  0.163 s]
[INFO] wmt-spring-boot-starter-job ........................ SUCCESS [  0.012 s]
[INFO] wmt-spring-boot-starter-test ....................... SUCCESS [  0.040 s]
[INFO] wmt-spring-boot-starter-biz-tenant ................. SUCCESS [  0.059 s]
[INFO] wmt-spring-boot-starter-websocket .................. SUCCESS [  0.041 s]
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time:  3.240 s
[INFO] Finished at: 2026-04-24T16:48:10+08:00
[INFO] ------------------------------------------------------------------------