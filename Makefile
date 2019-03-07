build:
	docker image build -t gitolite-mirror:latest ./gitolite-mirror

run: build
	docker-compose up
