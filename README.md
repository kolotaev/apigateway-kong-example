API-gateway example with Kong
============================

Requirements for example
------------------------

* Docker version >= 18.09.2
* docker-compose >= 1.23.2

Commands
--------


* Install the project
~~~~
$ make install
~~~~

**note:** this command runs the kong migrations

**note:** the kong app waits for cassandra db service

* Uninstall the project
~~~~
$ make uninstall
~~~~

* Start stopped containers
~~~~
$ make start
~~~~
**note:** the kong app waits for cassandra db service

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
$ make add_service NAME=app_a URL=http://app_a/ HOST=app_a.dev
$ make add_service NAME=app_b URL=http://app_b/ HOST=app_b.dev
~~~~
**note:** "app_a & app_b" is the service name in docker-compose for the applications


* Test the kong forward using host header
~~~~
$ make test HOST=app_a.dev

// response:

HTTP/1.1 200 OK
Content-Type: text/html; charset=UTF-8
Transfer-Encoding: chunked
Connection: keep-alive
Server: nginx/1.8.0
Date: Tue, 21 Nov 2017 17:37:50 GMT
X-Powered-By: PHP/5.6.14
X-Kong-Upstream-Latency: 256
X-Kong-Proxy-Latency: 155
Via: kong/0.11.1

<html>
<head>
	<title>Hello world!</title>
	<link href='http://fonts.googleapis.com/css?family=Open+Sans:400,700' rel='stylesheet' type='text/css'>
	<style>
	body {
		background-color: white;
		text-align: center;
		padding: 50px;
		font-family: "Open Sans","Helvetica Neue",Helvetica,Arial,sans-serif;
	}

	#logo {
		margin-bottom: 40px;
	}
	</style>
</head>
<body>
	<img id="logo" src="logo.png" />
	<h1>Hello world!</h1>
	<h3>My hostname is 5017d131170f</h3>	</body>
</html>

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
$ make create_customer USER_NAME=dev API_KEY=dev

// responses:

{"created_at":1511544434570,"username":"dev","id":"581228fe-2343-4751-99ad-f917efae7bee"}
{"id":"2e5823b8-916e-4821-bff0-d61c48d65c65","created_at":1511544434586,"key":"dev","consumer_id":"581228fe-2343-4751-99ad-f917efae7bee"}
~~~~

* Test with api key
~~~~
$ make test_auth HOST=app_a.dev API_KEY=dev

// response:

HTTP/1.1 200 OK
Content-Type: text/html; charset=UTF-8
Transfer-Encoding: chunked
Connection: keep-alive
Server: nginx/1.8.0
Date: Fri, 24 Nov 2017 20:07:58 GMT
X-Powered-By: PHP/5.6.14
X-Kong-Upstream-Latency: 270
X-Kong-Proxy-Latency: 208
Via: kong/0.11.1

<html>
<head>
	<title>Hello world!</title>
	<link href='http://fonts.googleapis.com/css?family=Open+Sans:400,700' rel='stylesheet' type='text/css'>
	<style>
	body {
		background-color: white;
		text-align: center;
		padding: 50px;
		font-family: "Open Sans","Helvetica Neue",Helvetica,Arial,sans-serif;
	}

	#logo {
		margin-bottom: 40px;
	}
	</style>
</head>
<body>
	<img id="logo" src="logo.png" />
	<h1>Hello world!</h1>
	<h3>My hostname is 4bcfc5ecb1c4</h3>	</body>
</html>
~~~~

* For more commands
~~~~
$ make help
~~~~
