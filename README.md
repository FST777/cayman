# cayman

*CA Man*ager. No one knows where the *y* came from. `cayman` is a shell script
that acts as a wrapper around OpenSSL to manage, sign and revoke CAs and
certificates in a semi-standardized way.

# Set up

Put `cayman`, `cayman.conf` and `openssl.conf` somewhere together and edit
`cayman.conf` to reflect the details of your operation.

As per the usage, initialize your first top-level CA with `cayman init`.

## Usage

```
Usage: cayman [ options ... ] [COMMAND] [arguments]

Valid options are:
  -c <config-file>  Specify the OpenSSL configuration to work with
                    (default: ./cayman-openssl.cnf)
  -d <folder>       Specify the folder to work on (default: ${HOME}/ssl/CA/)
                    This folder will hold the Root CA and intermediate
                    CAs as sub-folders.
  -i <intermediate> Work on <intermediate> (instead of the Root CA)
  -h                Show this help

Valid commands are:
  init              Initialise the specified CA
  reinit            Reissue the specified CA (in case of expiry or similar)
  sign [<file>]     Sign a supplied *.csr file (use - for STDIN) or \$CSR
  list              List all signed certificates with their serial and validity
  list-revoked      List all revoked certificates
  revoke <serial>   Revoke the certificate matching <serial>
  gencrl            Regenerate a CA's CRL
  echo <serial>     Output the certificate matching <serial>
  help              Show this help
```

## Docker, buildah/podman, container stuffs

The supplied `Dockerfile` will create a container that contains `cayman` as
well as nginx, which is configured to serve out all CA certficates and
revocation lists for the cayman-managed CAs. cayman itself will operate on a
volume, which will be preserved in case the container goes down or gets an
update. An URL pointing to nginx in the container can be used as the `URL_PRE`
used by cayman to construct the revocation list URLs.

You can build the container with something like:  
`% buildah bud -t cayman .`  
or:  
`# docker build -t cayman .`

Alternatively, pull the image from the [Docker Hub](https://hub.docker.com/r/fst777/cayman):  
`% podman pull fst777/cayman`  
or:  
`# docker pull fst777/cayman`

You can then run the container with:  
`% podman run -d --env-file environment --name caycnt cayman`  
or:  
`# docker run -d --env-file environment --name caycnt cayman`

The `--env-file environment` flag is optional and could point to a file (here
named `environment`) that contains configuration normally managed in
`cayman.conf`:
```
CA_PREF=Cayman
CA_CNTR=XZ
CA_PROV=Atlantic Ocean
CA_CITY=Mid-Atlantic Ridge
CA_ORGA=DivergentBoundary Corp
CA_UNIT=Black Smokers
CA_MAIL=black.smokers@dbc.int
URL_PRE=https://dbc.int/ssl
```

With a running cayman container, you can launch regular `cayman` commands using
something like:  
`% podman exec -t caycnt cayman init`  
`% podman exec -t caycnt cayman -i HTTPS init`  
`% podman exec -te CSR=$(cat request.csr) caycnt cayman -i HTTPS sign`  
`% podman exec -t caycnt cayman -i HTTPS list`  
`% podman exec -t caycnt cayman -i HTTPS echo 01`  
`% podman exec -t caycnt cayman -i HTTPS revoke 01`  
or:  
`# docker exec -ti caycnt cayman init`  
`# docker exec -ti caycnt cayman -i HTTPS init`  
`# docker exec -tie CSR=$(cat request.csr) caycnt cayman -i HTTPS sign`  
`# docker exec -ti caycnt cayman -i HTTPS list`  
`# docker exec -ti caycnt cayman -i HTTPS echo 01`  
`# docker exec -ti caycnt cayman -i HTTPS revoke 01`

## License

Like OpenSSL, this software is licensed under the terms of the [Apache License (v2.0)](LICENSE)
