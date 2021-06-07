# Build Archlinux image.

FROM archlinux/archlinux:latest
LABEL maintainer="François KUBLER"

# TEMP-FIX until hub.docker.com fix their sh*t.
RUN patched_glibc=glibc-linux4-2.33-4-x86_64.pkg.tar.zst && \
 curl -LO "https://repo.archlinuxcn.org/x86_64/$patched_glibc" && \
 bsdtar -C / -xvf "$patched_glibc"
# /TEMP-FIX until hub.docker.com fix their sh*t.

RUN pacman -Sy --noconfirm \
    archlinux-keyring \
 && pacman -Syu --noconfirm \
 && pacman -Sy --noconfirm \
    sudo \
    git \
    python-pip

RUN pip3 install --upgrade pip \
 && pip3 install --upgrade setuptools \
 && pip3 install wheel ansible molecule[docker,lint]

# Make sure /sbin/init points to /usr/lib/systemd/systemd
# so that testinfra detects the container as 'systemd'.
RUN ln -sfn /usr/lib/systemd/systemd /sbin/init

RUN mkdir -p /etc/ansible
ADD hosts /etc/ansible

ENTRYPOINT ["/lib/systemd/systemd"]
