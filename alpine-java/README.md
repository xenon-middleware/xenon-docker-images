Docker image based off xenon-alpine-base that adds a Java JRE installation (openjdk 8).

Build with:

```bash
docker build --tag xenonmiddleware/alpine-java .
```

Run with:
```bash
docker run --user xenon --rm --interactive --tty xenonmiddleware/alpine-java bash
```

