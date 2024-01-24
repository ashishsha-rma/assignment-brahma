#!/bin/bash

# Set the correct context for kubectl (replace 'your-context' with your actual context name)
kubectl config use-context your-context

# Wait for the deployment to be ready (replace 'your-deployment' with your actual deployment name)
kubectl wait --for=condition=available deployment/your-deployment --timeout=300s

# Test the web application by sending a GET request
WEB_APP_SERVICE=$(kubectl get services -o jsonpath='{.items[0].metadata.name}')
WEB_APP_IP=$(kubectl get services $WEB_APP_SERVICE -o jsonpath='{.status.loadBalancer.ingress[0].ip}')

echo "Testing GET endpoint of the web application..."
curl http://$WEB_APP_IP

# Test the web application by sending a POST request
echo "Testing POST endpoint of the web application..."
curl -X POST -d "number=10" http://$WEB_APP_IP/factors

# Check if the data is stored in the database (replace 'your-mysql-pod' with your actual MySQL pod name)
echo "Checking if data is stored in the database..."
kubectl exec -it your-mysql-pod -- mysql -uuser -ppassword -e "SELECT * FROM factors;" #prefer ssh into mysql pod and check tables

echo "Test script completed."
