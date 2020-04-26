# Caritas

Welcome to your new Hanami project!

## Setup

How to run tests:

```
% bundle exec rspec
```

How to run the development server:

```
% bundle exec hanami server
```

Or if you prefer to run it in a docker container
```
docker-compose up --build
```

How to prepare (create and migrate) DB for `development` and `test` environments:

```
% bundle exec hanami db prepare

% HANAMI_ENV=test bundle exec hanami db prepare
```
