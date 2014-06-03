# tpnoted (Ruby)

tpnoted is a simple service for the storage and retrieval of encrypted notes.
Notes are encrypted and decrypted transparently using OpenSSL, with filesystem
storage containing only the ciphertext.

This repository has *notebook* status, meaning that it is released in the hope
it will be useful, but it is not under active development and there are no
releases planned.


## Externals

There are no externals.


## Installation

- Config (copy and edit as appropriate):
  
  - `.env.example` => `.env`

- Libraries
  
  Using [Bundler](http://gembundler.com/), `bundle install`.

The default Ruby version supported is defined in `.ruby-version`.


## Run-time

- Services are defined in `Procfile`.

- Using [Foreman](http://ddollar.github.io/foreman/), `foreman start`.
  Alternatively, ensure that the environment variables in `.env` are set, and
  execute process definitions manually.

To check service is running:

    #$ curl "http://localhost:3000" -i


## Testing

Tests are written using [minitest](https://github.com/seattlerb/minitest).
To run all tests:

    foreman run rake test


## API

### GET /

Read service status.

#### Parameters

#### Responses

- `200`: success; body contains service status

#### Example

    #$ curl "http://localhost:3000/" -i

    HTTP/1.1 200 OK
    Content-Type: application/json
    Content-Length: 98
    X-Content-Type-Options: nosniff
    Connection: keep-alive
    Server: thin 1.6.2 codename Doc Brown
    
    {"service":"tpnoted","version":1,"time":1401067835,"msg":"Hello. Welcome to the tpnoted service."}


### POST /notes

Create note.

#### Parameters

- `password`: password to use for encryption
- `title`:    content title
- `body`:     content body

#### Responses

- `201`: success; header `Location` contains relative resource location

#### Example

    #$ curl -i -H 'Content-Type: application/json' -d '{"password":"password123","title":"TO AUTUMN.","body":"Sometimes whoever seeks abroad may find\nThee sitting careless on a granary floor, \n"}' http://localhost:3000/notes -i

    HTTP/1.1 201 Created
    Content-Type: text/html;charset=utf-8
    Location: /notes/08dd12cb-aec7-46bc-9713-6b6dd623a056
    X-XSS-Protection: 1; mode=block
    X-Content-Type-Options: nosniff
    X-Frame-Options: SAMEORIGIN
    Connection: close
    Server: thin 1.6.2 codename Doc Brown


### GET /notes/:id

Read note.

#### Parameters

- `id`: id such that relative URL matches `Location` from `POST /notes`

#### Responses

- `200`: success; body contains resource
- `404`: failure; not found, or invalid password

#### Example

    #$ curl -i "http://localhost:3000/notes/08dd12cb-aec7-46bc-9713-6b6dd623a056?password=password123"

    HTTP/1.1 200 OK
    Content-Type: application/json
    Content-Length: 161
    X-Content-Type-Options: nosniff
    Connection: keep-alive
    Server: thin 1.6.2 codename Doc Brown
    
    {"id":"08dd12cb-aec7-46bc-9713-6b6dd623a056","title":"TO AUTUMN.","body":"Sometimes whoever seeks abroad may find\nThee sitting careless on a granary floor, \n"}


## Blessing

May you find peace, and help others to do likewise.


## Licence

© [tiredpixel](http://www.tiredpixel.com) 2014.
It is free software, released under the MIT License, and may be redistributed
under the terms specified in `LICENSE`.
