# Bisq2 Container

Run the peer-to-peer bitcoin exchange system **Bisq2** inside a container for easy deployment on your homelab server.

## Quickstart

```sh
docker run --rm -it -v $PWD/data:/data -p 5800:5800 ghcr.io/niki-on-github/bisq2-container:v2
```

Open your webbrowser and naviaget to `${IP}:5800`.
