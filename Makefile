#!make


.PHONY: deploy release

# TODO - have this create a docker image with the artifacts in it and push to packages
#        as part of a Release
release:

deploy-lms:
	metadata/lms/deploy.sh deploy-all