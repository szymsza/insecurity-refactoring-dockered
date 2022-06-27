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

### Using Windows as host system
Since the `./start` file is a bash script, it can't be directly executed on Windows. However, it only executes `docker run` command with various options, therefore extracting the commands and executing them manually should not be difficult.

Compared to Unix-like systems however, special attention might be required for mounting volumes (`-v $PWD/data:$INTERNAL_DATA_PATH` inside the main command of the `./start` script) and enabling displaying GUI (`--env DISPLAY=$DISPLAY --privileged -v /tmp/.X11-unix:/tmp/.X11-unix` inside the script; more details about running GUI applications inside Docker on Windows can be found for example [here](https://cuneyt.aliustaoglu.biz/en/running-gui-applications-in-docker-on-windows-linux-mac-hosts/)).
