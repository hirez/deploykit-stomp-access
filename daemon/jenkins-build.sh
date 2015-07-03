#!/bin/bash -x

mkdir -p build/usr/sbin/
mkdir -p build/etc/stomp-access/
mkdir -p build/etc/init.d/

cp stomp-access build/usr/sbin/stomp-access
cp stomp-access.yaml build/etc/stomp-access/stomp-access.yaml
cp stomp-access.init build/etc/init.d/stomp-access

PKG_VER=`grep '^version' stomp-access | awk -F\" '{print $2}'`
BUILDN=${BUILD_NUMBER:=1}

/usr/bin/fakeroot /usr/local/bin/fpm -s dir -t deb -n "stomp-access" -f \
  -v ${PKG_VER}.${BUILDN} --description "Future remote htaccess mangler" \
  --config-files /etc/stomp-access/stomp-access.yaml \
  -a all -m "<list.itoperations@futurenet.com>" \
  -C ./build .

