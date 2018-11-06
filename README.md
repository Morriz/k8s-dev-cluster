# Mo'z investigation into running a local development Kubernetes cluster

Using Kubernetes because...reasons (go [Google](https://www.google.com/search?q=kubernetes)).

This repo reflects my investigation towards an easy and fast deployable development kubernetes cluster.

Another repo of mine houses my favorite stack of Kubernetes helm packages and best practices: [morriz/mostack](https://github.com/morriz/mostack). That stack is deployed as one GitOps operator, reconciling the cluster state with the one declared in the repo.

To boot up a cluster (see `bin/install*.sh` scripts) you can choose one of the following setups:

* [Minikube](https://github.com/Kubernetes/minikube) for running a local k8s cluster.
* [kubeadm-cluster-dind](https://github.com/kubernetes-sigs/kubeadm-dind-cluster) for running a local multinode k8s cluster as an alternative that is more close to the real deal. My favorite, as it is fast.
* [Vagrant](https://www.vagrantup.com) for running a local multinode cluster that even more closely mimics a currently available cloud cluster.
* GCE: the most basic way to boot/destroy a Kubernetes cluster with default settings.

## Deleting the cluster

With minikube the preferred way to delete the entire minikube is with the following command:

    mkd

which will backup all the images locally for less bandwidth usage during startup next time.

On GCE:

    bin/gce-delete.sh
