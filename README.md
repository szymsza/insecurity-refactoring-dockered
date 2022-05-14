# Insecurity Refactoring - Dockerized
This repository provides a Dockerfile and some simple scripts to run [fschuckert/insecurity-refactoring](https://github.com/fschuckert/insecurity-refactoring)

## Usage
### Basics
- `docker build -t itsec .` - (re)build the Dockerfile
- `./start` - start the GUI application
- `./start -s` - start Bash shell inside the container
- `./data` - directory mounted to `/home/data` inside the container
### Using a custom fork
`[path]` is a relative path inside `./data` directory, defaulting to `insecurity-refactoring`
- `./start -b [path]` - build a custom fork of the tool
- `./start -r [path]` - rebuild a custom fork of the tool (maven only)
  - for repeated rebuilds, opening a shell inside the container and running `mvn package` directly will be faster thanks to caching
- `./start -e [path]` - execute a custom fork of the tool

E.g. after cloning your forked repo to `./data/insecurity-refactoring-mine`, run `./start -b insecurity-refactoring-mine` once and then `./start -e insecurity-refactoring-mine` every time to start the tool.
