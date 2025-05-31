# cayman

*CA Man*ager. No one knows *y*. `cayman` is a shell script
that acts as a wrapper around OpenSSL to manage, sign and revoke CAs and
certificates in a semi-standardized way.

## Quickstart

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
  -v                Show cayman's version

Valid commands are:
  init              Initialise the specified CA
  reinit            Reissue the specified CA (in case of expiry or similar)
  sign [<file>]     Sign a supplied *.csr file (use - for STDIN) or \$CSR
  list              List all signed certificates with their serial and validity
  list-revoked      List all revoked certificates
  revoke <serial>   Revoke the certificate matching <serial>
  gencrl            Regenerate a CA's CRL
  getca             Output the CA certificate
  expires <days>    Print certificates that will have been expired after <days>
  check <c> <w>     Nagios-style check for expires after <c> or <w> days
  metrics           Output Prometheus-style metrics
  getcert <serial>  Output the certificate matching <serial>
  getchain <serial> Output a certificate chain for <serial>
  help              Show this help
  version           Show cayman's version
```

Note that `expires` outputs certificates that will have been expired after
`<days>` days from now, one per line with the following tab-separated fields:
email address, serial, subject and expiry date. If the certificate has no
associated email address, the email address of the CA will be output instead.
This format is intentionally not very readable, unless you are a machine or a
script.

## Passwords
For insecure setups, `cayman` can read the passwords for the CAs from the
environment. Passwords can be set in the form of `$CAPWD_<intermediate>` (use
`$CAPWD_Root` for the Root CA).

## OCI container (Podman, Docker, etc)

The supplied `Containerfile`s will create a container that contains `cayman` as
well as lighttpd, which is configured to serve out all CA certficates and
revocation lists for the cayman-managed CAs at port 80. cayman itself will
operate on a volume, which will be preserved in case the container goes down or
gets an update. An URL pointing to the container can be used as the `URL_PRE`
used by cayman to construct the revocation list URLs. At port 8080, lighttpd
serves out the ouput of `cayman metrics`.

You can build the container with something like:  
`% buildah bud -t cayman ./Containerfile.Linux`  

Alternatively, pull the image from the [GitHub Container
Registry](https://github.com/FST777/cayman/pkgs/container/cayman) (available
for Linux and FreeBSD, amd64 and arm64):

`% podman pull ghcr.io/fst777/cayman`  

You can then run the container with:  
`% podman run -d --env-file environment --name caycnt cayman`  

The `--env-file environment` flag is optional and could point to a file (here
named `environment`) that contains configuration normally managed in
`cayman.conf`:
```
CA_PREF=Cayman
CA_CNTR=XZ
CA_PROV=Some Region
CA_CITY=Some City
CA_ORGA=Some Organization
CA_UNIT=A Unit
CA_MAIL=email@example.com
URL_PRE=https://example.com/ssl
```
This file can also contain passwords to the CAs as described above.

With a running cayman container, you can launch regular `cayman` commands using
something like:  
`% podman exec -t caycnt cayman init`  
`% podman exec -t caycnt cayman -i HTTPS init`  
`% podman exec -te CSR=$(cat request.csr) caycnt cayman -i HTTPS sign`  
`% podman exec -t caycnt cayman -i HTTPS list`  
`% podman exec -t caycnt cayman -i HTTPS getcert 01`  
`% podman exec -t caycnt cayman -i HTTPS revoke 01`  

## Thanks

Credits should go to two of my previous employers:
- The first versions of this were quickly hacked together for internal use at
  Spil Games. They later graciously agreed for it to be released as Open
  Source software.
- Again for internal use, cayman was containerized and fleshed out a bit at
  InterNLnet.

## License

Like OpenSSL, this software is licensed under the terms of the [Apache License (v2.0)](LICENSE)
