# shelltools

Useful shell scripts for developers

## Project Cd, Build, Run, Stop

The scripts pcd.sh, pbuild.sh, prun.sh and pstop.sh are shortcuts on commandline in order to change dir to a certain project and build, run or stop a certain project.

### General setup

Setup these settings before usind the scripts

#### Configuration

Copy pcd.config.sample to pcd.config and adapt the settings to your needs.

Example:

```javascript
projectConfigArray=(
	'myproject###/path/to/project'
	'myproject2###/path/to/project2'
)

buildConfigArray=(
    'myproject###mvn clean install'
	'myproject2###mvn -Pproject2 compile'
)

runConfigArray=(
    'myproject###startproject.sh'
    'myproject2###startproject2.sh'
)

stopConfigArray=(
    'myproject2###stopproject2.sh'
)
```

#### Path

Add the folder of the scripts to the PATH variable.

#### Aliases

Add the following aliases to you ~/.alias file:

```sh
alias cdp='source pcd.sh'
alias run='source prun.sh'
alias build='source pbuild.sh'
alias stop='source pstop.sh'
```

#### Bash completion

Add the following to your ~/.bash_profile or ~/.bashrc:

```sh
source <path_to>/pcd_autocomplete.bash
```

### pcd.sh

This script changes to the configured directory of a certain project folder.

#### Usage

```sh
cdp myproject
```

### pbuild.sh

This script changes to the directory of a certain project folder and executes the configured build command.

#### Usage

```sh
build myproject
```

or without parameter if already in project folder:

```sh
cd /path/to/project2
build
```

### prun.sh

This script changes to the directory of a certain project folder and executes the configured start command.

#### Usage

```sh
run myproject
```

or without parameter if already in project folder:

```sh
cd /path/to/project2
run
```

### pstop.sh

This script changes to the directory of a certain project folder and executes the configured stop command.

#### Usage

```sh
stop myproject
```

or without parameter if already in project folder:

```sh
cd /path/to/project2
stop
```

## rgit.sh (Recursive Git)

rgit.sh executes the given git command in all subdirectories which are git repositories.

## rmvn.sh (Recursive Maven)

rmvn.sh executes the given Maven command in all subdirectories which are Maven modules. The order is given by name and not Maven dependencies!

## Troubleshooting

The scripts were tested on Windows Git Bash and MacOS.