FROM docker.io/library/ruby:alpine
RUN apk add g++ musl-dev make libstdc++ git tzdata
WORKDIR /src
COPY Gemfile .
RUN bundle install
RUN bundle lock --add-platform x86_64-linux
EXPOSE 80
ENTRYPOINT ["bundle", "exec", "jekyll", "serve", "--host=0", "-w"]
