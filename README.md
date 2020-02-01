API-gateway example with Kong
============================

Requirements for example
------------------------

* Docker version >= 18.09.2
* docker-compose >= 1.23.2

Databases
------------------------
By default it runs Kong with Postgres database.
If you want  to run Cassandra - replace contents of `docker-compose.yml` with `docker-compose-with-cassandra.yml`


Commands
--------


* Install the project
~~~~
$ make install
~~~~

**note:** this command runs the kong migrations

**note:** the kong app waits for its database service

* Uninstall the project
~~~~
$ make uninstall
~~~~

* Start stopped containers
~~~~
$ make start
~~~~
**note:** the kong app waits for its database service

* Stop all containers
~~~~
$ make stop
~~~~

* Open Kong UI (Konga) in browser
~~~~
$ make ui
~~~~

* Register a new application (service) without oauth
~~~~
$ make add_service NAME=app_a URL=http://app_a:8080 HOST=app_a.dev
$ make add_service NAME=app_b URL=http://app_b:8080 HOST=app_b.dev
~~~~
**note:** "app_a & app_b" is the service name in docker-compose for the applications


* Test the kong forward using host header
~~~~
$ make test HOST=app_a.dev
~~~~

* Enable auth plugin
~~~~
$ make enable_auth API_NAME=app_a

// response:

{"created_at":1511544935876,"config":{"key_in_body":false,"run_on_preflight":true,"anonymous":"","hide_credentials":false,"key_names":["apikey"]},"id":"85178a0e-0ab5-4283-8247-a7359dc46879","enabled":true,"name":"key-auth","api_id":"8bbcbc3a-877a-49da-80e0-28949c2d043c"}
~~~~

**note:** an API with the active authentication plug-in will display this message in the response for the "make test" command
~~~~
$ make test HOST=app_a.dev

// response:

{"message":"No API key found in request"}
~~~~

* Create a customer for authenticate API
~~~~
$ make create_consumer USER_NAME=dev API_KEY=dev

// responses:

{"created_at":1511544434570,"username":"dev","id":"581228fe-2343-4751-99ad-f917efae7bee"}
{"id":"2e5823b8-916e-4821-bff0-d61c48d65c65","created_at":1511544434586,"key":"dev","consumer_id":"581228fe-2343-4751-99ad-f917efae7bee"}
~~~~

* Test with api key
~~~~
$ make test_auth HOST=app_a.dev API_KEY=dev
~~~~

* For more commands
~~~~
$ make help
~~~~
