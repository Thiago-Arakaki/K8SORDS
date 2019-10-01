## Deploying a simple app using Oracle Container Engine for Kubernetes and Oracle Autonomous Database Rest Data Services.

### Intro

This Workshop will cover the creation of a infraestructure using Oracle Cloud Infraestructure stack. In the following labs you will be able to build and configure an [Oracle Container Engine for Kubernetes(OKE)](https://www.oracle.com/cloud/compute/container-engine-kubernetes.html) where an NodeJS aplication will be deployed, this application will be connected on an [Oracle Autonomous Database]() and will be stored in a container image hosted on the [Oracle Container Image Registry](), all of this orchestrated by the CI/CD [Oracle Container Pipelines]().


#### Project Architecture:

![](/images/architecture.png)

### Prerequisites

- Oracle Cloud Account (can be a simple trial account)
- Github Account
- Wercker Account

### Labs

* [Lab 040](lab40/lab40.md) - Create a Github, a Wercker and a Oracle Cloud Infraestructure Account.
* [Lab 100](lab100/lab100.md) - Create a simple infraestrucutre using Oracle Resource Manager (Terraform).
* [Lab 200](lab200/lab200.md) - Create a Oracle Autonomous Database Instance and enable Oracle REST Data Service.
* [Lab 250](lab250/lab250.md) - Quick guide on how to use Oracle Rest Data Service noSQL features (SODA).
* [Lab 300](lab300/lab300.md) - Create a new application and contenerize it using Oracle Container Pipelines (Wercker).
* [Lab 400](lab400/lab400.md) - Create a new application and contenerize it using Oracle Container Pipelines (Wercker).
* [Lab 500](lab500/lab500.md) - Deploy the newly created application on the OKE cluster using Oracle Container Pipelines.
