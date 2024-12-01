install-scylla:
  kubectl apply --server-side=true -f https://raw.githubusercontent.com/scylladb/scylla-operator/refs/heads/master/deploy/operator.yaml --force-conflicts

install-certmanager:
  helm repo add jetstack https://charts.jetstack.io --force-update
  helm upgrade --install \
  cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --version v1.16.1 \
  --set crds.enabled=true

start-kafka:
  kbcli cluster create kafka cluster1 \
  --meta-storage-class=local-path \
  --storage=1 \
  --storage-class=local-path \
  --storage-enable=true \
  -n kafka

connect-kafka:
  kubectl get svc -n kafka

start-scylla:
  kubectl apply -f scylla-cluster.yaml

connect-scylla:
  kubectl exec -n scylla -it scylla-cluster-cluster1-rack1-0 -- cqlsh