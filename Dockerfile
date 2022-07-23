FROM ubuntu:20.04 as builder

RUN apt update && \
    apt install -y unzip wget make curl libnuma1 build-essential libffi-dev libffi7 libgmp-dev libgmp10 libncurses-dev libncurses5 libtinfo5 zlib1g-dev && \
    rm -rf /var/lib/apt/lists/*
    
RUN curl https://downloads.haskell.org/~ghcup/$(arch)-linux-ghcup -o /usr/bin/ghcup && \
    chmod +x /usr/bin/ghcup && \
    ghcup install stack && \
    ghcup install ghc
    
ARG HLEDGER_VERSION

RUN mkdir /hledger && cd /hledger && \
    wget https://github.com/simonmichael/hledger/archive/refs/tags/$HLEDGER_VERSION.tar.gz && \
    tar --strip-component=1 -xf $HLEDGER_VERSION.tar.gz && \
    export LANG=C.UTF-8 && \
    export PATH="$HOME/.cabal/bin:$HOME/.ghcup/bin:$PATH" && \
    stack install --allow-different-user hledger && \
    stack install --allow-different-user hledger-web

#
# Final Image
#

FROM ubuntu:20.04

COPY --from=builder /root/.local/bin/hledger /usr/bin/hledger
COPY --from=builder /root/.local/bin/hledger-web /usr/bin/hledger-web
COPY --from=builder /hledger/docker/start.sh /start.sh

ENV LC_ALL C.UTF-8
EXPOSE 5000 5001

CMD ["/start.sh"]
