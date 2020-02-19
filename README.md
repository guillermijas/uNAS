# uNAS

This project's purpose is to get all the new posts from https://puya.moe and decript each post's 720p mega.nz link.

## Run (Local)

Install required gems with 

```bash
$ bundle install
```

Then, run server

```bash
$ puma
```

And that's all! Just go to http://localhost:3000 and start using it.

## Run (Docker compose)

```bash
$ docker-compose up --build
```

## Link decryption

The "Add to JDownloader" button is quite easy to bypass. In the same page, we can find the
encrypted link and its key, which is the same as the IV. We also know that the algorithm is
AES-128-CBC, so we don't need anything else. To decrypt a link, just use:

```bash
$ CIPHERED_LINK="3r4f++n1UOA7z7JayOYvobp3........uBpjg1Y8uylACMc0cmLGpMRKU6MiLrBHdOHoLLk04="
$ KEY="323932383232....3032303830333831"
$ echo -n "$CIPHERED_LINK" | openssl enc -d -AES-128-CBC -nosalt -nopad -base64 -A -K ${KEY} -iv ${KEY}`
```