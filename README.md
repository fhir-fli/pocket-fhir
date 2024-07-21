# pocket-fhir

## All of this is based on the fabulous [PocketBase](https://pocketbase.io/), but designed for FHIR®

### Local Run
- Generate: ```$ ./generate_local.sh``` - this will also start the server the first time
- After that, you can just do: ```$ ./pocketfhir serve```

### Local-Docker Branch
- Regenerate: ```$ ./build/generate.sh``` - can still be run as the executable
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

### GCP
- Based on [Rody Davis's](https://rodydavis.com/posts/pocketbase-cloudrun) version
- Go to GCP, make sure you have Cloud Storage
- Create a new bucket
- Give it a name, click continue
- Region - whatever your preference, continue
- Standard class, continue
- Control Access - whatever the default is, continue
- Data Protection - default
- Create
- run the generate script ```$ ./build/generate.sh```
- Copy the 2 folders (pb_data/ and pb_migrations/) to the storage bucket (you can just drag and drop)
- Complete the gcloud.sh file with appropriate values
- Run ```$ ./gcloud.sh``` - this should build and upload your docker container with Caddy to cloud run
- Go back into cloud run and select the new service
- Click Edit & Deploy New Revision
- Click Volume Tab
- Add Volume
- Volume Type -> Cloud Storage Bucket
- Volume name -> remote-storage (or whatever you want)
- Bucket -> the bucket you created that contains your folders
- Ensure you DO NOT check Read-only
- Click Container(s) Tab
- Partway down select Volume Mounts
- Name1 -> remote-storage (matches above)
- Mount path 1 -> /cloud/storage
- +Add Health Check
- Select health check type -> Liveness check
- Select probe type -> HTTP
- Path -> /api/health
- Initial delay -> 10
- Period -> 240
- Failure threshold -> 2
- Timeout -> 240
- Submit
- 
```
$ gcloud iam service-accounts create pocket-fhir-client --display-name="PocketFHIR Client"

$ gcloud run services add-iam-policy-binding pocket-fhir \
    --member="serviceAccount:pocket-fhir-client@<PROJECT_ID>.iam.gserviceaccount.com" \
    --role="roles/run.invoker" \
    --region=us-central1
```
