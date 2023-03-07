# Unofficial MCSManager Docker Image with built-in OpenJDK
See official repo [here](https://github.com/MCSManager/MCSManager)

## Version Info
| Minecraft Version | Recommended OpenJDK version |
| --- | --- |
| 1.7.X or lower | 8 |
| 1.8.X ~ 1.16.X | 11 |
| 1.17.X or higher | 17 |

Please check the [Releases page](https://github.com/MCSManager/MCSManager/releases) of the official repository for the version relationship between daemon and web.

## Latest build
Daemon: 3.3.0
Web: 9.8.0

## Usage
### Build
1. Make sure `curl` and `jq` are installed
2. Set DOCKERHUB_USER and DOCKERHUB_PASS in your env, E.g `export DOCKERHUB_USER=xxx`
3. Run `build-all.sh`

### Run Daemon
```
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
```
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
```
$ docker stop mcsm-{daemon,web}
$ docker rm mcsm-{daemon,web}
```
