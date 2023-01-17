#!/bin/bash

DIR=$(dirname $0)

ci-utils() {
    docker run --rm -i -v $(pwd):$(pwd) registry.gitlab.com/gitlab-ci-utils/curl-jq $@
}

penguinctl-docker() {
    docker run --rm -v $(pwd):$(pwd) ghcr.io/vmware-tanzu-learning/penguinctl --url=${PENGUINCTL_APIURL} --token=${PENGUINCTL_APITOKEN} $@
}

deploy-all() {

    export GIT_STATUS="$(git status | ci-utils jq -R -s '.' | sed 's:^.\(.*\).$:\1:' )"
    export GITHUB_REF_NAME="${GITHUB_REF_NAME:-$(git branch --show-current)}"
    export GITHUB_SHA="${GITHUB_SHA:-$GIT_STATUS}"
    export GITHUB_ACTOR="${GITHUB_ACTOR:-${USER}@local}"
    export DEBUG_DATE=$(date)

    envsubst < ${DIR}/course.template.json > ${DIR}/course.json
    penguinctl-docker apply course -f $(pwd)/${DIR}/course.json
    rm ${DIR}/course.json
}

"$@"