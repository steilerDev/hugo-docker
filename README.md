# Docker Container for hugo
This container will take a [hugo](https://gohugo.io) project and output the built webpage. Optionally (staticrypt)[https://github.com/robinmoisson/staticrypt] can be used to encrypt areas of the final page.

# Configuration options
## Environment Variables
The following environmental variables can be used for configuration:

 - `CRYPT_PWD`    
    The password, used in staticrypt. If undefined the encryption step will be skipped.

## Volume Mounts
The following paths are recommended for persisting state and/or accessing configurations

 - `/src/`  
   The source location of the hugo project
 - `/site/`  
   The output directory for the built webpage

# docker-compose example
Usage with `nginx-proxy` inside of predefined `steilerGroup` network, with the `site` service serving the created page. Uncomment the entrypoint, if you need to access the container, e.g. to initialize the project.

```
version: '2'
services:
  site_gen:
    image: steilerdev/hugo:latest
    container_name: hugo
    volumes:
      - /opt/docker/hugo/volumes/site:/site
      - /opt/docker/hugo/volumes/src:/src
#    entrypoint: tail -f /dev/null
    environment:
      CRYPT_PWD: "some-pass"
  site:
    image: nginx:latest
    container_name: site
    restart: unless-stopped
    volumes:
      - /opt/docker/hugo/volumes/site:/usr/share/nginx/html:ro
    depends_on:
      - "site_gen"
networks:
  default:
    external:
      name: steilerGroup
```