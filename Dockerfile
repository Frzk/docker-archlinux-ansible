# Build Archlinux image.

FROM archlinux/base:latest
LABEL maintainer="François KUBLER"

RUN pacman -Syu --noconfirm \
 && pacman -S --noconfirm \
    git \
    python-pip

RUN pip install --upgrade setuptools \
 && pip install wheel \
 && pip install ansible

RUN mkdir -p /etc/ansible
ADD hosts /etc/ansible

ENV ANSIBLE_FORCE_COLOR 1

ENTRYPOINT ["/lib/systemd/systemd"]
