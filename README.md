# pocket-fhir

## All of this is based on the fabulous [PocketBase](https://pocketbase.io/), but designed for FHIR®

## Branches
1. local - this is a branch that just contains the src files and the executable.
2. local-docker - essentially just the same as local except that it runs in docker


### Local Branch
- Can just be run directly, can also be regenerated
- To regenerate: ```$ ./generate.sh```
- To run: ```$ ./pocketfhir serve```

### Local-Docker Branch
- Regenerate: ```$ ./build/generate.sh```
- You can still run locally as above: ```$ ./pocketfhir serve```
- Generating will create two directories pb_data/ and pb_migrations/, which normally stay in the primary directory, but for this case, we copy them into the data/ directory
- You should then be able to run: ```$ docker-compose up --build```
- This will create a client, and while the command line says that it is serving at: 
```
Server started at http://0.0.0.0:8090
pocketfhir-caddy | ├─ REST API: http://0.0.0.0:8090/api/
pocketfhir-caddy | └─ Admin UI: http://0.0.0.0:8090/_/
```
- It's actually located at ```https://localhost```
- Admin UI: [https://localhost/_/]
- If you want to upload some ValueSets and things to it using dart, in the dart directory, you can use the upload_all.dart file. You'll want to put in your username and password to make it work. Notice in this case, we also used the ```https://localhost``` for the PocketBase instance
- when you're done, use ```$ docker-compose down```