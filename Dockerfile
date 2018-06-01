FROM maven:latest as builder
ENTRYPOINT [ "/bin/sh" ]
WORKDIR /app
COPY . .
RUN cd spring-petclinic && mvn package -Dmaven.test.skip=true

FROM java:alpine
WORKDIR /app
RUN  addgroup -g 1000 -S user && \
   adduser -u 1000 -S user -G user
USER user
COPY --from=builder --chown=user:user /app/spring-petclinic/target/*.jar ./pc.jar
ENV DB_USER=myuser
ENV DB_HOST=mysql
ENV DB_PASS=1234
ENV DB_NAME=pc
ENV DB_PORT=3306
EXPOSE 8080
# ENTRYPOINT [ "/bin/sh" ]
CMD ["java","-jar","/app/spring-petclinic/target/pc.jar"]