# Build Archlinux image.

FROM archlinux/archlinux:latest
#FROM archlinux/archlinux:base-20210124.0.14185
LABEL maintainer="François KUBLER"

RUN pacman -Sy --noconfirm \
    archlinux-keyring \
 && pacman -Syu --noconfirm \
 && pacman -Sy --noconfirm \
    git \
    python-pip
#RUN pacman -Sy --noconfirm \
#    git \
#    python-pip

RUN python3 -m pip install --upgrade pip \
 && python3 -m pip install --upgrade setuptools \
 && python3 -m pip install wheel ansible molecule[docker,lint]

# Make sure /sbin/init points to /usr/lib/systemd/systemd
# so that testinfra detects the container as 'systemd'.
RUN ln -s /usr/lib/systemd/systemd /sbin/init

RUN mkdir -p /etc/ansible
ADD hosts /etc/ansible

ENTRYPOINT ["/lib/systemd/systemd"]
