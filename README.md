# Building a Wolfi JDK 

This repo contains a number of melange configs for building a JDK plus it's Linux package dependencies.

The packages are prefixed with a number to help build in order.

There is a script `./build.sh` you can run in the root of the folder which will build teh melange configs in order.  You can also pass a number to build from if you don't want to rebuild from the start.  I.e. `./build.sh 900`.  This script assums running on a Mac so will need to be modified to remove the use of docker if you are running on Linux.
