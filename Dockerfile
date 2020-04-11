FROM alpine:3.11.5 as builder
COPY . /hefur

RUN apk add make g++ cmake gnutls-dev zlib-dev libarchive-dev protobuf-dev xz-dev bison flex docbook-xsl

WORKDIR /hefur/manual
RUN make

RUN mkdir /hefur/build
WORKDIR /hefur/build

RUN CC=gcc CXX=g++ cmake -DCMAKE_INSTALL_PREFIX=/usr ..
RUN DESTDIR=hefur-out make install

FROM alpine:3.11.5
RUN apk add gnutls protobuf nettle xz-libs libstdc++ libgcc
COPY --from=builder /hefur/build/hefur-out /

#Http
EXPOSE 6969/tcp
#Https
EXPOSE 6970/tcp
EXPOSE 6969/udp

CMD ["/usr/bin/hefurd"]
