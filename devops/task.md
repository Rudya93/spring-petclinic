# Kv-037.DevOps Project Demo I
## Deploying Spring PetClinic Sample Application localy using Vagrant

Create a deployment script for the **PetClinic** application. Use **Vagrant** to automate the process of creating the infrastructure for the deployment with **Virtualbox** (*preferably*) or **AWS** provider. As for provisioning you can choose to use **bash**, **python** or **ansbile** in any combination.

- Subtask I - Infrastructure
	* Describe *[two](https://www.vagrantup.com/docs/multi-machine/)* virtual machines using Vagrantfile for deployment of the application (codename **APP_VM**) and the database (codename **DB_VM**) 
	* Preferably use [private networking](https://www.vagrantup.com/docs/networking/private_network.html) feature for easy VM communication
	* VMs should be either Centos 7 (`bento/centos-7.1` or `bento/centos-7.4` box) or Ubuntu 16.04 (`ubuntu/xenial64` box)
	* If not using private networking then **APP_VM** should have port `8080` forwarded to host

- Subtask II - Database
	* Use any [provisioning](https://www.vagrantup.com/docs/provisioning/basic_usage.html) script that you created to install `MySQL 5.7.8` and any dependency on **DB_VM**
	* Customize the mysql database to accept connections only from your vagrant private network subnet
	* Create a non root user and password (codename **DB_USER** and **DB_PASS**) in mysql. Use host environment variable to set these values and pass them to the Vagrantfile using `ENV`
	* Create a database in mysql (codename **DB_NAME**) and grant all privileges for the **DB_USER** to access the database
	* Check if the mysql server is up and running and the database is accessible by created user (using either bash, python or ansible). If the databse is not accessible - break the provisoning process.

- Subtask III - Application
	* Create a non root user (codename **APP_USER**) that will be used to run the application on **APP_VM**
	* Use any provisioner to install `Java JDK 8`, `git` and any dependency on **APP_VM**
	* Clone [this repository](https://github.com/DmyMi/spring-petclinic) to the working folder (codename **PROJECT_DIR**)
	* Use the Maven tool to run tests and package the application. For more info you can use this [5 minutes maven](https://maven.apache.org/guides/getting-started/maven-in-five-minutes.html) documentation. For convenience the project folder has Maven wrapper script (`mvnw`) that downloads and executes the required Maven binary automaticaly.
	* If testing and packaging is successful, then get the `*.jar` package from `$PROJECT_DIR/target` folder and place it in the **APP_USER** home folder (codename **APP_DIR**).
	* Set environment variables in **APP_VM** (preferable use the same environment variables passed from host machine using `ENV` as in **DB_VM**):
		* `DB_HOST` - IP of the **DB_VM**
		* `DB_PORT` - MySql port (default 3306)
		* `DB_NAME` - MySql database name
		* `DB_USER` - MySql user
		* `DB_PASS` - MySql user's password
	* Run the application with the **APP_USER** using the `java -jar` command
	* Create a script to wait for up to 1 minute to check if the application is up and running. Use application healthcheck endpoint `http://localhost:8080/manage/health` to see if response code is `200` and the status in the response body is up (`{"status":"UP"}`)

If everything is successful - you will see the PetClinic application on `$APP_VM_IP:8080`
	
# Kv-037.DevOps Project Demo II
## Setup Jenkins CI for Spring PetClinic Sample Application

- Fork the Application [repository](https://github.com/DmyMi/spring-petclinic) 
- Setup Jenkins
	* Deploy Jenkins on AWS Instance or Local VM
	* Setup Jenkins plugins (credentials, ssh-credentials, git, maven-plugin, github, ec2, ssh-slaves)
	* Create Jenkins Pipeline Job from project (extra task: Describe job using **Job DSL** syntax to create jobs automatically)
	* Setup job to look for **Jenkinsfile** in your project root directory
	* Setup EC2 plugin to be able to create AWS Workers to run the job.
	* Setup Maven global tools cofiguration
	* Make Sure the AWS Workers have other required tools (ansible, python, etc.)
        
- Describe a pipleline to build and deploy the application
	* Create a **Jenkinsfile** in your project root directory
	* Create pipeline steps to: checkout project from repository, build the application and run tests.
	* Create a step to launch **2** Instances on AWS and wait for them to be fully operational. Use either aws-cli/boto3 library or Ansible AWS Module.
	* Create a step to deploy the MySQL database to one of the instances using previously created ansible script
	* Create a step to deploy the application to other instance using previously created application deployment script
	* Create a step to check if the application is up and running
	* If every step is good - finish the job and archive the artifacts (\*.jar)

# Kv-037.DevOps Project Demo III
## Setup Jenkins CI for Spring PetClinic Sample Application

- Setup Jenkins
	* Clear unnecessary Jenkins Plugins (for example, remove ec2 plugin)
	* Install and configure **Docker** on Jenkins VM
	* Install and configure Jenkins Docker Plugin to be able to create Docker workers
- Setup Deployment host (can be done **once** manualy or using *Ansible*, not neccessary to do it all the time during pipeline)
	* Set up *Avoid Accidental Termination*
	* Install Docker on Deployment host
	* Install necessary tools (for example, Python, docker-py library)
- Setup Systemd unit template for ansible to start our docker container as a service
	* it should have a ExecStartPre section with "docker pull ...", ExecStart with "docker run ..." and ExecStop with "docker stop ..."
	* Create an ansible playbook that will later copy this template with apropriate varialbe (new image name after build) to Deploment host
	* The playbook should also be able to create a docker network for deployment
	* The playbook should be able to setup a mysql or mariadb container with required user, password and database
	* The database container should have a volume attached to persist the database during container restarts
- Describe a pipleline to build and deploy the application in Container
	* Create **Dockerfile** for application container. Additionaly to be able to just run the application:
		* It should have a separate folder for application
		* It should have a separate non-root user to own the application
		* It should expose the 8080 port
	* Build the application by using the docker worker with maven image.
	* Build the container image using docker worker with docker image (for example, by configuring docker in docker)
	* Alternatively, you can combine two previous steps by using the multi stage Dockerfile
	* Make sure the docker image tag is set to the current build number of jenkins, or if the git commit has a tag added (for example, *release*) - the image tag should be the same as commit tag (it is possible to use apropriate jenkins build version plugin)
	* Push the newly created image to a Docker registry of your choice (Amazon Container Registry, docker hub, gitlab registry, your own registry on AWS Instance)
	* Use ansible or jenkins ansible to copy the template of Systemd service unit to Deployment host
	* Use ansible to start the new container using systemd service (make sure it is connected to the same docker network as the database)
	* check if the application is running

# Kv-037.DevOps Project Demo IV
## Use Kubernetes to Deploy Spring PetClinic Sample Application

- Setup Kubernetes Cluster
	* Use [kops](https://github.com/kubernetes/kops/blob/master/docs/aws.md) to setup a Kubernetes Cluster on AWS
	* Install **kubectl**[kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/#install-kubectl-binary-via-native-package-management)
	* Install and configure Dashboard Addon for Kubernetes
- Setup Database Service
	* Create Database name, login and password *Secrets* and deploy them to cluster
	* Create a *Persistent Volume Claim* for Database
	* Create Database *Deployment* and *Service* with ClusterIP
		* Use secrets to pass environment variables inside containers
- Setup Application Service
	* Create application *Deployment* and *Service* with ClusterIP
		* Use secrets to pass environment variables inside containers
- Setup Ingress for application
	* Create default backend for Ingress
	* Create Ingress Controller
	* Describe Ingress with LoadBalancer type to access our application
	* *Optional* Setup SSl Certificate for Nginx yourself
- Add Monitoring for Kubernetes
	* Use either [Datadog](https://www.datadoghq.com/) or Prometheus addon
- Setup Jenkins
	* Create jenkins file credentials with kubectl config
	* Modify pipeline to build and push docker image with application to deploy new version to cluster using **kubectl apply ...**
		* Use the file secret to pass config file for kubectl
	* *Optional* Configure Blue/Green Deployment for application [example](https://github.com/IanLewis/kubernetes-bluegreen-deployment-tutorial)
