devtools=@docker-compose run --rm -p 3000:3000 devtools

.docker: Dockerfile
	@docker-compose build devtools
	@touch .docker

shell: .docker
	$(devtools) nix-shell --attr env release.nix
