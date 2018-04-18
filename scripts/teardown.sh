#!/bin/sh
##
# Script to remove/undepoy all project resources from GKE & GCE.
##

CLUSTERID=mingtestgpu
CLUSTERZONE=us-west1-b
PROJECTID=tpu-tutorial

gcloud container clusters get-credentials $CLUSTERID --zone $CLUSTERZONE --project $PROJECTID

# Delete mongod stateful set + mongodb service + secrets + host vm configuer daemonset
kubectl delete services tf-juypter-service
kubectl delete deployments tf-jupyter
sleep 3

# Delete persistent volume claims
#kubectl delete persistentvolumeclaims -l role=mongo
#sleep 3

# Delete persistent volumes

# Delete GCE disks

# Delete whole Kubernetes cluster (including its VM instances)
gcloud -q container clusters delete $CLUSTERID --zone $CLUSTERZONE