# Use a base image with necessary build tools
FROM ubuntu:latest

# Install dependencies
RUN apt-get update && \
    apt-get install -y \
        build-essential \
        git \
        libncurses5-dev \
        flex \
        bison \
        libssl-dev \
        gnupg \
        wget \
        bc \
        libelf-dev \
        busybox-static \
        xorriso \
        nasm \
        mtools

# Clone the Linux kernel repository
RUN git clone --depth 1 https://github.com/torvalds/linux.git /github/workspace/linux

# Build the Linux kernel
WORKDIR /github/workspace/linux
RUN make defconfig && \
    make -j$(nproc) && \
    make INSTALL_PATH=/github/workspace/system/boot/kernel install

# Clone Busybox repository
RUN git clone --depth 1 https://github.com/mirror/busybox.git /github/workspace/busybox

# Build Busybox
WORKDIR /github/workspace/busybox
RUN make defconfig && \
    make -j$(nproc) && \
    make CONFIG_PREFIX=/github/workspace/system/ install

# Clone Limine bootloader repository
RUN git clone --depth 1 https://github.com/limine-bootloader/limine.git /github/workspace/limine

# Build Limine bootloader
WORKDIR /github/workspace/limine
RUN make

# Create minimal Linux distro structure
RUN mkdir -p /github/workspace/system/boot/configs/
COPY entry_point.sh /entry_point.sh
COPY limine.cfg /github/workspace/system/boot/configs/

# Cleanup unnecessary files
RUN rm -rf /github/workspace/linux /github/workspace/busybox /github/workspace/limine

# Set entry point
ENTRYPOINT ["/entry_point.sh"]
