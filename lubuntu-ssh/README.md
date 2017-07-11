build Docker image with

```bash
docker build --tag lubuntu-ssh .
```

run with

```bash
# run interactive with...
docker run --interactive --tty --publish 10022:22 lubuntu-ssh
# ...or in the background with 
docker run --detach --publish 10022:22 lubuntu-ssh
# then login to the container with:
ssh -p 10022 xenon@localhost
```
