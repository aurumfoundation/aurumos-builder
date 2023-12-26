# Use a base image with necessary build tools
FROM ubuntu:latest
MAINTAINER aurumfoundation

# Install dependencies
RUN apt-get update && \
    apt-get install -y build-essential git

# Clone the Linux kernel repository
RUN git clone --depth 1 https://github.com/torvalds/linux.git /linux

# Build the Linux kernel
WORKDIR /linux
RUN make defconfig && \
    make -j$(nproc) && \
    make INSTALL_PATH=/system/boot/kernel install

# Clone Busybox repository
RUN git clone --depth 1 https://github.com/mirror/busybox.git /busybox

# Build Busybox
WORKDIR /busybox
RUN make defconfig && \
    make -j$(nproc) && \
    make CONFIG_PREFIX=/system/ install

# Clone Limine bootloader repository
RUN git clone --depth 1 https://github.com/limine-bootloader/limine.git /limine

# Build Limine bootloader
WORKDIR /limine
RUN make

# Create minimal Linux distro structure
RUN mkdir -p /system/boot/configs/
COPY entry_point.sh /entry_point.sh
COPY limine.cfg /system/boot/configs/

# Cleanup unnecessary files
RUN rm -rf /linux /busybox /limine

# Set entry point
ENTRYPOINT ["/entry_point.sh"]
