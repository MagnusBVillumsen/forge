FROM data.forgejo.org/oci/debian:trixie
RUN apt update
RUN apt install libssl-dev ca-certificates -y
COPY target/x86_64-unknown-linux-gnu/release/forge /usr/local/bin/forge
