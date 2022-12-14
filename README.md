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
melange build 100-libxml2.yaml --keyring-append local-melange.rsa.pub --signing-key local-melange.rsa
```
### Using Google Cloud Builder

Compiling the JDK is CPU intensive.  Running on a Mac via Docker was very slow, over 1.5 hours for the openJDK itself and then hangs.  There is also a `cloudbuild.yaml` that can be used to build packages and store the results in a bucket.

#### Setup

You will need to
- create a GCS bucket
- enable the Google Cloud Build API
- enable Google Secrets Manager API
- create two secrets containing public and private melange signing keys.  I used the Google Secrets Manager console but you could use a CLI.  In this example I called them `jr-dev-melange-public` and `jr-dev-melange-private`

- add IAM policy bindings so Google Cloud Build service account can retrieve secrets
```sh
gcloud beta secrets add-iam-policy-binding jr-dev-melange-private \
  --member=serviceAccount:1017061756145@cloudbuild.gserviceaccount.com  \
  --role=roles/secretmanager.secretAccessor

gcloud beta secrets add-iam-policy-binding jr-dev-melange-public \
  --member=serviceAccount:1017061756145@cloudbuild.gserviceaccount.com  \
  --role=roles/secretmanager.secretAccessor
```
- modify the `cloudbuild.yaml` to reflect the name of your GCS bucket and public / private key secret names
- submit the build
```sh
gcloud builds submit
```

### Building an image

Using APKO we can build an image for the JDK.

Docker
```sh
docker run --platform linux/arm64 --rm -v ${PWD}:/work distroless.dev/apko build /work/jdk17-apko.yaml jdk:test /work/jdk-test.tar --build-arch amd64 --keyring-append local-melange.rsa.pub
```

Linux
```sh
apko build jdk17-apko.yaml jdk:test jdk-test.tar --keyring-append local-melange.rsa.pub
```

Using docker you can test the image...
```sh
docker load < jdk-test.tar
docker run -ti jdk:test bash
```

Execute a Java command...
```sh
java --version
```

Or test compiling and running a Java application...
```sh
cat >HelloWolfi.java <<EOL
class HelloWolfi
{
    public static void main(String args[])
    {
        System.out.println("Hello Wolfi users!");
    }
}
EOL

javac HelloWolfi.java
java HelloWolfi
```