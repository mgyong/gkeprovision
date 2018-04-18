#!/bin/sh
##
# Script to deploy a Kubernetes project with a StatefulSet running a MongoDB Replica Set, to GKE.
##

# Create new GKE Kubernetes cluster (using host node VM images based on Ubuntu
# rather than ChromiumOS default & also use slightly larger VMs than default)

CLUSTERID=mingtestgpu
CLUSTERREGION=us-west1-b
PROJECTID=tpu-tutorial
NVIDIAKUBE=https://raw.githubusercontent.com/GoogleCloudPlatform/container-engine-accelerators/master/nvidia-driver-installer/ubuntu/daemonset.yaml
GPU_TYPE=nvidia-tesla-p100
GPUSIZE=2
NODESIZE=2
MAXNODESIZE=5
CLUSTERVERS=1.9
NODEDISK=3G
IMAGETYPE=UBUNTU


gcloud config set project $PROJECTID

#create cluster with 2 nodes
gcloud beta container clusters create $CLUSTERID \
--accelerator type=nvidia-tesla-p100,count=$GPUSIZE \
--zone $CLUSTERREGION --cluster-version $CLUSTERVERS \
--disk-size=$NODEDISK --image-type =$IMAGETYPE\
--num-nodes $NODESIZE --min-nodes 0 --max-nodes $MAXNODESIZE --enable-autoscaling


# INSTALL NVIDIA driver
kubectl create -f $NVIDIAKUBE
kubectl get pods -n=kube-system
kubectl get nodes -ojson | jq .items[].status.capacity

# Create tensorflow gpu container
echo "Tensorflow GPU pod"
kubectl apply -f ../resources/tensorflow-gpu.yaml

