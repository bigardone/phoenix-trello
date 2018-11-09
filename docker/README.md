# Dockerfile
 Dockefile is created on top of `ubuntu` image.
 # Requirements
 - The project should be cloned from https://github.com/trilogy-group/phoenix-trello
 - Docker version 18.09.0-ce
 - Docker compose version 1.21.0
  
# Quick Start
- Clone the repository
- Open a terminal session to that folder
- Run `docker-cli start`
- Run `docker-cli exec`
- At this point you must be inside the docker container, in the root folder of the project. From there, you can run the commands as usual:
	- `mix ecto.create && mix ecto.migrate` to create and migrade DB
	- `mix run priv/repo/seeds.exs` to create demo user
	- `mix phoenix.server` to run trello server
	
- When you finish working with the container, type `exit`
- Run `docker-cli stop` to stop and remove the service.
 
 Please refer to [Contributing](../CONTRIBUTING.md) doc for more details on the building and running the app.
