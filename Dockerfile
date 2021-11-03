FROM asciidoctor/docker-asciidoctor
RUN gem install asciidoctor-lists
RUN mkdir /work
WORKDIR /work
CMD ["/bin/bash"]