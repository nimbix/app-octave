OCTAVE_VERSION := 10.1.0
CURRENT_DATE := $(shell date +"%Y-%m-%d")
IMAGE := us-docker.pkg.dev/jarvice/images/app-octave:$(OCTAVE_VERSION)-$(CURRENT_DATE)

all:
	sed "s,OCTAVE_VERSION,$(OCTAVE_VERSION)," NAE/AppDef.json > NAE/AppDef-versioned.json
	podman build \
		--jobs 0 --pull --rm \
		-f "Dockerfile" \
		--format docker \
		-t $(IMAGE) \
		--build-arg SERIAL_NUMBER=$(CURRENT_DATE) --build-arg OCTAVE_VERSION=$(OCTAVE_VERSION) \
		"."

push: all
	podman push $(IMAGE)
