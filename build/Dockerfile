
ARG ARG_UBI8_MIN_VERSION

FROM registry.access.redhat.com/ubi8-minimal:$ARG_UBI8_MIN_VERSION

###########################################################
#
# LABEL Mandatory for the Pipeline - DO NOT DELETE
#
###########################################################

LABEL name=airflow

###########################################################
#
# ENV Mandatory for the Pipeline - DO NOT DELETE
#
###########################################################

USER 0

###########################################################
#
# Custom ENV configuration
#
###########################################################

ARG ARG_AIRFLOW_VERSION
ARG ARG_DUMBINIT_VERSION
ARG ARG_PYTHON_VERSION

ENV TRUSTED_HOST=https://pypi.org/simple \
    PIP3_REPO="https://pypi.org/simple" \
    GITHUB_RELEASE_URL=https://github.com/ \
    AIRFLOW_VERSION=${ARG_AIRFLOW_VERSION} \
    PYTHON_VERSION=${ARG_PYTHON_VERSION} \
    DUMBINIT_VERSION=${ARG_DUMBINIT_VERSION} \
    AIRFLOW_USER_HOME_DIR=/home/airflow \
    AIRFLOW_EXTRAS="async,celery,postgres,virtualenv,pandas,github_enterprise,cncf.kubernetes"

ENV CONSTRAINT_URL="https://raw.githubusercontent.com/apache/airflow/constraints-${AIRFLOW_VERSION}/constraints-${PYTHON_VERSION}.txt" \
    AIRFLOW_HOME=/opt/airflow \
    PYTHONPATH="${PYTHONPATH}:${AIRFLOW_HOME}" \
    PATH="${AIRFLOW_USER_HOME_DIR}/.local/bin:${PATH}" \
    GUNICORN_CMD_ARGS="--worker-tmp-dir /dev/shm"

###########################################################
#
# System update with Standard & custom REPO
#
###########################################################

COPY /scripts/entrypoint_prod.sh /entrypoint.sh
COPY /repo/ubi.repo  /etc/yum.repos.d/ubi.repo
COPY /repo/centos-8.repo /etc/yum.repos.d/centos-8.repo
COPY /gpg /etc/pki/rpm-gpg

RUN set -eux \
\
    && microdnf repolist --disableplugin=subscription-manager \
    && microdnf upgrade --disableplugin=subscription-manager -y \
\
###########################################################
#
# System update with Standard & custom REPO
#
###########################################################
\
    && microdnf update --disableplugin=subscription-manager -y \
    && microdnf install -y --nobest --disableplugin=subscription-manager \
          ca-certificates \
          wget \
          gnupg \
          openssh-clients \
          freetds \
          freetds-devel \
          krb5-libs \
          krb5-devel \
          openldap-clients \
          openldap-devel \
          libffi \
          libffi-devel \
          libpq \
          libpq-devel \
          cyrus-sasl-lib \
          cyrus-sasl \
          cyrus-sasl-devel \
          openssl-devel \
          nodejs \
          redhat-lsb \
          postgresql \
          libsss_sudo \
          unixODBC-devel \
          glibc-all-langpacks \
          glibc-locale-source \
          redhat-lsb-core \
          libsqlite3x \
          unixODBC \
          mysql \
          mysql-libs \
          nc \
          python39 \
\
    && mkdir -pv "${AIRFLOW_USER_HOME_DIR}" \
    && groupadd -r --gid=1001 "airflow"  \
    && useradd -r --uid=1001 --gid=1001 -g "airflow" --home ${AIRFLOW_USER_HOME_DIR} --shell=/bin/bash airflow \
\
    && mkdir -pv "${AIRFLOW_HOME}" \
    && mkdir -pv "${AIRFLOW_HOME}/dags" \
    && mkdir -pv "${AIRFLOW_HOME}/logs" \
    && chown -R "airflow:root" "${AIRFLOW_USER_HOME_DIR}" "${AIRFLOW_HOME}" \
    && find "${AIRFLOW_HOME}" -executable -print0 | xargs --null chmod g+x \
    && find "${AIRFLOW_HOME}" -print0 | xargs --null chmod g+rw \
\
    && pip3 install -i ${PIP3_REPO} -U --no-cache-dir pip setuptools wheel \
    && pip3 install -i ${PIP3_REPO} --no-cache-dir apache-airflow[${AIRFLOW_EXTRAS}]==${AIRFLOW_VERSION} --constraint ${CONSTRAINT_URL} \
\
    && wget -O /usr/local/bin/dumb-init ${GITHUB_RELEASE_URL}/Yelp/dumb-init/releases/download/v${DUMBINIT_VERSION}/dumb-init_${DUMBINIT_VERSION}_x86_64 \
    && wget -O /usr/local/bin/dumb-init.sha256 ${GITHUB_RELEASE_URL}/Yelp/dumb-init/releases/download/v${DUMBINIT_VERSION}/sha256sums \
    && chmod +x /usr/local/bin/dumb-init \
\
    && chmod g=u /etc/passwd \
    && usermod -g 0 airflow -G airflow \
\
    && chmod +x /entrypoint.sh \
    && ln -s /usr/bin/python3 /usr/bin/python \
    && pip3 install -i ${PIP3_REPO} --upgrade requests \
\
###########################################################
#
# install custom python package
#
###########################################################
\
    && pip3 install -i ${PIP3_REPO}  pandas \
\
###########################################################
#
# cleanup / remove pkg
#
###########################################################
\
    &&  microdnf remove -y --disableplugin=subscription-manager \
          wget \
    &&  microdnf clean all --disableplugin=subscription-manager \
    && rm -rf /iron-scripts/

###########################################################
#
# Docker image configuration
#
###########################################################

WORKDIR ${AIRFLOW_HOME}

EXPOSE 8080

USER airflow

ENTRYPOINT ["/usr/local/bin/dumb-init", "--", "/entrypoint.sh"]

CMD []
