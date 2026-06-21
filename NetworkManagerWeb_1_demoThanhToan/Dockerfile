# syntax=docker/dockerfile:1
FROM maven:3.9.9-eclipse-temurin-8 AS builder

WORKDIR /app
COPY pom.xml ./
RUN mvn -B -ntp dependency:go-offline

COPY src ./src
COPY web ./web
RUN mvn -B -ntp clean package -DskipTests

FROM tomcat:9.0-jdk8-temurin

# Environment variables - set these in Render dashboard
ENV DB_URL="jdbc:postgresql://localhost:5432/network_db" \
    DB_USER="postgres" \
    DB_PASSWORD="postgres" \
    VNPAY_TMN_CODE="" \
    VNPAY_HASH_SECRET="" \
    VNPAY_RETURN_URL="" \
    VNPAY_PREMIUM_AMOUNT="99000" \
    JAVA_OPTS="-Dfile.encoding=UTF-8 -Duser.timezone=Asia/Ho_Chi_Minh"

RUN rm -rf /usr/local/tomcat/webapps/*
COPY --from=builder /app/target/NetworkManagerWeb_1_demoThanhToan.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]
