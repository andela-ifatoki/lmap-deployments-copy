#### What is Celery?
Celery is a task queue used for handling tasks asynchronously in the background, allowing the server focus on handling major tasks.

For `calm-backend`, it handles the following tasks:
- push notifications when a contribution has been created
- when a contribution has been bookmarked

#### How the Image was Built
- Copy the `Dockerfile` in `celery` directory into the root directory of the `learning_map_api` directory
- Build the image using `docker build` command
- Tag the image like so: `gcr.io/learning-map-app/celery:latest`
- Push the image to GCR

#### Where is the Image Used?
The image is referenced in the CircleCI pipeline of the project as a dependency.