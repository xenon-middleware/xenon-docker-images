Docker container with webdav server, to run the xenon webdav adaptor integration tests against.

The Docker container has two users, each with two locations

1. ``xenon``, with password ``javagat``
    - read access at ``http://<hostname>/~xenon``
    - write access at ``http://<hostname>/~xenon/uploads``
1. anonymous
    - read access at ``http://<hostname>/downloads``
    - write access at ``http://<hostname>/uploads``

# Build with:

```bash
cd xenon-webdav
docker build -t nlesc/xenon-webdav .
```

# Run with:

```bash
docker run --detach --name=xenon-webdav --hostname xenon-webdav --publish 10080:80 nlesc/xenon-webdav

```

Login with username `xenon` and password `javagat`.

Test with following commands:

```bash
# install webdav command line client cadaver (http://www.webdav.org/cadaver/),
# for example on debian based systems: sudo apt install cadaver

# for basic authenticated read access
cadaver http://localhost:10080/~xenon
# or for basic authenticated write access
cadaver http://localhost:10080/~xenon/uploads
# or for anonymous write access
cadaver http://localhost:10080/uploads
# or for anonymous read access
cadaver http://localhost:10080/downloads
```

Example output for ``cadaver``:
```
Authentication required for DAV-upload on server `172.17.0.3':
Username: xenon
Password:
dav:/~xenon/> help
Available commands:
 ls         cd         pwd        put        get        mget       mput
 edit       less       mkcol      cat        delete     rmcol      copy
 move       lock       unlock     discover   steal      showlocks  version
 checkin    checkout   uncheckout history    label      propnames  chexec
 propget    propdel    propset    search     set        open       close
 echo       quit       unset      lcd        lls        lpwd       logout
 help       describe   about
Aliases: rm=delete, mkdir=mkcol, mv=move, cp=copy, more=less, quit=exit=bye
dav:/~xenon/> put Dockerfile
Uploading Dockerfile to `/~xenon/Dockerfile':
Progress: [=============================>] 100.0% of 962 bytes failed:
403 Forbidden
dav:/~xenon/> ls
Listing collection `/~xenon/': succeeded.
Coll:   .ssh                                   0  Jun 28 14:33
Coll:   filesystem-test-fixture                0  Jun 28 14:37
Coll:   uploads                                0  Jun 28 16:12
dav:/~xenon/>

```

Clean up the run

```bash
docker rm -f xenon-webdav
```
