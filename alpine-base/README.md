Base Docker image based off of [Linux Alpine](https://alpinelinux.org) which is used by other images for schedulers and filesystems which need to be tested by the Xenon library.

Build with:

```bash
cd alpine-base
docker build --tag xenonmiddleware/alpine-base .
```

Run with:
```bash
docker run --user xenon --rm --interactive --tty xenonmiddleware/alpine-base bash
```
