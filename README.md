# Cayman

*CA Man*ager. No one knows where the *y* came from. Cayman is a shell script
that acts as a wrapper around OpenSSL to manage, sign and revoke CAs and
certificates in a semi-standardized way.

# Set up

Put `cayman` and `cayman-openssl.cnf` somewhere together and edit
`cayman-openssl.cnf` to reflect the details of your operation (including the
URLs). If needed, edit the variables at the top of `cayman` to taste.

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
  sign              Sign a supplied *.csr file
  list              List all signed certificates with their serial and validity
  list-revoked      List all revoked certificates
  revoke <serial>   Revoke the certificate matching <serial>
  help              Show this help
```

## License

Like OpenSSL, this software is licensed under the terms of the [Apache License (v2.0)](LICENSE)
