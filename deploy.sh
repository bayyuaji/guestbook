#! /bin/bash
if [ "$TRAVIS_BRANCH" = "master" ] && [ "$TRAVIS_PULL_REQUEST" = "false" ]; then
  gcloud --quiet components update kubectl
  # Push to Docker Hub
  docker build -t ${DOCKER_USERNAME}/${DOCKER_IMAGE_NAME}:${TRAVIS_BUILD_ID} .
  docker push ${DOCKER_USERNAME}/${DOCKER_IMAGE_NAME}:${TRAVIS_BUILD_ID}
  docker tag ${DOCKER_USERNAME}/${DOCKER_IMAGE_NAME}:${TRAVIS_BUILD_ID} ${DOCKER_USERNAME}/${DOCKER_IMAGE_NAME}:latest
  docker push ${DOCKER_USERNAME}/${DOCKER_IMAGE_NAME}:latest
  # Deploy to the cluster
  gcloud container clusters get-credentials guestbook
  kubectl  set image deployment/${K8S_DEPLOYMENT_NAME} ${K8S_DEPLOYMENT_NAME}=${DOCKER_USERNAME}/${DOCKER_IMAGE_NAME}:$TRAVIS_BUILD_ID
fi
