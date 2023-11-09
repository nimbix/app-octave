OCTAVE_VERSION := 8.4.0
CURRENT_DATE := $(shell date +"%Y-%m-%d")
all:
	sed "s,OCTAVE_VERSION,$(OCTAVE_VERSION)," NAE/AppDef.json > NAE/AppDef-versioned.json
	DOCKER_BUILDKIT=1 docker build --pull --rm -f "Dockerfile" -t us-docker.pkg.dev/jarvice/images/app-octave:$(OCTAVE_VERSION) --build-arg SERIAL_NUMBER=$(CURRENT_DATE) --build-arg OCTAVE_VERSION=$(OCTAVE_VERSION) "."

push: all
	docker push us-docker.pkg.dev/jarvice/images/app-octave:$(OCTAVE_VERSION)
