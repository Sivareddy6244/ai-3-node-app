#!/bin/bash

# Set the directory where your YAML files are located
YAML_DIR="/home/surekha_jekappa/gitkb"  # Directory for the gitkb YAML files

# Authenticate with the GKE cluster
echo "Authenticating with GKE cluster..."
gcloud container clusters get-credentials gke-cluster --zone us-central1-a --project pre-onboarding-427811

# Check if kubectl is configured and the cluster is reachable
if kubectl cluster-info > /dev/null 2>&1; then
  echo "Cluster is up and reachable."
  
  # Get the list of node names
  nodes=$(kubectl get nodes -o custom-columns=":metadata.name")

  # Convert nodes into an array
  node_array=($nodes)

  # Dynamically label the first 3 nodes, or as many as available
  if [ ${#node_array[@]} -ge 3 ]; then
    echo "Labeling nodes..."
    kubectl label nodes ${node_array[0]} role=primary
    kubectl label nodes ${node_array[1]} role=secondary
    kubectl label nodes ${node_array[2]} role=tertiary
    echo "Nodes labeled as primary, secondary, and tertiary."
  else
    echo "Not enough nodes to label as primary, secondary, and tertiary."
    # Label the available nodes with roles
    for i in "${!node_array[@]}"; do
      case $i in
        0) kubectl label nodes ${node_array[$i]} role=primary ;;
        1) kubectl label nodes ${node_array[$i]} role=secondary ;;
        2) kubectl label nodes ${node_array[$i]} role=tertiary ;;
      esac
    done
    echo "Nodes labeled as available roles."
  fi

  # Apply the YAML files in the specified order
  FILES=(
    "gitkb.yaml"
    "gitkb_config.yaml"
    "gitkb_secrets.yaml"
    "gitkb_deploy.yaml"
    "gikb_hpa.yaml"
  )

  for yaml_file in "${FILES[@]}"; do
    file_path="$YAML_DIR/$yaml_file"
    if [ -f "$file_path" ]; then
      echo "Applying $file_path..."
      
      # Try to apply the YAML file and retry if it fails
      retries=3
      success=0
      for ((i=1; i<=retries; i++)); do
        kubectl apply -f "$file_path" -n gitkb
        if [ $? -eq 0 ]; then
          echo "$file_path applied successfully."
          success=1
          break
        else
          echo "Attempt $i failed for $file_path. Retrying..."
        fi
      done

      # If all retries fail, log the error
      if [ $success -eq 0 ]; then
        echo "Failed to apply $file_path after $retries attempts."
      fi
    else
      echo "$file_path does not exist or is not a valid file."
    fi
  done

  echo "All YAML files have been processed."

  # Wait a few seconds to ensure the resources are created before retrieving them
  echo "Fetching Pods..."
  kubectl get pods -n gitkb  # Get Pods in the gitkb namespace

  echo "Fetching Nodes..."
  kubectl get nodes  # Get all nodes in the cluster

  echo "Fetching Services..."
  kubectl get svc -n gitkb  # Get Services in the gitkb namespace

else
  echo "Cluster is not reachable. Please check your Kubernetes setup."
fi
