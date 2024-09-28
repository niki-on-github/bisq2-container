# Bisq2 Container

Run the peer-to-peer bitcoin exchange system **Bisq2** inside a container for easy deployment on your homelab server.

## Quickstart

```sh
mkdir -p data
chown 1000:1000 data
docker run --rm -it -v $PWD/data:/data -p 5800:5800 ghcr.io/niki-on-github/bisq2-container:v2
```

Open your webbrowser and navigate to `${IP}:5800`.
