FROM haskell:9.6.3-slim
WORKDIR /app
COPY . .
RUN stack setup --install-ghc
RUN stack init
RUN stack build --copy-bins
EXPOSE 8091
CMD ["stack", "exec", "app"]
