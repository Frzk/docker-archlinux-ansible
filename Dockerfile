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
    git \
    python-pip

RUN python3 -m pip install --upgrade pip \
 && python3 -m pip install --upgrade setuptools \
 && python3 -m pip install wheel ansible molecule[docker,lint]

# Make sure /sbin/init points to /usr/lib/systemd/systemd
# so that testinfra detects the container as 'systemd'.
RUN ln -s /usr/lib/systemd/systemd /sbin/init

RUN mkdir -p /etc/ansible
ADD hosts /etc/ansible

ENTRYPOINT ["/lib/systemd/systemd"]
