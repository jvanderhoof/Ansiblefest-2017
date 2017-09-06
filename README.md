# AnsibleFest 2017 Demo

This project includes all the elements required to run the demo.

### Requirements
The following are required to run this demo
* Docker 17.03.1
* Ansible 2.3.2.0 (Installed via Pip)
* Python 2.7.13
* jq 1.5.2

It's been tested on OSX. It should work on other operating systems, but I have not tested it.

### Setup

To begin, clone this repository and step into the folder.  

#### Start the Cluster

To begin, fire up the cluster, which includes Conjur, Postgres, CLI, 2 Staging Containers, and 4 production servers:

```sh
$ ./demo.sh
```

To exit, `ctr-c`

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

There is a single `deploy.sh` file responsible for deploying to the Staging or Production environment.

This script does the following:

1. Generate a Host Factory token for that particular environment
2. Uses [cyberark/ansible-role-conjur]() role to:
  * Provide identity to the remote instance
  * Add them to the correct layer based on the provided Host Factory token.
3. Retrieve secrets using the identity of that machine.

To perform the above steps on the staging environment:
```sh
$ ./deploy.sh staging
```


To perform the above steps on the production environment:
```sh
$ ./deploy.sh production
```

#### Scaling Production Nodes

To demonstrate the simplicity of scaling up using Host Factory tokens, scale production nodes from 4 to 20:

```sh
$ docker-compose scale myapp_production=20
```

Next, in the `ansible/inventory` file, change the line: `ansiblefest_myapp_production_[1:4]` to `ansiblefest_myapp_production_[1:20]` and save the file.

Then, re-run the production configuration:

```sh
$ ./deploy.sh production
```

#### View Application Containers

Docker Compose handles the port mapping, binding each container to localhost. To pull the app on a browser, you'll need to pass the docker-compose assigned port.  You can get this port by viewing the running containers:

```sh
$ docker ps
CONTAINER ID        IMAGE                        COMMAND                  CREATED             STATUS              PORTS                            NAMES
37881ae9a161        ansiblefest_foo_production   "sleep infinity"         35 minutes ago      Up 35 minutes       0.0.0.0:32833->4567/tcp          ansiblefest_foo_production_4
f666344b3335        ansiblefest_foo_production   "sleep infinity"         35 minutes ago      Up 35 minutes       0.0.0.0:32832->4567/tcp          ansiblefest_foo_production_2
281feaaf7801        ansiblefest_foo_production   "sleep infinity"         35 minutes ago      Up 35 minutes       0.0.0.0:32831->4567/tcp          ansiblefest_foo_production_3
28491d3b7004        ansiblefest_foo_staging      "sleep infinity"         35 minutes ago      Up 35 minutes       0.0.0.0:32830->4567/tcp          ansiblefest_foo_staging_2
bc56fd64848e        cyberark/conjur              "conjurctl server ..."   35 minutes ago      Up 35 minutes       80/tcp, 0.0.0.0:3000->3000/tcp   ansiblefest_conjur_1
1745b25df6a0        postgres:9.3                 "docker-entrypoint..."   35 minutes ago      Up 35 minutes       5432/tcp                         ansiblefest_pg_1
cd22a04ed277        ansiblefest_foo_production   "sleep infinity"         35 minutes ago      Up 35 minutes       0.0.0.0:32829->4567/tcp          ansiblefest_foo_production_1
08136c4ea9e5        ansiblefest_foo_staging      "sleep infinity"         35 minutes ago      Up 35 minutes       0.0.0.0:32828->4567/tcp          ansiblefest_foo_staging_1
```

For the above example, the first container (`37881ae9a161`), can be viewed on port `32833`: `0.0.0.0:32833->4567/tcp`. This container is accessible via:

http://localhost:32833
