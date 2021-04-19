# shelltools

Useful shell scripts for developers.

## Project Cd, Clean, Build, Tests, Run, Stop

The scripts pcd.sh, pclean.sh, pbuild.sh, prun.sh and pstop.sh are shortcuts on commandline in order to change dir to a certain project and clean, build, run or stop a certain project. For each project the commands are individully configurable. It has already some default configuration for Maven, Gradle, npm and Vagrant which can be overwritten. The 'p' in pcd stands for 'project'.

### Usage examples

After configuration is done as described below, those use-cases are possible:

```console
~ $ cdp myproject
cd /path/to/myproject

/path/to/myproject $ clean
mvn clean

/path/to/myproject $ build
mvn clean compile

/path/to/myproject $ tests
mvn test

/path/to/myproject $ run
mvn spring-boot:run

/path/to/myproject $ stop
mvn spring-boot:stop

/path/to/myproject $ run docker
docker-compose up -d

/path/to/myproject $ stop docker
docker-compose stop -d
```

### General setup

Setup these settings before using the scripts:

#### Configuration

Copy _shelltools to ~/.shelltools in your home directory and adapt the settings to your needs.

Example:

```javascript
# Structure: "project ### path"
projectConfigArray=(
    'myproject###/path/to/myproject'
    'myproject2###/path/to/myproject2'
)

cleanConfigArray=(
    'myproject###mvn clean'
    'myproject2###rm -rf node_modules/'
)

buildConfigArray=(
    'myproject###mvn clean install'
    'myproject2###./gradlew compileJava'
)

testsConfigArray=(
    'myproject###mvn test'
    'myproject2###./gradlew test'
)

runConfigArray=(
    'myproject###startproject.sh'
    'myproject2###startproject2.sh'
)

runAliasConfigArray=(
	'myproject###docker###docker-compose up'
)

stopConfigArray=(
    'myproject2###stopproject2.sh'
)

stopAliasConfigArray=(
    'myproject###docker###docker-compose stop'
)
```

#### Path

Add the folder of the scripts to the PATH variable.

#### Aliases [optional]

Add the following aliases to your ~/.alias file:

```sh
alias cdp='source pcd.sh'
alias run='source prun.sh'
alias build='source pbuild.sh'
alias tests='source ptests.sh'
alias stop='source pstop.sh'
```

#### Bash completion [optional]

Add the following to your ~/.bash_profile or ~/.bashrc:

```sh
source <path_to>/pcd_autocomplete.bash
```

### cdp (pcd.sh)

This script changes to the configured directory of a certain project.

#### Usage example

```console
$ cdp myproject
cd /path/to/myproject
```

### pclean.sh

This script executes the configured "pclean.sh" command. If not already there, it changes to the directory of the project in the first place. 

#### Usage example

```console
$ pclean.sh myproject
mvn clean
```

or without parameter if already in project folder:

```console
$ cd /path/to/myproject2
$ pclean.sh
mvn clean
```

### build (pbuild.sh)

This script executes the configured "build" command. If not already there, it changes to the directory of the project in the first place. 

#### Usage example

```console
$ build myproject
mvn clean compile
```

or without parameter if already in project folder:

```console
$ cd /path/to/myproject2
$ build
mvn clean compile
```

### tests (ptests.sh)

This script executes the configured "tests" command. If not already there, it changes to the directory of the project in the first place. 

#### Usage example

```console
$ tests myproject
mvn test
```

or without parameter if already in project folder:

```console
$ cd /path/to/myproject2
$ tests
mvn test
```

### run (prun.sh)

This script executes the configured "run" command. If not already there, it changes to the directory of the project in the first place. 

#### Usage example

```console
$ run myNpmProject
npm start
```

or without parameter if already in project folder:

```console
$ cd /path/to/myproject3
$ run
npm start
```

### run alias

'run' accepts a paramter in order to run different artifacts for the same project.

#### Usage example

```console
$ run docker
docker-compose up -d
```

### stop (pstop.sh)

This script executes the configured "stop" command. If not already there, it changes to the directory of the project in the first place. 

#### Usage example

```sh
stop myproject
```

or without parameter if already in project folder:

```sh
cd /path/to/project2
stop
```

### stop alias

'stop' accepts a paramter in order to stop different artifacts for the same project.

#### Usage example

```console
$ stop docker
docker-compose stop
```

## rgit.sh (Recursive Git)

rgit.sh executes the given git command in all subdirectories which are git repositories.

### Usage example

```console
$ rgit status
```

## rmvn.sh (Recursive Maven)

rmvn.sh executes the given Maven command in all subdirectories which are Maven modules. The order is given by names of subdirectories the and not Maven dependencies!

### Usage example

```console
$ rmvn validate
```

## Troubleshooting

The scripts were tested on Windows Git Bash, MacOS and Ubuntu.