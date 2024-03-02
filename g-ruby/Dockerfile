FROM ruby:3.0
WORKDIR /app
COPY . /app
RUN bundle install
EXPOSE 8086
CMD ["bundle", "exec", "rackup", "-o", "0.0.0.0", "-p", "8086"]
