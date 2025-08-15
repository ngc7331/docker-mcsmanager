# Unofficial MCSManager Docker Image with built-in OpenJDK
See official repo [here](https://github.com/MCSManager/MCSManager)

## Last build info
- mcsmanager version: 10.8.1

## About v10
MCSManager is under a major update to v10, make sure to backup your data before upgrading.

Also, this repo is doing refactoring to support v10 (and provide better experience), please checkout `v9` branch for old version.

## OpenJDK Version
See official doc [here](https://docs.mcsmanager.com/setup_package.html#install-java-environment) to choose the right JDK version depending on your Minecraft server version.

There are two ways to specify JDK version:
1. Use `ngc7331/mcsmanager-daemon:latest-jdk${JDK_VERSION}` tag to use the pre-installed Openjdk, e.g. `ngc7331/mcsmanager-daemon:latest-jdk21` will give you an out-of-box OpenJDK 21.
   1. Use `:latest-nojdk` tag to skip the pre-installed JDK, and you can install it at runtime.
2. Use `-e JDK_VERSION=${COMMA_SEPARATED_JDK_VERSION}` to specify the JDK version, e.g. `-e JDK_VERSION=11,17` will install OpenJDK 11 and 17 at runtime, note that this will take some time, and will run every time you re-create the container. The pre-installed JDK will be ignored.

For example, if you run `docker run ... -e JDK_VERSION=17,21 ... ngc7331/mcsmanager-daemon:latest-jdk17`, you will get something like this in the log:
```
[init-jdk] Setting up JDK...
[init-jdk] Requested JDK version: 17,21
[init-jdk] Skipping pre-installed JDK 17 installation...
[init-jdk] Installing JDK 21...
fetch http://dl-cdn.alpinelinux.org/alpine/v3.20/main/x86_64/APKINDEX.tar.gz
fetch http://dl-cdn.alpinelinux.org/alpine/v3.20/community/x86_64/APKINDEX.tar.gz
(1/1) Installing openjdk21-jre-headless (21.0.4_p7-r0)
Executing java-common-0.5-r0.trigger
OK: 436 MiB in 65 packages
openjdk version "21.0.4" 2024-07-16
OpenJDK Runtime Environment (build 21.0.4+7-alpine-r0)
OpenJDK 64-Bit Server VM (build 21.0.4+7-alpine-r0, mixed mode, sharing)
[init-jdk] Setting default version to 17...
openjdk version "17.0.12" 2024-07-16
OpenJDK Runtime Environment (build 17.0.12+7-alpine-r0)
OpenJDK 64-Bit Server VM (build 17.0.12+7-alpine-r0, mixed mode, sharing)
[init-jdk] JDK setup done.
...
```

You can use `/usr/lib/jvm/java-${JDK_VERSION}-openjdk/bin/java` (or `java${JDK_VERSION}` for short) to run your Minecraft server with the specified JDK version. `/usr/lib/jvm/default-jvm/bin/java` (or `java` for short) points to the pre-installed JDK version.

Currently, the `latest` tag is equivalent to `latest-jdk21`.

From 2025.03.22, pre-built openjdk 7/11/17 support is dropped, you can still use `-e JDK_VERSION=7,11,17` to install them at runtime.

## Plugin
This is an experimental system that automatically installs plugins at runtime via the `PLUGIN` environment variable, currently supported plugins are:
- `mcdr`: [MCDReforged](https://github.com/MCDReforged/MCDReforged) (includes python3)

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

#### Optional envs
| Name | Default | Description |
| ---- | ------- | ----------- |
| `TZ` | `Asia/Shanghai` | Timezone |
| `JAVA_VERSION` | `` | Comma-seperated OpenJDK version, see [here](https://docs.mcsmanager.com/setup_package.html#install-java-environment)|
| `PUID` | `0` | User ID |
| `PGID` | `0` | Group ID |
| `PLUGIN` | `` | Comma-seperated plugin list, see [here](#plugin) |

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

#### Optional envs
| Name | Default | Description |
| ---- | ------- | ----------- |
| `TZ` | `Asia/Shanghai` | Timezone |
| `PUID` | `0` | User ID |
| `PGID` | `0` | Group ID |

### Stop & Remove
```bash
$ docker stop mcsm-{daemon,web}
$ docker rm mcsm-{daemon,web}
```
