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

Coming Soon

#### Shutting it Down

To stop and cleanup all running containers (this will destroy all data):

```sh
$ ./stop.sh
```
