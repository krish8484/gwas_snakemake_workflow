FROM conda/miniconda3

LABEL maintainer="Krish Agarwal <akrish136@gmail.com>"

RUN apt-get -qq update && \
	apt-get -qq install \
	wget \
	unzip \
	gawk \
    gcc

RUN mkdir /opt/plink
RUN wget http://s3.amazonaws.com/plink1-assets/dev/plink_linux_x86_64.zip && \
        unzip -d /opt/plink plink_linux_x86_64.zip && \
        rm plink_linux_x86_64.zip

RUN ln -s /opt/plink/plink /usr/local/bin/

COPY ./requirements.txt /opt/requirements.txt

RUN pip install -r /opt/requirements.txt

COPY ./scripts/* /usr/local/bin/