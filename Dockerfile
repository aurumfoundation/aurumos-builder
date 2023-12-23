##
# NAME             : nlhomme/archiso-builder
# TO_BUILD         : docker build --rm -t nlhomme/archiso-builder:latest .
# TO_RUN           : docker run --rm -v /tmp:/tmp -t -i --privileged nlhomme/archiso-builder:latest
##

FROM library/archlinux:latest
MAINTAINER aurumfoundation (https://aurumfoundation.pp.ua)

#Sync packages databases
RUN pacman -Sy

#Install git and archiso
RUN pacman -S git archiso --noconfirm

#Copy the build script and allow him to be executed
COPY files/buildscript.sh root/

#Place the terminal in the home folder
RUN ["chmod", "+x", "root/buildscript.sh"]

ENTRYPOINT ["./root/buildscript.sh"]

