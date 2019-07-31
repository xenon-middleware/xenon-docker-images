Base Docker image based off of [phusion base image](http://phusion.github.io/baseimage-docker/) which is used by other images for schedulers and filesystems which need to be tested by the Xenon library.

Build with:

```bash
docker build --tag xenonmiddleware/phusion-base .
```

Run with:
```bash
docker run --user xenon --rm --interactive --tty xenonmiddleware/phusion-base bash
```

