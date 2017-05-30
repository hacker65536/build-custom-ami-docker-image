#!/bin/bash


git clone https://github.com/aws/amazon-linux-docker-images.git
cd amazon-linux-docker-images
git checkout ${AMZLINUX_CONTAINER_REVISION}
cat Dockerfile


cat <<'EOF' > Dockerfile
FROM scratch
ENV PACKER_VERSION=0.9.0
ENV TERRAFORM_VERSION=0.9.5
ADD amzn-container-minimal-2017.03.0.20170401-x86_64.tar.xz /
RUN yum install -y jq python27-devel openssl-devel openssh-clients libffi-devel gcc unzip; yum clean all
RUN curl -s -O https://bootstrap.pypa.io/get-pip.py && python get-pip.py && rm get-pip.py && pip install ansible && pip install awscli
RUN curl -s -O https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip && \
    unzip packer_${PACKER_VERSION}_linux_amd64.zip && \
    mv ./packer /usr/local/bin/ &&  rm ./packer_${PACKER_VERSION}_linux_amd64.zip 
RUN curl -s -O https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip  && \
    mv ./terraform /usr/local/bin/ && rm ./terraform_${TERRAFORM_VERSION}_linux_amd64.zip
CMD ["/bin/bash"]
EOF
