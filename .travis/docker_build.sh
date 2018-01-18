#!/bin/bash

source .env


BUILD_DATE=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
BUILD_NUMBER=$TRAVIS_BUILD_NUMBER
IMAGE_NAME="dan9186/devopsbase"
IMAGE_VERSION="0.0.1"

echo "Testing Dockerfile"
echo "		Name: $IMAGE_NAME"
echo "		Build Date: $BUILD_DATE"
echo "		Build Number: $BUILD_NUMBER"
echo "		Image Version: $IMAGE_VERSION"

docker build \
	-t $IMAGE_NAME \
	--build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
	--build-arg BUILD_NUMBER=$TRAVIS_BUILD_NUMBER \
	--build-arg VERSION="0.0.1" \
	.

if [ "$TRAVIS_BRANCH" == "master" ]; then
	echo "Pushing image $IMAGE_NAME"
	docker push $IMAGE_NAME
fi
