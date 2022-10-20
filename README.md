# Building a Wolfi JDK
 
This repo contains a number of melange configs for building a JDK plus its Linux package dependencies.
 
The packages are prefixed with a number to help build in order.
 
This is a temporary repository that will be deprecated once packages are accepted into https://github.com/wolfi-dev/os.  It's use is primarily for early testing of a building and using a Wolfi JDK
## Prerequisites
 
- Docker if running on a Mac
- [melange](https://github.com/chainguard-dev/melange/)
- [apko](https://github.com/chainguard-dev/apko/)

Clone this repository and generate a local melange signing key pair

Docker
```sh
docker run --rm -v "${PWD}":/work cgr.dev/chainguard/melange keygen local-melange.rsa
```

Linux
```sh
melange keygen local-melange.rsa
```

## Building

### With the script

There is a script `./build.sh` you can run in the root of the folder which will build the melange configs in order.  You can also pass a number to build from if you don't want to rebuild from the start.  I.e. `./build.sh 900`.  This script assumes running on a Mac so will need to be modified to remove the use of docker if you are running on Linux.
 

### Without the script
 
If you want to build an individual package you can run for example...

Docker
```sh
docker run --platform linux/arm64 --privileged -v "$PWD":/work cgr.dev/chainguard/melange build /work/100-libxml2.yaml --arch amd64 --keyring-append local-melange.rsa.pub --signing-key local-melange.rsa
```

Linux
```sh
melange build /work/100-libxml2.yaml --keyring-append local-melange.rsa.pub --signing-key local-melange.rsa
```
