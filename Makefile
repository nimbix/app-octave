all:
	DOCKER_BUILDKIT=1 docker build --pull --rm -f "Dockerfile" -t us-docker.pkg.dev/jarvice/images/app-octave:8.2.0 "."

push: all
	docker push us-docker.pkg.dev/jarvice/images/app-octave:8.2.0
