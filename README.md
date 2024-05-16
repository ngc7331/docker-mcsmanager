# Unofficial MCSManager Docker Image with built-in OpenJDK
See official repo [here](https://github.com/MCSManager/MCSManager)

## About v10
MCSManager is under a major update to v10, make sure to backup your data before upgrading.

Also, this repo is doing refactoring to support v10 (and provide better experience), please checkout `v9` branch for old version.

## OpenJDK Version
See official doc [here](https://docs.mcsmanager.com/setup_package.html#install-java-environment) to choose the right JDK version depending on your Minecraft server version.

## Usage
### Run Daemon
```bash
$ docker run -d --name mcsm-daemon \
             -p 24444:24444 \
             -p 25565-25575:25565-25575 \
             -v your/path/to/data:/opt/mcsm/daemon/data \
             -v your/path/to/logs:/opt/mcsm/daemon/logs \
             -v /var/run/docker.sock:/var/run/docker.sock \
             ngc7331/mcsmanager-daemon:<tag>
```
Notes:
1. Replace `your/path/to/xxx` with your actual path
2. Replace `<tag>` with `latest` or any valid tag, checkout [tags](https://hub.docker.com/repository/docker/ngc7331/mcsmanager-daemon/tags) on Docker Hub
3. If you don't want use mcsm to control docker, remove `-v /var/run/docker.sock:/var/run/docker.sock \`

### Run Web
```bash
$ docker run -d --name mcsm-web \
             -p 23333:23333 \
             -v your/path/to/data:/opt/mcsm/web/data \
             -v your/path/to/logs:/opt/mcsm/web/logs \
             ngc7331/mcsmanager-web:<tag>
```
Notes:
1. Replace `your/path/to/xxx` with your actual path
2. Replace `<tag>` with `latest` or any valid tag, checkout [tags](https://hub.docker.com/repository/docker/ngc7331/mcsmanager-web/tags) on Docker Hub

### Stop & Remove
```bash
$ docker stop mcsm-{daemon,web}
$ docker rm mcsm-{daemon,web}
```
