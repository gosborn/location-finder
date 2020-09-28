# Location Finder

The overall goal of this application is to encourage people to get out, explore their communities and to foster curiosity about where people live. Previously, I organized a race throughout the parks of Pittsburgh, but with gatherings discouraged in 2020, I'm looking for an alternative to get people out.

The idea is to plant "Locations" around town. These would consist of QR codes printed on a sign or sticker. Scanning the QR Code will take the user to a landing page for that "Location", where the user can log a "Visit". Currently, a user can use the API to create a "Visit", in the future, a photo with GPS info may be required. A User is able to see all the "Locations" they have visited.

Currently, the app is being built out with some validation logic. If a user is too far away from the Lat/Lng of the "Location" visited, that visit will be flagged. If within a certain distance, the "Visit" will be confirmed (in progress).

Additionally, the app considers that "Locations" might be moved! A background job will check all of the most recent visits of a Location (this is in progress). If the average "Visit" lat/lng differs by some margin from the "Location's" Lat/Lng, the Lat/Lng of the "Location" will be updated (this may use some sort of History model to track the "Location" over time. Once recalculated, the status of previous visits will be changed to "expired" if outside the new radius, or "confirmed" if previously "flagged".

Going forward, API additions that would make this more interesting:
- Ability for a user to see if there are any nearby locations + hints as to where they could be located
- Adding Visit Posts to a Location
- Grouping Locations together and calculating "Group Completion" with achievements

The backend of the app is still being built out - the client has not been tackled yet!

## Requirements

* [docker](https://docs.docker.com/engine/installation/linux/docker-ce/)
* [docker-compose](https://docs.docker.com/compose/install/#install-compose)


## Implementation Details

This app uses a Rails 6.0.3 API build with Ruby 2.7.1. The app provides a JSON API that interacts with a postgres db to store Users, Visits and Locations.

API model serializations are done with [fast_jsonapi](https://github.com/Netflix/fast_jsonapi)

Background jobs utilize ActiveJob, [Sidekiq](https://github.com/mperham/sidekiq) and Redis.
 
A JWT scheme is used for authentication using the [jwt](https://github.com/jwt/ruby-jwt) gem. Usage explained below.

Environment management uses [dotenv](https://github.com/bkeepers/dotenv). Usage explained below.


## Install & Start Services

Add a `.env` file to the `api` directory. An example of required values are present in `.env.example`.

```
$ docker-compose build
$ docker-compose up
```

Docker-Compose may throw exceptions trying to access `docker-entrypoint.sh` and `sidekiq-entrypoint.sh` on run. If this is the case make sure access permissions are granted to those files: e.g. `chmod +x <file name>`

The API will be available at localhost:3000 and can be accessed with curl or an app like [Postman](https://www.postman.com/).


## Domain Details

Each User has:
  - email
  - password
  - 0 or more Visits with attributes of:
    - Description
    - Latitude
    - Longitude
    - Status (an enum of "confirmed", "flagged", "pending", or "expired")

Each Visit has:
  - 1 Location with attributes of:
    - Name
    - Description
    - Latitude
    - Longitude

Each Location has:
  - 0 or more Visits


## Interacting with the API

### Authenticating
- Login or create a new user to obtain a JWT:
  - If valid, both requests will return a token to be added the headers of all subsequent requests as: `Authentication: <token>`
  - The tokens expire after 10 minutes - obtain a new token with the login path. A refresh token endpoint can be added in the future.
  - To Login, use the existing user (in seeds.rb):
    - POST /v1/users/login 
    ```
    curl -X POST \
        http://localhost:3000/v1/users/login \
        -H 'Accept: application/json' \
        -H 'Content-Type: application/json' \
        -d '{
        "user": {
          "email": "test@example.com",
          "password": "password1234"
          }
        }'
    ```
  - To create a new user:
    - POST /v1/users/
    ```
    curl -X POST \
        http://localhost:3000/v1/users/ \
        -H 'Accept: application/json' \
        -H 'Content-Type: application/json' \
        -d '{
        "user": {
          "email": <unique email>,
          "password": <password>
          }
        }'
    ```
    
### Other important User endpoints
- GET /v1/user/profile: returns info about the logged in user

### Important Location endpoints
- GET /v1/location/<location id>: returns info about the associated Location
  - Two locations are added by default in seeds.rb. Query their ids using the rails console. Using Docker with container running: `docker exec -it api rails c` then `Location.all.select(:id)`
  - This is the endpoint utilized when a user scans a QR Code.
  
### Important Visit endpoints
- POST /v1/visits: creates a new visit for a location
```
curl -X POST \
  http://localhost:3000/v1/visits \
  -H 'Accept: application/json' \
  -H 'Authorization: <token>' \
  -H 'Content-Type: application/json' \
  -d '{
        "visit": {
        "latitude": <float>,
        "longitude": <float>,
        "location_id": <location uuid>

        }
    }'
```
- GET /v1/visits: shows all visits for user
    


## Code linting

This project uses [Rubocop](https://github.com/bbatsov/rubocop) to check code style. Run by typing `rubocop` in the directory of the project. In a docker configuration run `docker exec -it api rubocop` with the containers up and running.

## Testing

This project uses rspec for test cases. Run by typing `rspec` to recursively run all test suites. In a docker configuration run `docker exec -it api rspec` with the containers up and running.

## Roadmap / TODO

Some pending todos have been added as Github Issues.

### Large milestones to add:
- Pick a better name!
- Continue to build out testing / documentation
- Client app and move to Docker
- Geocoding functions to calculate if locations have moved
- Image upload + automatic lat/lng detection from images
- User posts to locations
- Location Groups / Achievements?
