FROM python:3.6.9-stretch

# ---------------------------------------------------------------------------------------------------------------------
# Install Java
RUN apt-get update && apt-get install openjdk-8-jdk -y && apt-get clean

# ---------------------------------------------------------------------------------------------------------------------
# Install Cytomine python client
RUN git clone https://github.com/cytomine-uliege/Cytomine-python-client.git
RUN cd /Cytomine-python-client && git checkout tags/v2.3.0.poc.1 && pip install .
RUN rm -r /Cytomine-python-client

# ---------------------------------------------------------------------------------------------------------------------
# Install Neubias-W5-Utilities (annotation exporter, compute metrics, helpers,...)
RUN apt-get update && apt-get install libgeos-dev -y && apt-get clean
RUN git clone https://github.com/Neubias-WG5/neubiaswg5-utilities.git && \
       cd /neubiaswg5-utilities/ && git checkout tags/v0.8.3 && pip install .

# install utilities binaries
RUN chmod +x /neubiaswg5-utilities/bin/*
RUN cp /neubiaswg5-utilities/bin/* /usr/bin/

# cleaning
RUN rm -r /neubiaswg5-utilities

# ---------------------------------------------------------------------------------------------------------------------
# Local icy environnment
ADD ij /app/ij
ADD lib /app/lib
ADD plugins /app/plugins
ADD update /app/update
ADD icy.jar /app/icy.jar
ADD resources.jar /app/resources.jar
ADD proto.protocol /app/proto.protocol

ADD wrapper.py /app/wrapper.py
ADD descriptor.json /app/descriptor.json

ENTRYPOINT ["python", "/app/wrapper.py"]