# AnsibleFest 2017 Demo

This project includes all the elements required to run the demo.

### Requirements
The following are required to run this demo
* Docker 17.03.1
* Ansible 2.3.2.0 (Installed via Pip)

It's been tested on OSX. It should work on other operating systems, but I have not tested it.

### Setup

To begin, clone this repository and step into the folder.  

#### Start the Cluster

To begin, fire up the cluster, which includes Conjur, Postgres, CLI, 2 Staging Containers, and 4 production servers:

```sh
$ ./start.sh
```

#### Load Policy

Load the full policy, users, and groups from the `/policy` folder:

```sh
$ ./1_load_policies.sh
```

#### Set Secrets

Load values into our variables:

```sh
$ ./2_set_secrets.sh
```

#### Ansible

There are two scripts: `3_deploy_staging.sh` and `4_deploy_production.sh`, which do the following:

1. Generate a Host Factory token for that particular environment
2. Use the `ansible-role-conjur` Role to provide identity to the remote instances, and add them to the correct group based on the provided Host Factory token.
3. Retrieve secrets using the identity of that machine.

To perform the above steps on the staging environment:
```sh
$ ./3_deploy_staging.sh
```


To perform the above steps on the production environment:
```sh
$ ./4_deploy_production.sh
```

#### Shutting it Down

To stop and cleanup all running containers (this will destroy all data):

```sh
$ ./stop.sh
```
