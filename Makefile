.DEFAULT_GOAL := help

API_HOST_8001_CONSUMERS = http://localhost:8001/consumers
API_HOST_8001_SERVICES = http://localhost:8001/services
API_HOST_8000 = http://localhost:8000/

install: ## Install the project for first time
	@echo "creating the Cassandra DB"
	@make start_db
	@echo "execute database migrations"
	@make migrate
	@echo "execute Kong app"
	@make start_kong
	@echo "execute Kong UI app"
	@make start_konga
	@echo "start the app a"
	@make start_app_a
	@echo "Starting app B"
	@make start_app_b

uninstall: ## Destroy all project
	@docker-compose down

start: ## Start all stopped containers
	@echo "Starting db services"
	@make start_db
	@echo "Starting kong services"
	@make start_kong
	@echo "Starting Kong UI"
	@make start_konga
	@echo "Starting app A"
	@make start_app_a
	@echo "Starting app B"
	@make start_app_b

stop: ## Stop all containers
	@echo "Stop db services"
	@make stop_db
	@echo "Stop kong services"
	@make stop_kong
	@echo "Stop Kong UI"
	@make stop_konga
	@echo "Stop app A"
	@make stop_app_a
	@echo "Stop app B"
	@make stop_app_b

start_db: ## Create the database
	@docker-compose up -d cassandra

stop_db: ## Stop the database
	@docker-compose stop cassandra

migrate: ## run the db migrations
	@docker-compose run migrations

start_kong: ## Start the kong application
	@docker-compose up -d kong

stop_kong: ## Stop the kong application
	@docker-compose stop kong

start_konga: ## Start the kong UI application
	@docker-compose up -d konga

stop_konga: ## Stop the kong UI application
	@docker-compose stop konga

start_app_a: ## Start the App A
	@docker-compose up -d app_a

stop_app_a: ## Stop the App A
	@docker-compose stop app_a

start_app_b: ## Start the App B
	@docker-compose up -d app_b

stop_app_b: ## Stop the App B
	@docker-compose stop app_b

add_service: ## Adding service
	@curl -v -i -X POST \
		--url $(API_HOST_8001_SERVICES) \
		--data 'name=${NAME}' \
		--data 'url=${URL}'
	@curl -i -X POST \
		--url $(API_HOST_8001_SERVICES)/${NAME}/routes \
		--data 'hosts[]=${HOST}'

delete_service: ## Deleting service
	@curl -v -i -X DELETE \
		--url $(API_HOST_8001_SERVICES)/${NAME}

enable_auth: ## Enable auth plugin
	@curl -v -i -X POST \
		--url $(API_HOST_8001_SERVICES)/${NAME}/plugins/ \
		--data 'name=key-auth'

create_customer: ## Create consumers
	@echo Creating consumer
	@curl -v -i -X POST \
		--url $(API_HOST_8001_CONSUMERS) \
		--data "username=${USER_NAME}"
	@echo Creating key-auth
	@curl -v -i -X POST \
		--url $(API_HOST_8001_CONSUMERS)/${USER_NAME}/key-auth/ \
		--data 'key=${API_KEY}'

test: ## Test resource
	@curl -v -i -X GET \
		--url $(API_HOST_8000) \
		--header 'Host: ${HOST}'

test_auth: ## Test using api key
	@curl -v -i -X GET \
		--url $(API_HOST_8000) \
		--header "Host: ${HOST}" \
		--header "apikey: ${API_KEY}"

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-16s\033[0m %s\n", $$1, $$2}'
