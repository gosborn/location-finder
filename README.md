# Location Finder


## Requirements

* [docker](https://docs.docker.com/engine/installation/linux/docker-ce/)
* [docker-compose](https://docs.docker.com/compose/install/#install-compose)


## Install & Start Services

```
$ docker-compose build
$ docker-compose up
```

Docker-Compose may throw exceptions trying to access `docker-entrypoint.sh` and `sidekiq-entrypoint.sh` on run. If this is the case make sure access permissions are granted to those files: e.g. `chmod +x <file name>`

## Roadmap / TODO

Some pending todos have been added as Github Issues.

### Large milestones to add:
- Pick a better name!
- Continue to build out testing / documentation
- Client app and move to Docker
- Geocoding functions to calculate if locations have moved
- Image upload + automatic lat/lng detection from images
- User posts to locations
