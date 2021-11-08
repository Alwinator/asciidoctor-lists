FROM asciidoctor/docker-asciidoctor
RUN mkdir /work
WORKDIR /work
COPY . .
RUN gem build asciidoctor-lists.gemspec
RUN mv asciidoctor-lists-*.gem asciidoctor-lists.gem
RUN gem install asciidoctor-lists.gem
CMD ["/bin/bash"]