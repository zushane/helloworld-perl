FROM        perl:5.32.1-slim

LABEL       maintainer="shane doucette <sd@zu.com>"

RUN         cpanm Module::Build Test::More

CMD         ["/bin/echo" "This container is intended to be used as a test base, and should generally be instantiated from within a Jenkinsfile."]
