# Unofficial MCSManager Docker Image with built-in OpenJDK
See official repo [here](https://github.com/MCSManager/MCSManager)

## Version Info
| MineCraft Version | Recommended OpenJDK version |
| --- | --- |
| 1.7.X or lower | 8 |
| 1.8.X ~ 1.16.X | 11 |
| 1.17.X or higher | 17 |

## Usage
### Build
1. Make sure `curl` and `jq` are installed
2. Set DOCKERHUB_USER and DOCKERHUB_PASS in your env, E.g `export DOCKERHUB_USER=xxx`
3. Run `build-all.sh`

### Run
```
$ docker run -d --name mcsm-daemon \
             -p 24444:24444 \
             -p 25565-25575:25565-25575 \
             -v your/path/to/data:/opt/mcsm/releases/daemon/data \
             -v your/path/to/logs:/opt/mcsm/releases/daemon/logs \
             -v /var/run/docker.sock:/var/run/docker.sock \
             ngc7331/mcsmanager-daemon:<tag>
```
Notes:
1. Replace `your/path/to/xxx` with your actual path
2. Replace `<tag>` with `latest` or any valid tag, checkout [tags](https://hub.docker.com/repository/docker/ngc7331/mcsmanager-daemon/tags) on Docker Hub
3. If you don't want use mcsm to control docker, delete `-v /var/run/docker.sock:/var/run/docker.sock \`

### Stop & Remove
```
$ docker stop mcsm-daemon
$ docker rm mcsm-daemon
```
