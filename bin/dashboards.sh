#!/usr/bin/env bash
root=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd .. && pwd )
. $root/bin/colors.sh
shopt -s expand_aliases
. $root/bin/aliases

printf "${COLOR_WHITE}Starting SYSTEM app proxies${COLOR_NC}\n"

printf "${COLOR_PURPLE}[system] Waiting for necessary pods to become available${COLOR_BROWN}\n"
ks rollout status -w deploy/nginx-nginx-ingress-controller
kl rollout status -w deploy/elasticsearch
km rollout status -w statefulset/prometheus-prometheus
km rollout status -w statefulset/alertmanager-alertmanager

ktf rollout status -w statefulset/prometheus-team-frontend-prometheus
ktf rollout status -w statefulset/alertmanager-team-frontend-alertmanager

printf "${COLOR_BLUE}Starting nginx status proxy${COLOR_NC}\n"
kpk 18080 > /dev/null 2>&1
ks port-forward $(ks get po --selector=app=nginx-ingress,component=controller --output=jsonpath={.items..metadata.name}) 18080 &

printf "${COLOR_BLUE}Starting elasticsearch proxy${COLOR_NC}\n"
kpk 9200 > /dev/null 2>&1
kl port-forward $(kl get po --selector=app=elasticsearch --output=jsonpath={.items..metadata.name}) 9200 &

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
