# Dirac client

Container image with [DIRAC client](https://dirac.readthedocs.io/en/latest/UserGuide/GettingStarted/InstallingClient/index.html).

Should be used together with [dirac](../dirac) server inside a docker compose file.

## Run

To run Python tests against the DIRAC container you need to use docker compose to fix the hostname resolution.

```shell
docker-compose run -ti test 'dirac-proxy-init -g dirac_user && pytest test_submit.py'
# ====================================================================== test session starts =======================================================================
# platform linux -- Python 3.9.15, pytest-7.2.1, pluggy-1.0.0
# rootdir: /src
# plugins: hypothesis-6.64.0
# collected 1 item                                                                                                                                                 

# test_submit.py .                                                                                                                                           [100%]

# ================================================================== 1 passed in 77.06s (0:01:17) ==================================================================
```

## Build & push

```shell
docker build -t ghcr.io/xenon-middleware/diracclient:8.0.18 .
```

```shell
docker push ghcr.io/xenon-middleware/diracclient:8.0.18
docker tag ghcr.io/xenon-middleware/diracclient:8.0.18 ghcr.io/xenon-middleware/diracclient:latest
docker push ghcr.io/xenon-middleware/diracclient:latest
```