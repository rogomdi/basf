#!/bin/bash
if [[ -z ${CHART_VERSION} ]]; then
  CHART_VERSION="1.0.0"
fi
home=$PWD
echo "Building NLP Processor"
cd nlp-processor
./gradlew clean build -PskipTests
cd docker
bash build-image.sh
cd $home

echo "Building Patent manager"
cd patent-manager
./gradlew clean build -PskipTests
cd docker
bash build-image.sh
cd $home

echo "Building chart"
cp docker-compose.yml basf-test.yml
kompose convert -f basf-test.yml --chart
helm package basf-test --version "${CHART_VERSION}-local" --app-version "${CHART_VERSION}"
rm -rf basf-test
rm basf-test.yml
