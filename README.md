# Learning Map API Infrastructure


### Tech stack
- [Barman](http://www.pgbarman.org/)
- [Terraform](https://www.terraform.io)
- [Packer](https://www.packer.io)
- [Hashicorp Vault](https://www.vaultproject.io)
- Google Cloud Platform


### Introduction

> **What is Infrastructure as Code(IaC):**
Infrastructure as code is an approach to infrastructure automation based on practices from software development. It emphasises consistent repeatable routines for provisioning and changing systems and their configuration. Changes are made to definitions and then rolled out to systems through unattended processes that include thorough validation.

Infrastructure as code helps standardize and automate the creation/orchestration of networks, provisioning of server systems, securing and deployment of  applications in a repeatable stateless manner.

The code in this repository aim to bring these benefits to the Learning Map API application(hence forth referred to as LMap). With a single command one, can spin up an entire secure network with the application deployed on a cluster of app servers behind a load balancer and highly performant database.


### Content

- [Image Creation](docs/machine_image.md)
- [SSH access](docs/ssh.md)
- [Secret Management](docs/secret_management.md)
- [Release management](docs/release.md)
- [Maintenance and Backup](docs/maintenance.md)

### Contributors

- [Badriku Eugene Noel](https://github.com/EugeneBad)
- [Itunuloluwa Fatoki](https://github.com/itunuworks)
