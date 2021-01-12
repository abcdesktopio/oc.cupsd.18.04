FROM ubuntu:18.04

MAINTAINER Alexandre DEVELY

LABEL vcs-type "git"
LABEL vcs-url  "https://github.com/abcdesktopio/oc.user.18.04/oc.cupsd.18.04"
LABEL vcs-ref  "master"
LABEL release  "5"
LABEL version  "1.2"
LABEL architecture "x86_64"

## 
# install fonts and themes
RUN DEBIAN_FRONTEND=noninteractive  apt-get update && apt-get install -y --no-install-recommends \
	xfonts-base			\
        xfonts-encodings                \
        xfonts-utils                    \
	xfonts-100dpi			\
	xfonts-75dpi			\
	xfonts-cyrillic			\
        ubuntustudio-fonts              \
   	libfontconfig 			\
    	libfreetype6 			\
    	ttf-ubuntu-font-family 		\
	ttf-dejavu-core			\
        fonts-freefont-ttf		\
  	fonts-croscore                  \
        fonts-dejavu-core               \
        fonts-horai-umefont             \
        fonts-noto                      \
        fonts-opendyslexic              \
        fonts-roboto                    \
        fonts-roboto-hinted             \
        fonts-sil-mondulkiri            \
        fonts-unfonts-core              \
        fonts-wqy-microhei              \
	fonts-ipafont-gothic            \
        fonts-wqy-zenhei                \
        fonts-tlwg-loma-otf             \
        && apt-get clean



# cups-pdf: pdf printer support
# scrot: screenshot tools
# smbclient need to install smb printer
# cups: printer support
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y --no-install-recommends \
        smbclient	\
	cups-pdf 	\
	scrot  		\
        cups		\
        && apt-get clean

# apt install iproute2 install ip command
# iputils-ping and vin can be removed
RUN DEBIAN_FRONTEND=noninteractive  apt-get update && apt-get install -y  --no-install-recommends      \
        iproute2                                                                \
	iputils-ping								\
        && apt-get clean


COPY docker-entrypoint.sh /docker-entrypoint.sh

# Add 
RUN adduser root lpadmin 

# Next command use $BUSER context
ENV BUSER balloon
# RUN adduser --disabled-password --gecos '' $BUSER
# RUN id -u $BUSER &>/dev/null || 
RUN groupadd --gid 4096 $BUSER
RUN useradd --create-home --shell /bin/bash --uid 4096 -g $BUSER --groups lpadmin,sudo $BUSER
# create an ubuntu user
# PASS=`pwgen -c -n -1 10`
# PASS=ballon
# Change password for user balloon
RUN echo "balloon:lmdpocpetit" | chpasswd $BUSER
#

RUN echo `date` > /etc/build.date

# LOG AND PID SECTION
RUN mkdir -p 	/var/log/desktop                            \
        	/var/run/desktop                            \
        	/composer/run

COPY etc/cups /etc/cups
RUN  chown -R lp:root /etc/cups/ppd /etc/cups/printers.conf
USER root

CMD /docker-entrypoint.sh

# expose cupsd tcp port
EXPOSE 631 

