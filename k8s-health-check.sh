#!/bin/bash

set -u

FAIL=0

echo "===== KUBERNETES HEALTH CHECK ====="
date

echo
echo "===== NODE HEALTH ====="
NODE_STATUS=$(kubectl get nodes --no-headers | awk '{print $2}')
echo "Node status: $NODE_STATUS"

if [ "$NODE_STATUS" != "Ready" ]; then
    echo "ALERT: Kubernetes node is not Ready"
    FAIL=1
fi

echo
echo "===== APPLICATION DEPLOYMENT ====="
READY=$(kubectl get deployment sample-app -n sample-app -o jsonpath='{.status.readyReplicas}')
AVAILABLE=$(kubectl get deployment sample-app -n sample-app -o jsonpath='{.status.availableReplicas}')

echo "Ready replicas: ${READY:-0}"
echo "Available replicas: ${AVAILABLE:-0}"

if [ "${READY:-0}" -ne 2 ] || [ "${AVAILABLE:-0}" -ne 2 ]; then
    echo "ALERT: sample-app does not have 2 healthy replicas"
    FAIL=1
fi

echo
echo "===== POD HEALTH ====="
kubectl get pods -n sample-app

NOT_READY=$(kubectl get pods -n sample-app --no-headers | awk '$2 !~ /^1\/1$/ || $3 != "Running" {count++} END {print count+0}')

if [ "$NOT_READY" -gt 0 ]; then
    echo "ALERT: One or more sample-app pods are unhealthy"
    FAIL=1
fi

echo
echo "===== METRICS API ====="
METRICS_STATUS=$(kubectl get apiservice v1beta1.metrics.k8s.io --no-headers | awk '{print $3}')
echo "Metrics API: $METRICS_STATUS"

if [ "$METRICS_STATUS" != "True" ]; then
    echo "ALERT: Metrics API is unavailable"
    FAIL=1
fi

echo
echo "===== RESOURCE USAGE ====="
kubectl top pods -n sample-app
kubectl top node

echo
if [ "$FAIL" -eq 0 ]; then
    echo "===== HEALTH CHECK RESULT: PASS ====="
    exit 0
else
    echo "===== HEALTH CHECK RESULT: FAIL ====="
    exit 1
fi
