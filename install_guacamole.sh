#/bin/sh

#apt update
#apt install -y gcc g++ libcairo2-dev libjpeg-turbo8-dev libpng-dev libtool-bin libossp-uuid-dev libavcodec-dev libavutil-dev libswscale-dev freerdp2-dev libpango1.0-dev libssh2-1-dev libvncserver-dev libtelnet-dev libssl-dev libvorbis-dev libwebp-dev build-essential net-tools curl git software-properties-common tomcat9 tomcat9-admin tomcat9-common tomcat9-user 

#cd /tmp
#wget https://downloads.apache.org/guacamole/1.1.0/source/guacamole-server-1.1.0.tar.gz
#tar xzf guacamole-server-1.1.0.tar.gz
#rm guacamole-server-1.1.0.tar.gz
/guacamole-server-1.1.0/configure --with-init-dir=/etc/init.d
make
make install
ldconfig

