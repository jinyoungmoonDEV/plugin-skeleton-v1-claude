ARG ECR_REGISTRY
FROM ${ECR_REGISTRY}/python-core:2.0

ARG PACKAGE_VERSION

ENV PYTHONUNBUFFERED 1
ENV SPACEONE_PORT 50051
ENV SERVER_TYPE grpc
ENV PKG_DIR /tmp/pkg
ENV SRC_DIR /tmp/src
ENV PACKAGE_VERSION=$PACKAGE_VERSION

RUN --mount=type=secret,id=code_artifact_url \
    pip config set global.index-url $(cat /run/secrets/code_artifact_url)

RUN apt update && apt upgrade -y

COPY pkg/*.txt ${PKG_DIR}/
RUN pip install --upgrade pip && \
    pip install --upgrade -r ${PKG_DIR}/pip_requirements.txt && \
    pip install --upgrade cloudops-api && \
#    pip install --upgrade --pre cloudops-inventory                   # Inven Collector
#    pip install --upgrade --pre cloudops-identity                    # Account Collector
#    pip install --upgrade --pre cloudops-cost-analysis               # Cost Datasource

COPY src ${SRC_DIR}
WORKDIR ${SRC_DIR}
RUN pip install --no-cache-dir . && rm -rf /tmp/*

EXPOSE ${SPACEONE_PORT}

ENTRYPOINT ["spaceone"]
CMD ["run", "plugin-server", "plugin"]