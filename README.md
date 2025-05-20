# multi-cloud-load-balancer

## Google Cloud Platform

Figure out the Google Cloud image name:

```
gcloud compute images list --project=ubuntu-os-cloud --filter="family=ubuntu-2404-lts"
```

Setup a Project where you can build Packer images. Create a Service Account that Packer can use to authenticate with Google Cloud. This Service Account should have the following roles:

1. Compute Instance Admin (v1)
2. IAP-secured Tunnel User
3. Service Account User

