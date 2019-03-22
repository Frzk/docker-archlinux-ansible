# Build Archlinux image.

FROM archlinux/base:latest
LABEL maintainer="François KUBLER"

RUN pacman -Sy --noconfirm \
    archlinux-keyring \
 && pacman -Syu --noconfirm \
 && pacman -Sy --noconfirm \
    git \
    python-pip

RUN pip install --upgrade setuptools \
 && pip install wheel \
 && pip install ansible

# Make sure /sbin/init points to /usr/lib/systemd/systemd
# so that testinfra detects the container as 'systemd'.
RUN ln -s /usr/lib/systemd/systemd /sbin/init

RUN mkdir -p /etc/ansible
ADD hosts /etc/ansible

ENV ANSIBLE_FORCE_COLOR 1

ENTRYPOINT ["/lib/systemd/systemd"]
