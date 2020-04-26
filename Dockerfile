FROM ruby:2.5-alpine

RUN apk add --no-cache build-base postgresql postgresql-dev libpq

WORKDIR /app
COPY . /app
RUN bundle install -j $(nproc)

EXPOSE 2300
ENTRYPOINT ["bundle", "exec"]
