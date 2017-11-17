#!/usr/bin/env bash
root=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd .. && pwd )

# uses 'mo'
which mo > /dev/null
if [ $? -ne 0 ]; then
  echo "'mo' needs to be installed:"
  echo "curl https://raw.githubusercontent.com/tests-always-included/mo/master/mo -o mo&& chmod u+x mo && mv mo /usr/local/bin)"
  exit 1
fi

parseFiles() {
  cluster=$1
  cat $root/templates/service-index.html | mo > $root/docgen/${cluster}-service-index.html
  shift
  for f in "$@"; do
    echo generating values/_gen/$cluster/$f
    cat "$f" | mo > $root/values/_gen/$cluster/$f
  done
}

cd $root/values > /dev/null
baseFiles=$(find . -name "*.yaml" -maxdepth 1 | cut -c 3-)
cd gce
gceFiles=$(find . -name "*.yaml" -maxdepth 1 | cut -c 3-)
cd -

. $root/secrets/minikube.sh
parseFiles minikube $baseFiles

. $root/secrets/gce.sh
parseFiles gce $baseFiles
parseFiles gce $gceFiles

cat $root/templates/dashboards.yaml >> $root/values/_gen/minikube/grafana.yaml

cd $root > /dev/null
