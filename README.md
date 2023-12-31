# Spring Boot Restful API and Vue.js Frontend 

## Code copied from [github.com/simplesolutiondev](https://github.com/simplesolutiondev/spring-boot-restful-api-vuejs-frontend) <3

## Description
I wanted to learn Jenkins and promote my Docker skills in the process and this is the child of this idea.

This is simple web application with backend, frontend and database.
Each part is containerized and the whole thing is packed into a docker stack.
Fun thing to do is to try and update the versions of packages and dependencies and see how the app performs :D

This project was made with the idea to commision as much work to Docker containers as possible.
No tools were installed on main server except for those needed for Jenkins.

You only need to setup a heavy lifter server with Docker, Java and Git to take care of builds.
I've also setup a SonarQube server as a separate server to use in other projects so that's not a container.
But you can contract this work to docker as well :D

Also tried to hide as much of the secreets from view so to follow best practices for DevOps with mixed results :)

## Features 

This pipeline incorporates plugins:
- BlueOcean
- Docker API 
- Docker pipeline 
- OWASP Dependency-Check
- SonarQube Scanner
- All the recomended plugins by Jenkins

A private Docker repo was made with [dockerHub/registry](https://hub.docker.com/_/registry) to store the images

SonarQube server has to be installed separately

Jenkins connects to builder via SSH - the keys and account were added prior to both servers(builder and Jenkins-main)

Backend is dockerized with openjdk:8 as this is an old project  
Frontend has a multi-stage build and is provisioned on nginx container
DB also has a special image that includes HEALTHCHECK to ensure mysql is running and you can connect to is as well as a preconfigured script that creates the database for use in app 
## Configuration

I have 2 parameters that can be set for build  
*SERVER_IP* - IP of deployment server, where the app will be deployed  
*PRIV_REPO* - IP and port of the private repo mentioned before  

Also the artifacts that were created durring build are saved on server

Credentials have to be set as a secret value to be used in Jenkinfile  
Jenkins will save the tegged images on builder server and only send latest to repository  

## Quirks

To fight with CORS on server both frontend and backed must have the IP given  
It's achieved with application.properties for Java and .env file for VUE  

A line has to be added to ```/etc/docker/daemon.json``` to allow our repo ```"insecure-registries":["host:port"]```  

An additional persistent disk is mounted on build for gradle to reduce the time of build - this disk retains dependencies downloaded  

## Requirements

Project uses most recent versions of all plugins as well as Jenkins and Docker - tested on AlmaLinux  
This Jenkins file should work out of the box after configuring the builder node so that Jenkins can connect to it.  
