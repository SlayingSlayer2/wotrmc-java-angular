# ---- build (Maven) ----
FROM maven:3.9-eclipse-temurin-21 AS build
WORKDIR /app
COPY pom.xml .
RUN mvn -q -e -DskipTests dependency:go-offline
COPY src ./src
RUN mvn -q -DskipTests package

# ---- runtime (JRE) ----
FROM eclipse-temurin:21-jre
WORKDIR /app
# copy the fat jar built above; adjust the name if your jar differs
COPY --from=build /app/target/*-SNAPSHOT.jar app.jar
ENV JAVA_OPTS=""
EXPOSE 8080
ENTRYPOINT ["sh","-c","java $JAVA_OPTS -jar /app/app.jar"]
