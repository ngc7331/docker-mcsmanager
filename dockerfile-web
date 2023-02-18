FROM node:14-alpine

ARG INSTALL_PATH=/opt/mcsm

# install git
RUN apk --no-cache add git

# install mcsm
RUN git clone --single-branch -b master --depth 1 https://github.com/MCSManager/MCSManager-Web-Production $INSTALL_PATH/web && \
    cd $INSTALL_PATH/web && \
    npm i --production

ENV TZ=Asia/Shanghai
VOLUME [ "$INSTALL_PATH/web/data", "$INSTALL_PATH/web/logs" ]
EXPOSE 23333
WORKDIR $INSTALL_PATH/web
CMD [ "node", "app.js" ]
