The following files are duplicated between the 3 base docker images
(xenon-alpine-base, xenon-phusion-base, and xenon-torque):

- ``authorized_keys``
- ``id_rsa``
- ``id_rsa.pub``
- ``id_dsa``
- ``id_dsa.pub``
- (``this README.md``)

The originals can be found in the ``xenon-docker-images`` repository at:
``https://github.com/NLeSC/xenon-docker-images/unsafe-ssh-keys``.

The duplicates are located in:

1. the Docker context of the docker containers mentioned above, e.g.
``xenon-alpine-base/.ssh/authorized_keys``.
1. ``/home/xenon/.ssh`` inside the built Docker image.

Since the key files include private keys (which should normally remain secret),
it is not advised to use these keys for anything that should remain private.
