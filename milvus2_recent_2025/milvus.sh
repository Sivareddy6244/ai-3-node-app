
# Set the namespace where resources will be applied
NAMESPACE="bilvantisai"

# Navigate to the milvus2 directory where the YAML files are stored
cd /home/surekha_jekappa/milvus2 || { echo "Failed to change directory to milvus2."; exit 1; }

# Apply YAML files in the specified order
echo "Applying bilvantisai.yaml..."
kubectl apply -f bilvantisai.yaml -n $NAMESPACE || { echo "Failed to apply bilvantisai.yaml."; exit 1; }

echo "Applying storage-class.yaml..."
kubectl apply -f storage-class.yaml -n $NAMESPACE || { echo "Failed to apply storage-class.yaml."; exit 1; }

echo "Applying pv.yaml..."
kubectl apply -f pv.yaml -n $NAMESPACE || { echo "Failed to apply pv.yaml."; exit 1; }

echo "Applying pvc.yaml..."
kubectl apply -f pvc.yaml -n $NAMESPACE || { echo "Failed to apply pvc.yaml."; exit 1; }

echo "Applying secrets.yaml..."
kubectl apply -f secrets.yaml -n $NAMESPACE || { echo "Failed to apply secrets.yaml."; exit 1; }

echo "Applying final-chromadeploy.yaml..."
kubectl apply -f final-chromadeploy.yaml -n $NAMESPACE || { echo "Failed to apply final-chromadeploy.yaml."; exit 1; }

echo "Applying final-milvusdeploy.yaml..."
kubectl apply -f final-milvusdeploy.yaml -n $NAMESPACE || { echo "Failed to apply final-milvusdeploy.yaml."; exit 1; }

echo "Applying final-elasticdeploy.yaml..."
kubectl apply -f final-elasticdeploy.yaml -n $NAMESPACE || { echo "Failed to apply final-elasticdeploy.yaml."; exit 1; }

echo "Applying final-mongodeploy.yaml..."
kubectl apply -f final-mongodeploy.yaml -n $NAMESPACE || { echo "Failed to apply final-mongodeploy.yaml."; exit 1; }

echo "Applying final-prodserverdeploy.yaml..."
kubectl apply -f final-prodserverdeploy.yaml -n $NAMESPACE || { echo "Failed to apply final-prodserverdeploy.yaml."; exit 1; }

echo "Applying final-prodserverservice.yaml..."
kubectl apply -f final-prodserverservice.yaml -n $NAMESPACE || { echo "Failed to apply final-prodserverservice.yaml."; exit 1; }

echo "Applying milvus-frontend.yaml..."
kubectl apply -f milvus-frontend.yaml -n $NAMESPACE || { echo "Failed to apply milvus-frontend.yaml."; exit 1; }

echo "Applying hpa-prod.yaml..."
kubectl apply -f hpa-prod.yaml -n $NAMESPACE || { echo "Failed to apply hpa-prod.yaml."; exit 1; }

echo "Applying hpa-frontend.yaml..."
kubectl apply -f hpa-frontend.yaml -n $NAMESPACE || { echo "Failed to apply hpa-frontend.yaml."; exit 1; }

echo "All YAML files have been successfully applied."

# Optionally, you can check the status of resources
echo "Fetching Pods..."
kubectl get pods -n $NAMESPACE

echo "Fetching Services..."
kubectl get svc -n $NAMESPACE

echo "Fetching Deployments..."
kubectl get deployments -n $NAMESPACE