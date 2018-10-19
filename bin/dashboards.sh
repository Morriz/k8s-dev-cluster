#!/usr/bin/env bash
root=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd .. && pwd )
. $root/bin/colors.sh
shopt -s expand_aliases
. $root/bin/aliases

. $root/.env.sh

printf "${COLOR_WHITE}Starting SYSTEM app proxies${COLOR_NC}\n"

printf "${COLOR_PURPLE}[system] Waiting for necessary pods to become available${COLOR_BROWN}\n"
# ksk rollout status -w deploy/dashboard-kubernetes-dashboard
ks rollout status -w deploy/weave-scope-frontend-weave-scope
kl rollout status -w deploy/elasticsearch
km rollout status -w statefulset.apps/prometheus-prometheus
km rollout status -w statefulset.apps/alertmanager-prometheus
ktf rollout status -w statefulset.apps/prometheus-team-frontend-prometheus
ktf rollout status -w statefulset.apps/alertmanager-team-frontend-prometheus

# printf "${COLOR_BLUE}Starting Kubernetes Dashboard${COLOR_NC}\n"
# kpk 8443 > /dev/null 2>&1
# ksk port-forward $(ksk get po --selector=app=kubernetes-dashboard --output=jsonpath={.items..metadata.name}) 8443 &

printf "${COLOR_BLUE}Starting Weave Scope${COLOR_NC}\n"
kpk 4041 > /dev/null 2>&1
ks port-forward $(ks get po --selector=app=weave-scope,component=frontend --output=jsonpath={.items..metadata.name}) 4041:4040 &

printf "${COLOR_BLUE}Starting nginx status proxy${COLOR_NC}\n"
kpk 18080 > /dev/null 2>&1
ks port-forward $(ks get po --selector=app=nginx-ingress,component=controller --output=jsonpath={.items..metadata.name}) 18080 &

printf "${COLOR_BLUE}Starting elasticsearch proxy${COLOR_NC}\n"
kpk 9200 > /dev/null 2>&1
kl port-forward $(kl get po --selector=app=elasticsearch --output=jsonpath={.items..metadata.name}) 9200 &
# for kubernetes efk addon:
# kpk 5601 > /dev/null 2>&1
# ksk port-forward elasticsearch-logging-0 9200 &
# ksk port-forward $(ksk get po --selector=k8s-app=kibana-logging --output=jsonpath={.items..metadata.name}) 5601 &

printf "${COLOR_BLUE}Starting prometheus proxy${COLOR_NC}\n"
kpk 9090 > /dev/null 2>&1
km port-forward $(km get po --selector=app=prometheus --output=jsonpath={.items..metadata.name}) 9090 &

printf "${COLOR_BLUE}Starting alertmanager proxy${COLOR_NC}\n"
kpk 9093 > /dev/null 2>&1
km port-forward $(km get po --selector=app=alertmanager --output=jsonpath={.items..metadata.name}) 9093 &

printf "${COLOR_WHITE}Starting TEAM FRONTEND app proxies${COLOR_NC}\n"

printf "${COLOR_BLUE}Starting prometheus proxy${COLOR_NC}\n"
kpk 9190 > /dev/null 2>&1
ktf port-forward $(ktf get po --selector=app=prometheus --output=jsonpath={.items..metadata.name}) 9190:9090 &

printf "${COLOR_BLUE}Starting alertmanager proxy${COLOR_NC}\n"
kpk 9193 > /dev/null 2>&1
ktf port-forward $(ktf get po --selector=app=alertmanager --output=jsonpath={.items..metadata.name}) 9193:9093 &

open $root/docgen/minikube-service-index.html
