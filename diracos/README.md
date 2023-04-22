# Dirac setup companion

To run Python tests against the DIRAC container you need to use docker compose to fix the hostname resolution.

```shell
docker-compose run -ti test bash -l
pytest test_submit.py
# ====================================================================== test session starts =======================================================================
# platform linux -- Python 3.9.15, pytest-7.2.1, pluggy-1.0.0
# rootdir: /src
# plugins: hypothesis-6.64.0
# collected 1 item                                                                                                                                                 

# test_submit.py .                                                                                                                                           [100%]

# ================================================================== 1 passed in 77.06s (0:01:17) ==================================================================
```

To run tests from another repo, copy the Dockerfile and docker-compose.yml to the other repo and run the tests from there with

```shell
docker-compose run -ti test 'pip install -e .[dev] && pytest -m "dirac"'
```
