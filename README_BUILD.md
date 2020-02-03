# gcloud-helm-builder
Simple Gcloud Helm Builder pulling charts from private Bucket

Based on helm chart from:

<https://github.com/GoogleCloudPlatform/cloud-builders-community>

```ssh
docker build --build-arg ssh_prv_key="$(cat ../private.key)" --build-arg ssh_pub_key="$(cat ../public.key)" --tag=gcr.io/gorilla-test-001/helm:2.14.3 --tag=gcr.io/gorilla-test-001/helm:latest .

docker push gcr.io/gorilla-test-001/helm:2.14.3 
docker push gcr.io/gorilla-test-001/helm:latest
```

helm repo add gorilla git+ssh://git@github.com/luisgreen/gorilla-helm-charts@?ref=master
