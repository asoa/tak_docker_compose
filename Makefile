.PHONY: make_ca_certs create_dirs clean_dirs create_ca_certs create_server_certs up down main

include .env
export

login:
	@echo '** logging into iron bank **'
	docker login -u $$DOCKER_USER -p $$DOCKER_PASS registry1.dso.mil

create_dirs:
	@echo "** creating directory structure **"
	unzip $$RELEASE.zip
	mv $$RELEASE/docker/Dockerfile.* .
	
clean_dirs:
	@echo '** removing unzipped release and dockerfiles **'
	./scripts/00-clean-dirs.sh

edit_configs:
	@echo '** editing config files **'
	./scripts/01-edit-config.sh
	
build:
	@echo '** rebuilding images **'
	scripts/04-build-images.sh

up:
	@echo '** starting containers **'
	docker-compose up -d db
	docker-compose up -d server

add_user:
	@echo '** adding user **'
	scripts/05-add-user.sh

down:
	@echo '** stopping containers **'
	docker-compose down -v

main: clean_dirs create_dirs edit_configs build up

	
