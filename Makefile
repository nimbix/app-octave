OCTAVE_VERSION := 9.1.0
CURRENT_DATE := $(shell date +"%Y-%m-%d")
all:
	sed "s,OCTAVE_VERSION,$(OCTAVE_VERSION)," NAE/AppDef.json > NAE/AppDef-versioned.json
	podman build --jobs 0 --pull --rm -f "Dockerfile" -t us-docker.pkg.dev/jarvice/images/app-octave:$(OCTAVE_VERSION) --build-arg SERIAL_NUMBER=$(CURRENT_DATE) --build-arg OCTAVE_VERSION=$(OCTAVE_VERSION) "."

push: all
	podman push us-docker.pkg.dev/jarvice/images/app-octave:$(OCTAVE_VERSION)
