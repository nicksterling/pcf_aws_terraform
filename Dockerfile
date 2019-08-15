FROM ubuntu:18.04 as INSTALL
RUN apt-get update && apt-get install -y unzip wget curl

WORKDIR /opt/pivotal

# We need to run 0.11 specifically for compatability with the PCF terraform scripts
RUN wget https://releases.hashicorp.com/terraform/0.11.14/terraform_0.11.14_linux_amd64.zip
RUN unzip terraform*

# Download the Pivnet CLI
RUN wget -q -O pivnet https://github.com/pivotal-cf/pivnet-cli/releases/download/v0.0.60/pivnet-linux-amd64-0.0.60
RUN chmod a+x pivnet

# Download the Ops Manager CLI
RUN wget -q -O om https://github.com/pivotal-cf/om/releases/download/3.1.0/om-linux-3.1.0 
RUN chmod a+x om

# Download the CF CLI
RUN curl -L "https://packages.cloudfoundry.org/stable?release=linux64-binary&version=6.46.0" | tar -zx
RUN rm LICENSE NOTICE

FROM ubuntu:18.04 as BASE
# RUN apk add --no-cache jq bash openssl vim ca-certificates ruby-dev musl-dev gcc make g++
RUN apt-get update && apt-get install -y build-essential vim jq ruby-dev g++ curl
RUN gem install cf-uaac --no-rdoc --no-ri
COPY --from=INSTALL /opt/pivotal/* /usr/local/bin/
COPY ./pcf-aws /usr/local/bin/pcf-aws
COPY ./csv2json.jq /root/csv2json.jq
WORKDIR /root