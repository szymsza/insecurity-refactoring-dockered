# Insecurity Refactoring - Dockerized
This repository provides a Dockerfile and some simple scripts to run [fschuckert/insecurity-refactoring](https://github.com/fschuckert/insecurity-refactoring)

## Usage
- `docker build -t itsec .` - (re)build the Dockerfile
- `./start` - start the GUI application
- `./start -s` - start Bash shell inside the container
- `./data` - directory mounted to `/home/data` inside the container
