#
# copyright 2016 MDS Technology co., ltd.
#
# licensed under the apache license, version 2.0 (the "license");
# you may not use this file except in compliance with the license.
# you may obtain a copy of the license at
#
#      http://www.apache.org/licenses/license-2.0
#
# unless required by applicable law or agreed to in writing, software
# distributed under the license is distributed on an "as is" basis,
# without warranties or conditions of any kind, either express or implied.
# see the license for the specific language governing permissions and
# limitations under the license.
#
from buildpack-deps:trusty
maintainer yoonki <yoonki@mdstec.com>
#ENV debian_frontend noninteractive

RUN apt-get update && apt-get -yqq install \
        software-properties-common \
        python-software-properties \
        net-tools \
        iputils-ping \
        openssh-server \
        sudo \
        bash-completion \
        vim \
        gawk diffstat unzip texinfo gcc-multilib build-essential chrpath socat cpio \
		libsdl1.2-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir /var/run/sshd
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

RUN useradd -m ubuntu -s /bin/bash && echo "ubuntu:ubuntu" | chpasswd && adduser ubuntu sudo

RUN curl https://storage.googleapis.com/git-repo-downloads/repo > /usr/local/bin/repo \
    && chmod +x /usr/local/bin/repo

EXPOSE 22

ENV TERM=xtrem-color

CMD ["/usr/sbin/sshd", "-D"]

