.PHONY: make_ca_certs create_dirs clean_dir create_ca_certs create_server_certs compose_up main

include .env
export

create_dirs:
	@echo "** creating directory structure **"
	./scripts/00-make-dirs.sh

clean_dir:
	@echo '** cleaning web dir **'
	@echo '** cleaning runner dir **'
	@echo '** cleaning certificates **'

create_ca_certs:
	@echo '** creating ca cert **'

create_server_certs:
	@echo '** creating server cert **'

rebuild_images:
	@echo '** rebuilding images **'

compose_up:
	@echo '** starting containers **'

compose_down:
	@echo '** stopping containers **'

main: rebuild_images clean_dir create_ca_certs create_server_certs compose_up

	
