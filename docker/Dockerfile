
ARG PYTHON_VERSION=3.11
ARG ALPINE_VERSION=3.19

FROM python:${PYTHON_VERSION} as builder

RUN pip install build; mkdir src

# COPYS SRC AND PYPROJECT
COPY pyproject.toml README.rst CONTRIBUTORS.rst CHANGES.rst /
COPY src /src

RUN python -m build

# TODO: MOVE TO ALPINE.
FROM alpine:${ALPINE_VERSION}

LABEL org.opencontainers.image.source=https://github.com/FernandoAFS/unoserver
LABEL org.opencontainers.image.description="unoserver. Using LibreOffice as a server for converting documents."
LABEL org.opencontainers.image.licenses=MIT

# BUILD FROM THIS IMAGE

ARG USER=unouser
ARG UID=899

# GOT FROM THE FIND_UNO SCRIPT
ARG LIBREOFFICE_PYTHON=/usr/bin/python3

RUN set -eux; \
    apk add --no-cache libreoffice su-exec tini; \
    addgroup --gid ${UID} ${USER}; \
    adduser --disabled-password --gecos "" --home "/home/${USER}" --ingroup ${USER} --uid ${UID} ${USER}; \
    wget https://bootstrap.pypa.io/get-pip.py; \
    ${LIBREOFFICE_PYTHON} get-pip.py --break-system-packages;

COPY --from=builder /dist/*.whl dist/

# BASE INSTALL
RUN set -eux; \
    ${LIBREOFFICE_PYTHON} -m pip install --break-system-packages dist/*.whl; \
    rm dist/*.whl get-pip.py

COPY docker/entrypoint.sh ./

EXPOSE 2003
#HEALTHCHECK unoping

ENV USER=${USER}
ENV LIBREOFFICE_PYTHON=${LIBREOFFICE_PYTHON}

ENTRYPOINT ["./entrypoint.sh"]
CMD [ "unoserver" ]
