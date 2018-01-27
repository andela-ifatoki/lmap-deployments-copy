# Release Management

### Introduction
Release management is the process of managing, planning, scheduling and controlling a software build through different stages and environments; including testing and deploying software releases.  As part of the LMap migration to GCP, it's one of the many practices that was implemented.

### CircleCI
The strategy we used in the LMap migration to GCP employs CircleCI acts as a platform for both Continuous Integration and Continuous Deployment. CircleCI fits well into this flow being the perfect suit to ensure our needs are met. Furthermore, it's the prefered tool that is being used currently by Andela as an Organization.

### LMap Requirements
Developers should be able to continuously deploy new changes to the application and roll back to old versions as necessary. This should be executed automatically from a Continuous Integration pipeline.
- Can deploy newest HEAD of develop branch to any environment.

- Can rollback to last deployment as needed.

- Packages assets as needed.

- Restarts application and web servers as needed.

- During deployments the application should have zero downtime.

### Solution
Pipeline Steps
- changes are pushed to the LMap git repository.

- Automatically trigger and execute whenever changes are pushed.

- Pipeline pulls the codebase.

- Runs the test.

- Pipeline should deploy the changes automatically to the staging environment.

- Integrated configured alerts should be sent to notify LMap team of any complete deployment.


To ensure the application has zero downtime during deployment, a **Rolling Replace** will be used. This is a technique that reduces downtime and risk by spinning up a new environment along side the pre-existing one that pulls and deploys the new changes. As it starts up, no traffic to the application is routed to it but rather to the pre-existing environment. After a set *cool down* period to allow the new environment to reach desired operation, traffic is then routed to the  new environment and the old one is decommissioned and deleted.

To enable easy rollbacks, A build revert will have to be carried out. Successful builds are given a commit, so the previous succesful run build will be re-run and the deployment process of the previous version will be triggered.

Semantic Versioning which implements automated release version bumping though not initially being used by LMap on Heroku is to be an added feature. This will ensure proper tracking of releases.
