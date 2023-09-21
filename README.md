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

For Jenkins I've learned:
 - how to write pipelines (stages, tools, credentials, configuration of nodes etc.)
 - utilize Jenkins plugins (BlueOcean, Docker, SonarQube, OWASP)
 - add and manage Clouds and Nodes for Jenkins
 - configure projects
 - manage credentials

For Docker:
 - 

